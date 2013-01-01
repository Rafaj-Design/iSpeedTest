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
    NSString *address = (_address) ? [NSString stringWithFormat:@" at %@", _address] : @"";
    return [NSString stringWithFormat:@"My connection speed (%@)%@ is %.2f Mbit/s download and %.2f Mbit/s upload. %@ app for iPhone", c, address, d, u, [STConfig appName]];
}

- (NSString *)getSharingTextNoAddress {
    STHistory *h = _history;
    NSString *c = ([h.connection isEqualToString:@"WiFi"]) ? h.connection : [NSString stringWithFormat:@"%@ - %@", h.network, h.connection];
    CGFloat d = [STSpeedtest getMegabites:[h.download floatValue]];
    CGFloat u = [STSpeedtest getMegabites:[h.upload floatValue]];
    return [NSString stringWithFormat:@"My connection speed (%@) is %.2f Mbit/s download and %.2f Mbit/s upload. From %@ app", c, d, u, [STConfig appName]];
}

- (NSString *)getFullSharingText {
    STHistory *h = _history;
    NSString *c = ([h.connection isEqualToString:@"WiFi"]) ? h.connection : [NSString stringWithFormat:@"%@ - %@", h.network, h.connection];
    CGFloat d = [STSpeedtest getMegabites:[h.download floatValue]];
    CGFloat u = [STSpeedtest getMegabites:[h.upload floatValue]];
    NSString *address = (_address) ? [NSString stringWithFormat:@"%@ (%f %f)", _address, [h.lon floatValue], [h.lat floatValue]] : [NSString stringWithFormat:@"%f %f", [h.lon floatValue], [h.lat floatValue]];
    return [NSString stringWithFormat:@"My connection speed (%@) at %@ is %.2f Mbit/s download and %.2f Mbit/s upload.", c, address, d, u];
}


@end
