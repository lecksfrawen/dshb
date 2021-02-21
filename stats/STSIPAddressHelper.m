//
//  MBIPAddressHelper.m
//  iMediaBrowser
//
//  Created by Lars Grunewaldt on 02.04.14.
//  Copyright (c) 2014 VIDERO. All rights reserved.
//

#import "STSIPAddressHelper.h"

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@implementation STSIPAddressHelper



#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_WIFIB       @"en1"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *ip4First = @[
        IOS_WIFI @"/" IP_ADDR_IPv4,
        IOS_WIFI @"/" IP_ADDR_IPv6,
        IOS_WIFIB @"/" IP_ADDR_IPv4,
        IOS_WIFIB @"/" IP_ADDR_IPv6,
        IOS_CELLULAR @"/" IP_ADDR_IPv4,
        IOS_CELLULAR @"/" IP_ADDR_IPv6
    ];
    NSArray *ip6First = @[
        IOS_WIFI @"/" IP_ADDR_IPv6,
        IOS_WIFI @"/" IP_ADDR_IPv4,
        IOS_WIFIB @"/" IP_ADDR_IPv6,
        IOS_WIFIB @"/" IP_ADDR_IPv4,
        IOS_CELLULAR @"/" IP_ADDR_IPv6,
        IOS_CELLULAR @"/" IP_ADDR_IPv4
    ];
    NSArray *searchArray = preferIPv4 ? ip4First : ip6First;
    
    NSDictionary *addresses = [STSIPAddressHelper getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    NSString *result = address ? address : @"0.0.0.0";
    return result;
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (NSArray *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
//            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
//                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
//                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:(WiFiSent+WWANSent)], [NSNumber numberWithFloat:(WiFiReceived+WWANReceived)],[NSNumber numberWithFloat:WiFiSent], [NSNumber numberWithFloat:WiFiReceived],[NSNumber numberWithFloat:WWANSent],[NSNumber numberWithFloat:WWANReceived], nil];
}

// return a string that represents the data in a "sane metric".
// 0-999=B
// 1.000-999.999 = KB (10^3)
// 1.000.000-999.999.999 = MB (10^6)
// 1.000.000.000-999.999.999.999 = GB (10^9)
// 1.000.000.000.000-X = TB (10^12)

+ (NSString *) formattedDataVolume:(unsigned long) amount useKBasMinimum:(BOOL)useKBasMinimum
{
    NSString *fmt = @"";
    float fct=1;
    if (amount>=__exp10(12))
    {
        fct=__exp10(12);
        fmt=@"TB";
    }else if (amount>=__exp10(9))
    {
        fct=__exp10(9);
        fmt=@"GB";
    }else if (amount>=__exp10(6))
    {
        fct=__exp10(6);
        fmt=@"MB";
    }else if (amount>=__exp10(3) || useKBasMinimum)
    {
        fct=__exp10(3);
        fmt=@"KB";
    }
    return [NSString stringWithFormat:@"%.02f%@",amount/fct,fmt ];
}

// Wrapper
+ (NSString *) formattedDataVolume:(unsigned long) amount

{
    return [STSIPAddressHelper formattedDataVolume:amount useKBasMinimum:FALSE];
}

// return a string that represents the data in a "sane metric".
// 0-999=B
// 1.000-999.999 = KB (10^3)
// 1.000.000-999.999.999 = MB (10^6)
// 1.000.000.000-999.999.999.999 = GB (10^9)
// 1.000.000.000.000-X = TB (10^12)

+ (NSString *) formattedDataVolumeInt:(unsigned long) amount useKBasMinimum:(BOOL)useKBasMinimum
{
    NSString *fmt = @"";
    float fct=1;
    if (amount>=__exp10(12))
    {
        fct=__exp10(12);
        fmt=@"TB";
    }else if (amount>=__exp10(9))
    {
        fct=__exp10(9);
        fmt=@"GB";
    }else if (amount>=__exp10(6))
    {
        fct=__exp10(6);
        fmt=@"MB";
    }else if (amount>=__exp10(3) || useKBasMinimum)
    {
        fct=__exp10(3);
        fmt=@"KB";
    }
    return [NSString stringWithFormat:@"%d%@",(int)(amount/fct),fmt ];
}

// Wrapper
+ (NSString *) formattedDataVolumeInt:(unsigned long) amount

{
    return [STSIPAddressHelper formattedDataVolumeInt:amount useKBasMinimum:FALSE];
}



@end
