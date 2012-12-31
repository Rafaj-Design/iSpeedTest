//
//  STAPISendReportConnection.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 31/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STAPISendReportConnection.h"
#import "STAppDelegate.h"


@interface STAPISendReportConnection ()

@property (nonatomic, strong) STHistory *history;

@end


@implementation STAPISendReportConnection


- (void)sendHistoryReport:(STHistory *)history {
    _history = history;
    NSString *url = [kSystemAPIConnectionUrl stringByAppendingFormat:@"?type=%@&data=%@", @"history", [_history jsonValue]];
    [super connectionForUrl:url];
}

- (void)connection:(NSURLConnection *)connection didFinishWithError:(NSError *)error {
    NSLog(@"Received data: %d - %@", super.statusCode, super.receivedString);
    if ([super receivedMessageOK]) {
        [_history setSubmitted:[NSNumber numberWithBool:YES]];
        [kSTManagedObject save:&error];
    }
}


@end
