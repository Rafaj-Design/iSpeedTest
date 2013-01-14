//
//  STAPIGetReportsConnection.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 10/01/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "STAPIGetReportsConnection.h"
#import "STHistory.h"


@implementation STAPIGetReportsConnection


#pragma mark Requests

- (void)getAllReports {
    //NSString *url = [kSystemAPIConnectionUrl stringByAppendingFormat:@"?type=%@", @"history"];
    //[super connectionForUrl:url];
}

- (void)getReportsForRegion:(MKCoordinateRegion)region {
    _selectedRegion = region;
    //NSString *url = [kSystemAPIConnectionUrl stringByAppendingFormat:@"?type=%@", @"history"];
    //[super connectionForUrl:url];
}

#pragma mark Connection delegate

- (void)connection:(NSURLConnection *)connection didFinishWithError:(NSError *)error {
    NSLog(@"Received data: %d - %@", [super statusCode], [super receivedJsonData]);
    if ([super receivedMessageOK]) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *d in [super receivedJsonData]) {
            STHistory *h = [[STHistory alloc] init];
            [h setDownload:[d objectForKey:@"download"]];
            [h setUpload:[d objectForKey:@"upload"]];
            [h setPing:[d objectForKey:@"ping"]];
            [h setDate:[d objectForKey:@"date"]];
            [h setNetwork:[d objectForKey:@"network"]];
            [h setConnection:[d objectForKey:@"connection"]];
            [h setLon:[d objectForKey:@"lon"]];
            [h setLat:[d objectForKey:@"lat"]];
            [arr addObject:h];
        }
        if ([_getDelegate respondsToSelector:@selector(apiGetReportsConnection:gotResults:)]) {
            [_getDelegate apiGetReportsConnection:self gotResults:arr];
        }
    }
}


@end
