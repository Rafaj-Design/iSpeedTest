//
//  STHistoryCell.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 29/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@class STHistory, STHomeViewController;


@interface STHistoryCell : UITableViewCell <MKMapViewDelegate>

@property (nonatomic, weak) STHomeViewController *delegate;


- (void)setHistory:(STHistory *)history;
- (void)enableMap:(BOOL)enable;
- (void)showAdvancedInfo:(BOOL)show;


@end
