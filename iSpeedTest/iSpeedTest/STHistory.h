//
//  STHistory.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface STHistory : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * download;
@property (nonatomic, retain) NSNumber * upload;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSString * network;
@property (nonatomic, retain) NSString * connection;
@property (nonatomic, retain) NSNumber * ping;
@property (nonatomic, retain) NSNumber * submitted;
@property (nonatomic, retain) NSString * name;

@property (nonatomic, readonly) NSNumber *formattedDate;
@property (nonatomic, readonly) NSString *uuid;
@property (nonatomic, readonly) NSString *device;

- (NSString *)jsonValue;


@end
