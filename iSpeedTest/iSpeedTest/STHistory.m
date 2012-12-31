//
//  STHistory.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STHistory.h"


@implementation STHistory

@dynamic date;
@dynamic download;
@dynamic upload;
@dynamic lat;
@dynamic lon;
@dynamic network;
@dynamic connection;
@dynamic ping;
@dynamic submitted;
@dynamic name;

- (NSNumber *)formattedDate {
    return [NSNumber numberWithInteger:[self.date timeIntervalSince1970]];
}

- (NSString *)jsonValue {
    NSEntityDescription *myEntity = [self entity];
    NSDictionary *attributes = [myEntity attributesByName];
    NSMutableArray *keys = [NSMutableArray array];
    for (NSString *key in [attributes allKeys]) {
        if ([key isEqualToString:@"date"]) {
            [keys addObject:@"formattedDate"];
        }
        else [keys addObject:key];
    }
    NSDictionary *d = [self dictionaryWithValuesForKeys:keys];
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:d options:0 error:&err];
    if (err) {
        NSLog(@"Error converting history JSON: %@", [err localizedDescription]);
        return nil;
    }
    NSString *j = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (kDebug) NSLog(@"Json value: %@", j);
    return j;
}




@end
