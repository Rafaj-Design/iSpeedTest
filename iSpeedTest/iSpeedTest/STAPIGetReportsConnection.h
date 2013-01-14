//
//  STAPIGetReportsConnection.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 10/01/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "STAPIConnection.h"
#import <MapKit/MapKit.h>


@class STAPIGetReportsConnection;

@protocol STAPIGetReportsConnectionDelegate <NSObject>

- (void)apiGetReportsConnection:(STAPIGetReportsConnection *)conection gotResults:(NSArray *)results;

@end


@interface STAPIGetReportsConnection : STAPIConnection

@property (nonatomic, readonly) MKCoordinateRegion selectedRegion;
@property (nonatomic, weak) id <STAPIGetReportsConnectionDelegate> getDelegate;

- (void)getAllReports;
- (void)getReportsForRegion:(MKCoordinateRegion)region;


@end
