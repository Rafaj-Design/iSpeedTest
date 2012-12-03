//
//  STAnnotationView.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 03/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <MapKit/MapKit.h>


@class STHistory;


@interface STAnnotationView : MKAnnotationView

@property (nonatomic, strong, readonly) STHistory *historyItem;

- (void)setHistoryItem:(STHistory *)item;


@end
