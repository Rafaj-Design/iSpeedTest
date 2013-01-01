//
//  STHistoryCell.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 29/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STHistoryCell.h"
#import "STHistory.h"
#import "STSpeedtest.h"
#import "STAnnotationView.h"
#import "STAnnotation.h"
#import "STHomeViewController.h"
#import "STSharingObject.h"


@interface STHistoryCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *connectionLabel;
@property (nonatomic, strong) UILabel *downloadMegabyteLabel;
@property (nonatomic, strong) UILabel *downloadMegabitLabel;
@property (nonatomic, strong) UILabel *uploadMegabyteLabel;
@property (nonatomic, strong) UILabel *uploadMegabitLabel;

@property (nonatomic, strong) STHistory *history;

@property (nonatomic, strong) MKMapView *mapView;

@end


@implementation STHistoryCell


#pragma mark Creating elements

- (UILabel *)labelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithHexString:@"3a3c3c"]];
    [label setFont:[STConfig fontWithSize:10]];
    return label;
}

- (void)createLabels {
    _dateLabel = [self labelWithFrame:CGRectMake(15, 12, 110, 18)];
    [self addSubview:_dateLabel];
    
    _connectionLabel = [self labelWithFrame:CGRectMake(15, 30, 110, 18)];
    [_connectionLabel setTextColor:[UIColor colorWithHexString:@"48C9A8"]];
    [_connectionLabel setFont:[STConfig fontWithSize:8]];
    [self addSubview:_connectionLabel];
    
    _downloadMegabyteLabel = [self labelWithFrame:CGRectMake(130, 12, 110, 18)];
    [self addSubview:_downloadMegabyteLabel];

    _downloadMegabitLabel = [self labelWithFrame:CGRectMake(130, 28, 110, 18)];
    [self addSubview:_downloadMegabitLabel];

    _uploadMegabyteLabel = [self labelWithFrame:CGRectMake(218, 12, 110, 18)];
    [self addSubview:_uploadMegabyteLabel];

    _uploadMegabitLabel = [self labelWithFrame:CGRectMake(218, 28, 110, 18)];
    [self addSubview:_uploadMegabitLabel];
}

- (void)createMapView {
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(15, 60, 250, 110)];
    [_mapView setDelegate:self];
    [_mapView setShowsUserLocation:NO];
    [_mapView.layer setCornerRadius:5];
    [_mapView.layer setBorderWidth:1];
    [_mapView.layer setBorderColor:[UIColor colorWithHexString:@"E6E5C9"].CGColor];
    [self addSubview:_mapView];
    
    STAnnotation *a = [[STAnnotation alloc] initWithHistoryItem:_history];
    [_mapView addAnnotation:a];
    
    CLLocationCoordinate2D c = CLLocationCoordinate2DMake([_history.lat floatValue], [_history.lon floatValue]);
    MKCoordinateRegion region;
    region.center = c;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    region.span = span;
    
    [_mapView setRegion:region animated:YES];
}

- (void)createSharingButtons {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(shareOnFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [b setFrame:CGRectMake(275, 60, 30, 30)];
    [b setBackgroundColor:[UIColor clearColor]];
    [b setImage:[UIImage imageNamed:@"SP_sharing_fb"] forState:UIControlStateNormal];
    [self addSubview:b];
    
    b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(shareOnTwitter:) forControlEvents:UIControlEventTouchUpInside];
    [b setFrame:CGRectMake(275, (60 + 40), 30, 30)];
    [b setBackgroundColor:[UIColor clearColor]];
    [b setImage:[UIImage imageNamed:@"SP_sharing_tw"] forState:UIControlStateNormal];
    [self addSubview:b];
    
    b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(shareViaEmail:) forControlEvents:UIControlEventTouchUpInside];
    [b setFrame:CGRectMake(275, (60 + 80), 30, 30)];
    [b setBackgroundColor:[UIColor clearColor]];
    [b setImage:[UIImage imageNamed:@"SP_sharing_em"] forState:UIControlStateNormal];
    [self addSubview:b];
}

#pragma mark Actions

- (STSharingObject *)getSharingObject {
    STSharingObject *s = [[STSharingObject alloc] init];
    [s setHistory:_history];
    
    // Taking screenshot of the map
    UIGraphicsBeginImageContextWithOptions(_mapView.bounds.size, _mapView.opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_mapView.layer renderInContext:context];
    [s setMapImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    
    return s;
}

- (void)shareOnFacebook:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(shareOnFacebook:)]) {
        [_delegate shareOnFacebook:[self getSharingObject]];
    }
}

- (void)shareOnTwitter:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(shareOnTwitter:)]) {
        [_delegate shareOnTwitter:[self getSharingObject]];
    }
}

- (void)shareViaEmail:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(shareViaEmail:)]) {
        [_delegate shareViaEmail:[self getSharingObject]];
    }
}

#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createLabels];
        [self createSharingButtons];
        [self setClipsToBounds:YES];
    }
    return self;
}

#pragma mark Settings

- (void)setHistory:(STHistory *)history {
    _history = history;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yy h:mma"];
    [_dateLabel setText:[dateFormat stringFromDate:history.date]];
    [_connectionLabel setText:[NSString stringWithFormat:@"%@ (%@)", _history.network, _history.connection]];
    [_downloadMegabyteLabel setText:[NSString stringWithFormat:@"%.1f MB/s", [STSpeedtest getMegabytes:[_history.download floatValue]]]];
    [_downloadMegabitLabel setText:[NSString stringWithFormat:@"%.1f MBit/s", [STSpeedtest getMegabites:[_history.download floatValue]]]];
    [_uploadMegabyteLabel setText:[NSString stringWithFormat:@"%.1f MB/s", [STSpeedtest getMegabytes:[_history.upload floatValue]]]];
    [_uploadMegabitLabel setText:[NSString stringWithFormat:@"%.1f MBit/s", [STSpeedtest getMegabites:[_history.upload floatValue]]]];
}

- (void)enableMap:(BOOL)enable {
    if (enable) [self createMapView];
    else {
        if (_mapView) [_mapView removeFromSuperview];
        _mapView = nil;
    }
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
        [h jsonValue];
        [annotationView setHistoryItem:h];
        return annotationView;
    }
    return nil;
}


@end
