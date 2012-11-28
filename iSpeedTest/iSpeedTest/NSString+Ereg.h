//
//  NSString+Ereg.h
//  FunCards
//
//  Created by Ondrej Rafaj on 27/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Ereg)

+ (BOOL)eregi:(NSString *)pattern inString:(NSString *)string;

- (BOOL)eregi:(NSString *)pattern;


@end
