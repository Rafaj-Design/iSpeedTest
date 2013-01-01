//
//  STSharingObject.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 01/01/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "STSharingObject.h"
#import "STSpeedtest.h"


@implementation STSharingObject

- (NSString *)getSharingText {
    STHistory *h = _history;
    NSString *c = ([h.connection isEqualToString:@"WiFi"]) ? h.connection : [NSString stringWithFormat:@"%@ - %@", h.network, h.connection];
    CGFloat d = [STSpeedtest getMegabites:[h.download floatValue]];
    CGFloat u = [STSpeedtest getMegabites:[h.upload floatValue]];
    return [NSString stringWithFormat:@"My connection speed (%@) is %.2f Mbit/s download and %.2f Mbit/s upload.", c, d, u];
}

- (NSString *)getFullSharingText {
    STHistory *h = _history;
    NSString *c = ([h.connection isEqualToString:@"WiFi"]) ? h.connection : [NSString stringWithFormat:@"%@ - %@", h.network, h.connection];
    CGFloat d = [STSpeedtest getMegabites:[h.download floatValue]];
    CGFloat u = [STSpeedtest getMegabites:[h.upload floatValue]];
    return [NSString stringWithFormat:@"My connection speed (%@) at %@%f %f is %.2f Mbit/s download and %.2f Mbit/s upload.", c, @"", [h.lon floatValue], [h.lat floatValue], d, u];
}


@end
