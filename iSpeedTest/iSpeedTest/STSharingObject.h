//
//  STSharingObject.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 01/01/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STHistory.h"


@interface STSharingObject : NSObject

@property (nonatomic, strong) STHistory *history;
@property (nonatomic, strong) UIImage *mapImage;

- (NSString *)getSharingText;
- (NSString *)getFullSharingText;


@end
