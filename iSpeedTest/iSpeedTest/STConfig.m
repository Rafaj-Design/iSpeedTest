//
//  STConfig.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STConfig.h"


@implementation STConfig


#pragma mark App configuration

+ (NSString *)appName {
    return @"iSpeedTest";
}

+ (NSString *)appIdentifier {
    return [[[self appName] lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSString *)developerName {
    return @"Fuerte International";
}

+ (NSString *)developerUrl {
    return @"http://www.fuerteint.com/";
}

+ (NSString *)appSqlFileName {
    return [NSString stringWithFormat:@"%@.sqlite", [self appIdentifier]];
}

+ (NSString *)documentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSURL *)documentsDirectoryUrl {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (UIFont *)fontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"FamiliarPro-Bold" size:size];
}


@end
