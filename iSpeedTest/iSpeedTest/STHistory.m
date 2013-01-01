//
//  STHistory.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STHistory.h"
#include <sys/types.h>
#include <sys/sysctl.h>


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

- (NSString *)uuid {
    return [STConfig getAppUUID];
}

- (NSString *)device {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
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
    [keys addObject:@"uuid"];
    [keys addObject:@"device"];
    NSDictionary *d = [self dictionaryWithValuesForKeys:keys];
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:d options:0 error:&err];
    if (err) {
        NSLog(@"Error converting history JSON: %@", [err localizedDescription]);
        return nil;
    }
    NSString *j = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return j;
}


@end
