//
//  MBSystemHelper.m
//  stats
//
//  Created by hdb on 8/17/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
//

#import "STSSystemHelper.h"

#define CTL_HW          6               /* generic cpu/io */
#define HW_NCPU          3              /* int: number of cpus */
#define CTL_KERN        1               /* "high kernel": proc, limits */
#define KERN_BOOTTIME           21      /* struct: time kernel was booted */

@implementation STSSystemHelper {
    // some stuff we need to read CPU information
    processor_info_array_t cpuInfo, prevCpuInfo;
    mach_msg_type_number_t numCpuInfo, numPrevCpuInfo;
    unsigned numCPUs;
    NSTimer *updateTimer;
    NSLock *CPUUsageLock;
    
    
    float cpu_user;
    float cpu_sys;
    float cpu_nice;
    float cpu_idle;
}

-(id) init
{
    self = [super init];
    self.server_pwd = [[NSUserDefaults standardUserDefaults] stringForKey:@"server_pwd"];
    self.playerisRegistered = [[NSUserDefaults standardUserDefaults] boolForKey:@"playerisRegistered"];
    self.login_state = FALSE;

    // need stuff for memory
    int mib[2U] = { CTL_HW, HW_NCPU };
    size_t sizeOfNumCPUs = sizeof(numCPUs);
    int status = sysctl(mib, 2U, &numCPUs, &sizeOfNumCPUs, NULL, 0U);
    if(status)
        numCPUs = 1;

    self.heartbeatFrequency = 30;
    self.lastNetworkTime = -1;
    self.lastNetwork = nil;

    self.heartbeatFrequency = 30;
    self.lastNetworkTime = -1;
    self.lastNetwork = nil;

    self.screenshotNow  = YES;
    self.screenshotFrequency  = 1800;
    self.currentScreenshotWaittime  =self.screenshotFrequency;
    self.screenshotWidth  =185;
    self.screenshotHeight =185;

    self.groupIds = [[NSMutableArray alloc] init];
    self.groupIdAndExpires = [[NSMutableDictionary alloc] init];
    self.groupIdPlaylists = [[NSMutableDictionary alloc] init];
//    NSString *folder = [s3temp objectForKey:@"folder"];

    self.immediately = @"";
    self.immediatelyid = @"";
    self.programPath = @"";
    self.channelPath = @"";

    return self;
}

+ (NSDictionary *) obtainMemoryData {
  mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
  vm_statistics_data_t vmstat;
  if (host_statistics (mach_host_self (), HOST_VM_INFO, (host_info_t) &vmstat, &count) != KERN_SUCCESS)
  {
      fprintf (stderr, "Failed to get VM statistics.");
  }
  
  mach_msg_type_number_t count64 = HOST_VM_INFO_COUNT;
  vm_statistics64_data_t vmstat64;
  if (host_statistics (mach_host_self (), HOST_VM_INFO, (host_info_t) &vmstat64, &count64) != KERN_SUCCESS)
  {
      fprintf (stderr, "Failed to get VM statistics.");
  }

  double total = vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count;
  double wired = vmstat.wire_count / total;
  double active = vmstat.active_count / total;
  double inactive = vmstat.inactive_count / total;
  double free = vmstat.free_count / total;
  
  double pageins = vmstat.pageins / total;
  double pageouts = vmstat.pageouts / total;
  double swapins = vmstat64.swapins / total;
  double swapouts = vmstat64.swapouts / total;
  
  // Found this structure from this blogpost: https://www.it-swarm.dev/es/c%2B%2B/como-determinar-el-consumo-de-cpu-y-memoria-desde-dentro-de-un-proceso/957435470/
  // Based on this pascal implementation: https://wiki.freepascal.org/Accessing_macOS_System_Information
  // Also in this delphi implementation: https://forum.lazarus.freepascal.org/index.php?topic=45817.0
  typedef struct xsw_usage  xsw_usage_data_t;
  xsw_usage_data_t vmusage = {0};
  size_t size = sizeof(vmusage);
  if( sysctlbyname("vm.swapusage", &vmusage, &size, NULL, 0)!=0 )
  {
     perror( "unable to get swap usage by calling sysctlbyname(\"vm.swapusage\",...)" );
  }
  double swaptotal = vmusage.xsu_total / 1024 / 1024; // MB
  double swapused = vmusage.xsu_used  / 1024 / 1024; // MB
  
  return @{
    @"free": [NSNumber numberWithDouble:free],
    @"active": [NSNumber numberWithDouble:active],
    @"inactive": [NSNumber numberWithDouble:inactive],
    @"wired": [NSNumber numberWithDouble:wired],
    @"pageins": [NSNumber numberWithDouble:pageins],
    @"pageouts": [NSNumber numberWithDouble:pageouts],
    @"swapins": [NSNumber numberWithDouble:swapins],
    @"swapouts": [NSNumber numberWithDouble:swapouts],
    @"swaptotal": [NSNumber numberWithDouble:swaptotal],
    @"swapused": [NSNumber numberWithDouble:swapused],
  };
}

