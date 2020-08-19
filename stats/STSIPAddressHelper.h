//
//  MBIPAddressHelper.h
//  iMediaBrowser
//
//  Created by Lars Grunewaldt on 02.04.14.
//  Copyright (c) 2014 VIDERO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STSIPAddressHelper : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (NSArray *)getDataCounters;
+ (NSString *) formattedDataVolume:(unsigned long) amount;
+ (NSString *) formattedDataVolume:(unsigned long) amount useKBasMinimum:(BOOL)useKBasMinimum;

+ (NSString *) formattedDataVolumeInt:(unsigned long) amount;
+ (NSString *) formattedDataVolumeInt:(unsigned long) amount useKBasMinimum:(BOOL)useKBasMinimum;

@end
