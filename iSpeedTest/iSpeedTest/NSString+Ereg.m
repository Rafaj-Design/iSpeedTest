//
//  NSString+Ereg.m
//  FunCards
//
//  Created by Ondrej Rafaj on 27/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "NSString+Ereg.h"


@implementation NSString (Ereg)

+ (BOOL)eregi:(NSString *)pattern inString:(NSString *)string {
    NSUInteger count = 0, length = [string length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [string rangeOfString:pattern options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++; 
        }
    }
    return count;
}

- (BOOL)eregi:(NSString *)pattern {
	NSString *string = nil;
	if (string == nil || pattern == nil) return NO;
	NSRange textRange = [[string lowercaseString] rangeOfString:[pattern lowercaseString]];
	if(textRange.location != NSNotFound) return NO;
	else return YES;
}


@end