- (NSDictionary *) obtainDataSystatus
{
    NSMutableDictionary *stats=[[NSMutableDictionary alloc] init];

    double loadavg[3];
    getloadavg(loadavg,3);

    NSString *load = [NSString stringWithFormat:@"%.02f, %.02f %.02f", loadavg[0],loadavg[1],loadavg[2]];

    stats[@"load"] = load;

    NSArray *networkInfo = [STSIPAddressHelper getDataCounters];

    NSMutableArray *network = [[NSMutableArray alloc]init];
    unsigned long in_per_s=0;
    unsigned long out_per_s=0;

    NSTimeInterval current = [NSDate timeIntervalSinceReferenceDate];
    if (self.lastNetwork != nil)
    {
        // calculate in/out per second
        NSTimeInterval delta=current-self.lastNetworkTime;
        if (delta>0)
        {
            in_per_s = (unsigned long) (([(NSNumber *) networkInfo[1] unsignedLongValue] - [(NSNumber *) self.lastNetwork[1] unsignedLongValue]) / delta);
            out_per_s = (unsigned long) (([(NSNumber *) networkInfo[0] unsignedLongValue] - [(NSNumber *) self.lastNetwork[0] unsignedLongValue]) / delta);
        }
    }
    self.lastNetwork=networkInfo;
    self.lastNetworkTime=current;

    // we label this en0 because this is the interface we consider "connected"
    [network addObject:@""]; // this is an unknown identifier
    [network addObject:@"en0"]; // system name
    [network addObject:@"WIFI"]; // type
    [network addObject:[STSIPAddressHelper getIPAddress:TRUE]];
    [network addObject:@"WIFI"]; // device name
    [network addObject:[NSArray array]]; // unknown
    [network addObject:@[
        [NSString stringWithFormat:@"%@/S", [STSIPAddressHelper formattedDataVolumeInt:in_per_s useKBasMinimum:TRUE]],// in/s
        [NSString stringWithFormat:@"%@/S", [STSIPAddressHelper formattedDataVolumeInt:out_per_s useKBasMinimum:TRUE]], // out/s
        [STSIPAddressHelper formattedDataVolume:[(NSNumber *) networkInfo[1] unsignedLongValue]], // intotal
        [STSIPAddressHelper formattedDataVolume:[(NSNumber *) networkInfo[0] unsignedLongValue]]]];

    stats[@"network"] = @[network];

    NSMutableArray *memory = [[NSMutableArray alloc]init];

    /* read memory information */

    mach_port_t             host_port = mach_host_self();
    mach_msg_type_number_t  host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t    vm_stat;

    host_page_size(host_port,
        &pagesize);

    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
//        NSLog(@"💓 Failed to fetch vm statistics");
    }

    natural_t   mem_used = (natural_t) ((vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize);
    natural_t   mem_free = (natural_t) (vm_stat.free_count * pagesize);
    //natural_t   mem_total = mem_used + mem_free;


    [memory addObject:[NSString stringWithFormat:@"%fGB", (mem_free/(1024.0*1024*1024))]];//, free
    [memory addObject:@"0GB"];//,
    [memory addObject:[NSString stringWithFormat:@"%fGB", (mem_used/(1024.0*1024*1024))]];//, active - "used" memory on iPad
    [memory addObject:@"0GB"];//, inactive - unused on iOS
    [memory addObject:@"0GB"];//, wired - unused on iOS
    [memory addObject:@"0.0"];//,
    [memory addObject:@[
        @"0", //, PageIn
        @"0"
    ]];
    [memory addObject:@[
        @"0",//, PageOut
        @"0"
    ]];
    [memory addObject:@"0GB"];//,
    [memory addObject:@"0MB/0.0GB"];// swap (used, all)

    stats[@"memoryUsage"] = memory;

    [self updateCPUInfo];

    NSMutableArray *cpu = [[NSMutableArray alloc]init];
    [cpu addObject:@(cpu_user)];//, CpuUser
    [cpu addObject:@(cpu_sys)];//, CpuSys
    [cpu addObject:@(cpu_nice)];//, CpuNice
    [cpu addObject:@(cpu_idle)];//, CpuIdle

    stats[@"cpuUsage"] = @[cpu];

    NSMutableArray *disks = [[NSMutableArray alloc]init];

    NSArray *diskSpace=[self getDiskspace];

    int diskFree = (int) ([diskSpace[1] integerValue] - [diskSpace[0] integerValue]);
    [disks addObject:@"SSD"];//    Label
    [disks addObject:@"0"];//,    Capacity used (Perc)
    [disks addObject:[NSString stringWithFormat:@"%iMB", diskFree]];//,    Total capacity - Free Capicity = free Capacity
    [disks addObject:[NSString stringWithFormat:@"%@MB", diskSpace[0]]];//,    Free space
    [disks addObject:@"/"];//,Mount point
    [disks addObject:@""];//,    ouch
    [disks addObject:@""];//    disk identifier (guess this can be empty string)
    stats[@"diskUsage"] = @[disks];
    stats[@"uptime"] = [NSString stringWithFormat:@"%lds", [self uptime]];
    //  [stats setObject:[self toDateString:[self uptime]] forKey:@"uptime"];
    return stats;
}

