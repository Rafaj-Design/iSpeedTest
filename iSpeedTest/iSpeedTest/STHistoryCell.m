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
#import "UILabel+DynamicHeight.h"
#import "STAppDelegate.h"
#import <AddressBook/AddressBook.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>


@interface STHistoryCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *connectionLabel;
@property (nonatomic, strong) UILabel *downloadMegabyteLabel;
@property (nonatomic, strong) UILabel *downloadMegabitLabel;
@property (nonatomic, strong) UILabel *uploadMegabyteLabel;
@property (nonatomic, strong) UILabel *uploadMegabitLabel;

@property (nonatomic, strong) UILabel *downloadKilobyteLabel;
@property (nonatomic, strong) UILabel *downloadKilobitLabel;
@property (nonatomic, strong) UILabel *uploadKilobyteLabel;
@property (nonatomic, strong) UILabel *uploadKilobitLabel;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) UILabel *addressLabel;

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
    
    _downloadKilobyteLabel = [self labelWithFrame:CGRectMake(130, 12, 110, 18)];
    [_downloadKilobyteLabel setAlpha:0];
    [self addSubview:_downloadKilobyteLabel];
    
    _downloadKilobitLabel = [self labelWithFrame:CGRectMake(130, 28, 110, 18)];
    [_downloadKilobitLabel setAlpha:0];
    [self addSubview:_downloadKilobitLabel];
    
    _uploadKilobyteLabel = [self labelWithFrame:CGRectMake(218, 12, 110, 18)];
    [_uploadKilobyteLabel setAlpha:0];
    [self addSubview:_uploadKilobyteLabel];
    
    _uploadKilobitLabel = [self labelWithFrame:CGRectMake(218, 28, 110, 18)];
    [_uploadKilobitLabel setAlpha:0];
    [self addSubview:_uploadKilobitLabel];
    
}

- (void)createMapView {
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(15, 80, 250, 110)];
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

- (void)createDetailInfo {
    _addressLabel = [self labelWithFrame:CGRectMake(15, 44, 290, 36)];
    [_addressLabel setAlpha:0];
    [_addressLabel setNumberOfLines:3];
    [_addressLabel setFont:[STConfig fontWithSize:8]];
    [self addSubview:_addressLabel];
}

- (void)createSharingButtons {
    CGFloat x = 275;
    CGFloat y = 80;
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(shareOnFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [b setFrame:CGRectMake(x, y, 30, 30)];
    [b setBackgroundColor:[UIColor clearColor]];
    [b setImage:[UIImage imageNamed:@"SP_sharing_fb"] forState:UIControlStateNormal];
    [self addSubview:b];
    
    b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(shareOnTwitter:) forControlEvents:UIControlEventTouchUpInside];
    [b setFrame:CGRectMake(x, (y + 40), 30, 30)];
    [b setBackgroundColor:[UIColor clearColor]];
    [b setImage:[UIImage imageNamed:@"SP_sharing_tw"] forState:UIControlStateNormal];
    [self addSubview:b];
    
    b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b addTarget:self action:@selector(shareViaEmail:) forControlEvents:UIControlEventTouchUpInside];
    [b setFrame:CGRectMake(x, (y + 80), 30, 30)];
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
    
    [s setAddress:_address];
    
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
        [self createDetailInfo];
        [self setClipsToBounds:YES];
    }
    return self;
}

#pragma mark Address loading

- (void)setAddressText:(NSString *)text {
    [_addressLabel setText:text];
}

- (void)loadAddressOnBackground {
    @autoreleasepool {
        CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
        if (reverseGeocoder) {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[_history.lat doubleValue] longitude:[_history.lon doubleValue]];
            [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                if (error) {
                    [Flurry logError:@"CoreLocation error" message:@"reverseGeocodeLocation" error:error];
                }
                CLPlacemark *placemark = ([placemarks count] > 0) ? [placemarks objectAtIndex:0] : nil;
                if (placemark) {
                    NSMutableArray *addressArr = [NSMutableArray array];
                    
                    NSString *streetName = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey];
                    if (streetName) [addressArr addObject:streetName];
                    
                    NSString *cityName = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
                    if (cityName) [addressArr addObject:cityName];
                    
                    NSString *zipCode = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey];
                    if (zipCode) [addressArr addObject:zipCode];
                    
                    NSString *stateName = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
                    if (stateName) [addressArr addObject:stateName];
                    
                    NSString *countryName = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressCountryKey];
                    if (countryName) [addressArr addObject:countryName];
                    
                    _address = [addressArr componentsJoinedByString:@", "];
                    [_history setName:_address];
                    NSError *err;
                    [kSTManagedObject save:&err];
                    if (err) {
                        [Flurry logError:@"CoreData error" message:@"save" error:error];
                    }
                    [self performSelectorOnMainThread:@selector(setAddressText:) withObject:_address waitUntilDone:NO];
                }
            }];
        }
        else {
            [self performSelectorOnMainThread:@selector(setAddressText:) withObject:@"" waitUntilDone:NO];
        }
    }
}

