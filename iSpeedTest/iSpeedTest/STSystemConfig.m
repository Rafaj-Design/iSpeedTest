//
//  STSystemConfig.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 30/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STSystemConfig.h"
#import "FTKeychainWrapper.h"


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

#pragma mark UUID

+ (NSString *)getNewUUID {
    NSString *result = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    assert(uuidStr != NULL);
    result = [(__bridge NSString *)uuidStr copy];
    CFRelease(uuidStr);
    NSLog(@"UUID: %@", result);
    return result;
}

+ (NSString *)getAppIdUUIDIdentifier {
    return [@"iSpeedTestUUID" stringByAppendingString:[STConfig appIdentifier]];
}

+ (NSString *)getAppUUID {
    FTKeychainWrapper *w = [[FTKeychainWrapper alloc] initWithIdentifier:[self getAppIdUUIDIdentifier] accessGroup:nil];
    NSString *uuid = [w objectForKey:(__bridge id)(kSecValueData)];
    if (!uuid || [uuid length] < 5) {
        uuid = [self getNewUUID];
        [w setObject:uuid forKey:(__bridge id)(kSecValueData)];
    }
    NSLog(@"UUID: %@", uuid);
    return uuid;
}


@end