- (time_t)uptime
{
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;

    (void)time(&now);

    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        uptime = now - boottime.tv_sec;
    }
    return uptime;
}

-(NSArray *)getDiskspace {
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
#if !TARGET_OS_TV
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
#else
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
#endif
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];

    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = dictionary[NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = dictionary[NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
    }

    return @[
        @((totalFreeSpace / 1024ll) / 1024ll),
        @((totalSpace / 1024ll) / 1024ll)
    ];
}

- (void)updateCPUInfo {
    cpu_user = 0;
    cpu_sys = 0;
    cpu_nice = 0;
    cpu_idle = 0;
    
    kern_return_t kr;
    mach_msg_type_number_t count;
    host_cpu_load_info_data_t r_load;

    count = HOST_CPU_LOAD_INFO_COUNT;
    kr = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (int *)&r_load, &count);
    if (kr != KERN_SUCCESS) {
        printf("oops: %s\n", mach_error_string(kr));
        return;
    }

    cpu_sys = r_load.cpu_ticks[CPU_STATE_SYSTEM];
    cpu_user = r_load.cpu_ticks[CPU_STATE_USER] + r_load.cpu_ticks[CPU_STATE_NICE];
    cpu_idle = r_load.cpu_ticks[CPU_STATE_IDLE];
    cpu_nice = r_load.cpu_ticks[CPU_STATE_NICE];
    
}

@end
