//
//  STSystemConfig.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 30/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kDebugMode                                      YES

#define kSystemAPIConnectionUrl                         @"http://speedtest.fuerteint.com/api.php"


#define kDebug                                          [STSystemConfig isDebugModeEnabled]


typedef enum {
    STDeviceTypeiPhone,
    STDeviceTypeiPhone5,
    STDeviceTypeiPad
}
STDeviceType;


@interface STSystemConfig : NSObject

+ (STDeviceType)deviceType;
+ (CGRect)fullscreenFrame:(BOOL)isLandscape;
+ (CGFloat)screenHeight;

+ (BOOL)isDebugModeEnabled;


@end