- (void)startLoadingAddressOnBackground {
    @autoreleasepool {
        [self performSelectorInBackground:@selector(loadAddressOnBackground) withObject:nil];
    }
}

#pragma mark Settings

- (void)showBasicSpeedInfo {
    [_downloadKilobyteLabel setAlpha:0];
    [_downloadKilobitLabel setAlpha:0];
    [_uploadKilobyteLabel setAlpha:0];
    [_uploadKilobitLabel setAlpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        [_downloadMegabyteLabel setAlpha:1];
        [_downloadMegabitLabel setAlpha:1];
        [_uploadMegabyteLabel setAlpha:1];
        [_uploadMegabitLabel setAlpha:1];
    }];
}

- (void)showAdvancedSpeedInfo {
    [_downloadMegabyteLabel setAlpha:0];
    [_downloadMegabitLabel setAlpha:0];
    [_uploadMegabyteLabel setAlpha:0];
    [_uploadMegabitLabel setAlpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        [_downloadKilobyteLabel setAlpha:1];
        [_downloadKilobitLabel setAlpha:1];
        [_uploadKilobyteLabel setAlpha:1];
        [_uploadKilobitLabel setAlpha:1];
    }];
}

- (void)setHistory:(STHistory *)history {
    _history = history;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yy h:mma"];
    [_dateLabel setText:[dateFormat stringFromDate:history.date]];
    [_connectionLabel setText:[NSString stringWithFormat:@"%@ (%@)", _history.network, _history.connection]];
    [_downloadMegabyteLabel setText:[NSString stringWithFormat:@"%.2f MB/s", [STSpeedtest getMegabytes:[_history.download floatValue]]]];
    [_downloadMegabitLabel setText:[NSString stringWithFormat:@"%.2f MBit/s", [STSpeedtest getMegabites:[_history.download floatValue]]]];
    [_uploadMegabyteLabel setText:[NSString stringWithFormat:@"%.2f MB/s", [STSpeedtest getMegabytes:[_history.upload floatValue]]]];
    [_uploadMegabitLabel setText:[NSString stringWithFormat:@"%.2f MBit/s", [STSpeedtest getMegabites:[_history.upload floatValue]]]];

    [_downloadKilobyteLabel setText:[NSString stringWithFormat:@"%.1f kB/s", [STSpeedtest getKilobytes:[_history.download floatValue]]]];
    [_downloadKilobitLabel setText:[NSString stringWithFormat:@"%.1f kBit/s", [STSpeedtest getKilobites:[_history.download floatValue]]]];
    [_uploadKilobyteLabel setText:[NSString stringWithFormat:@"%.1f kB/s", [STSpeedtest getKilobytes:[_history.upload floatValue]]]];
    [_uploadKilobitLabel setText:[NSString stringWithFormat:@"%.1f kBit/s", [STSpeedtest getKilobites:[_history.upload floatValue]]]];
    
    _address = nil;
}

- (void)enableMap:(BOOL)enable {
    if (enable) {
        [self createMapView];
    }
    else {
        if (_mapView) [_mapView removeFromSuperview];
        _mapView = nil;
    }
}

- (void)showAdvancedInfo:(BOOL)show {
    if (show) {
        [UIView animateWithDuration:0.3 animations:^{
            [_downloadMegabyteLabel setAlpha:0];
            [_downloadMegabitLabel setAlpha:0];
            [_uploadMegabyteLabel setAlpha:0];
            [_uploadMegabitLabel setAlpha:0];
            [_addressLabel setAlpha:1];
        } completion:^(BOOL finished) {
            [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(showAdvancedSpeedInfo) userInfo:nil repeats:NO];
            if ([_history.name length] < 5) [NSThread detachNewThreadSelector:@selector(startLoadingAddressOnBackground) toTarget:self withObject:nil];
            else [self setAddressText:_history.name];
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            [_downloadKilobyteLabel setAlpha:0];
            [_downloadKilobitLabel setAlpha:0];
            [_uploadKilobyteLabel setAlpha:0];
            [_uploadKilobitLabel setAlpha:0];
            [_addressLabel setAlpha:0];
        } completion:^(BOOL finished) {
            [self showBasicSpeedInfo];
        }];
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
