//
//  STSystemConfig.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 30/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STSystemConfig.h"


@implementation STSystemConfig


#pragma mark Devices

+ (STDeviceType)deviceType {
    if([[UIScreen mainScreen] bounds].size.height == 568) {
        return STDeviceTypeiPhone5;
    }
    else return STDeviceTypeiPhone;
}

#pragma mark Positioning

+ (CGFloat)screenHeight {
    STDeviceType d = [self deviceType];
    if (d == STDeviceTypeiPhone5) {
        return 548;
    }
    else {
        return 460;
    }
}

+ (CGRect)fullscreenFrame:(BOOL)isLandscape {
    CGRect r = CGRectZero;
    STDeviceType d = [self deviceType];
    if (d != STDeviceTypeiPad) {
        if (d == STDeviceTypeiPhone5) {
            r.size = CGSizeMake(320, 547);
        }
        else {
            r.size = CGSizeMake(320, 460);
        }
    }
    else {
        if (isLandscape) {
            r.size = CGSizeMake(1024, 748);
        }
        else {
            r.size = CGSizeMake(768, 1004);
        }
    }
    return r;
}

#pragma mark Debug mode

+ (BOOL)isDebugModeEnabled {
    NSLog(@"Debug mode is enabled!");
    return kDebugMode;
}




@end
