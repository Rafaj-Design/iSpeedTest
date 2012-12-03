//
//  STMapView.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STMapView.h"
#import "STAnnotationView.h"
#import "STAppDelegate.h"
#import "STHistory.h"
#import "STAnnotation.h"


@interface STMapView ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *annotations;

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
    _annotations = [NSMutableArray array];
    
    _mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    [_mapView setDelegate:self];
    [_mapView setShowsUserLocation:YES];
    [self addSubview:_mapView];
}

#pragma mark Settings

- (void)updateData {
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"STHistory" inManagedObjectContext:kSTManagedObject]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    _data = [kSTManagedObject executeFetchRequest:request error:&error];
    [_mapView removeAnnotations:_annotations];
    [_annotations removeAllObjects];
    for (STHistory *h in _data) {
        STAnnotation *a = [[STAnnotation alloc] initWithHistoryItem:h];
        [_mapView addAnnotation:a];
        [_annotations addObject:a];
    }
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    [self createMapView];
    [self updateData];
    [self createOverlays];
    //[self createFilterButtons];
}

#pragma mark Map view delegate methods

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    // Animating drop
    for (MKAnnotationView *aV in views) {
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        CGRect endFrame = aV.frame;
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options:UIViewAnimationCurveLinear animations:^{
            
            aV.frame = endFrame;
        } completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                } completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            aV.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];
    }
    
    // Zooming to the new region
	MKMapPoint annotationPoint = MKMapPointForCoordinate(_mapView.userLocation.coordinate);
    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    for (id <MKAnnotation> annotation in _mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        }
        else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [_mapView setVisibleMapRect:zoomRect animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKAnnotationView *annotationView = [mapView viewForAnnotation:userLocation];
    annotationView.canShowCallout = NO;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[STAnnotation class]]) {
        static NSString *annotationId = @"annotationId";
        STAnnotationView *annotationView = (STAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationId];
        if (!annotationView) {
            annotationView = [[STAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationId];
        }
        STHistory *h = [(STAnnotation *)annotation historyItem];
        [annotationView setHistoryItem:h];
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
}


@end
