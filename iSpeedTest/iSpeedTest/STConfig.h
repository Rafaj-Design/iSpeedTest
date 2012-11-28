//
//  STConfig.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface STConfig : NSObject

+ (NSString *)appName;

+ (NSString *)appIdentifier;

+ (NSString *)appSqlFileName;

+ (NSString *)documentsDirectory;

+ (NSURL *)documentsDirectoryUrl;

+ (UIFont *)fontWithSize:(CGFloat)size;


@end
