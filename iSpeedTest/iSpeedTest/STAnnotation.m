//
//  STAnnotation.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 03/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STAnnotation.h"
#import "STHistory.h"
#import "STSpeedtest.h"


@implementation STAnnotation

- (id)initWithHistoryItem:(STHistory *)item {
    _historyItem = item;
    CLLocationCoordinate2D coordinate = {
        .latitude = [_historyItem.lat floatValue],
        .longitude = [_historyItem.lon floatValue]
    };
	_coordinate = coordinate;
    _title = [NSString stringWithFormat:@"%.1f kB/s (%@)", [STSpeedtest getKilobytes:[_historyItem.download floatValue]], ([[_historyItem.connection lowercaseString] isEqualToString:@"wifi"] ? _historyItem.connection : _historyItem.network)];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle];
    [df setDateStyle:NSDateFormatterLongStyle];
    _subtitle = [df stringFromDate:[item date]];
	return self;
}

@end
