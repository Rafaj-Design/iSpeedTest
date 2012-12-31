//
//  STMapView.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STSubsectionView.h"
#import <MapKit/MapKit.h>


@interface STMapView : STSubsectionView <MKMapViewDelegate>

- (void)zoomToSeeAllAnnotations;


@end
