//
//  MBSystemHelper.h
//  stats
//
//  Created by hdb on 8/17/20.
//  Copyright © 2020 Lecksfrawen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STSIPAddressHelper.h"
#import <sys/sysctl.h>
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/task_info.h>
#import <mach/task.h>
#import <libproc.h>

NS_ASSUME_NONNULL_BEGIN

@interface STSSystemHelper : NSObject

@property (nonatomic, retain) NSMutableDictionary * heartbeatData;
@property (nonatomic, retain) NSMutableDictionary * s3groupCredentials;
@property (nonatomic, retain) NSMutableDictionary * loginData;
@property (nonatomic, retain) NSMutableArray * groupIds;
@property (nonatomic, retain) NSMutableDictionary<NSNumber *, NSString*> * groupIdAndExpires;
@property (nonatomic, retain) NSMutableDictionary<NSNumber *, NSMutableSet<NSString *> *> * groupIdPlaylists;

@property (nonatomic,retain) NSString *server_hostname;
@property (nonatomic,retain) NSString *server_protocol;
@property (nonatomic,retain) NSString *server_port;
@property (nonatomic,retain) NSString *server_pwd;
@property (nonatomic,retain) NSString *immediately;
@property (nonatomic,retain) NSString *immediatelyid;
@property (nonatomic,retain) NSString *programPath;
@property (nonatomic,retain) NSString *channelPath;

@property (nonatomic,retain) NSString *heartbeatHost;
@property (nonatomic) unsigned int heartbeatFrequency;

@property (nonatomic, retain )NSArray *lastNetwork;
@property (nonatomic) NSTimeInterval lastNetworkTime;


@property (nonatomic) BOOL login_state;
@property (nonatomic) BOOL playerisRegistered;

@property (nonatomic) BOOL screenshotNow;
@property (nonatomic) int screenshotFrequency;
@property (nonatomic) int currentScreenshotWaittime;
@property (nonatomic) int screenshotWidth;
@property (nonatomic) int screenshotHeight;

- (NSDictionary *) obtainDataSystatus;
+ (NSDictionary *) obtainMemoryData;

@end

NS_ASSUME_NONNULL_END
