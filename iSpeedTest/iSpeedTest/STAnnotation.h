//
//  STAnnotation.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 03/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@class STHistory;


@interface STAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong, readonly) STHistory *historyItem;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *subtitle;

- (id)initWithHistoryItem:(STHistory *)item;


@end
