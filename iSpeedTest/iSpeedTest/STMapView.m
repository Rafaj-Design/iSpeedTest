//
//  STMapView.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STMapView.h"


@interface STMapView ()

@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) UIImageView *overlayView;

@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UIButton *myResultsButton;
@property (nonatomic, strong) UIButton *allResultsButton;

@end


@implementation STMapView


#pragma mark Creating elements

- (void)createOverlays {
    _overlayView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_bg_map_overlay"]];
    [_overlayView setUserInteractionEnabled:NO];
    [self addSubview:_overlayView];
}

- (void)createFilterButtons {
    _filterView = [[UIView alloc] initWithFrame:CGRectMake(50, (self.height - 78), 210, 38)];
    [_filterView.layer setCornerRadius:5];
    [_filterView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8]];
    [self addSubview:_filterView];
}

- (void)createMapView {
    _mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    [_mapView setShowsUserLocation:YES];
    [self addSubview:_mapView];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    [self createMapView];
    [self createOverlays];
    [self createFilterButtons];
}


@end
