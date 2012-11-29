//
//  STHistoryEmptyCell.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 29/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STHistoryEmptyCell.h"

@implementation STHistoryEmptyCell


#pragma mark Creating elements

- (void)createLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 310, 60)];
    [label setText:@"No history data available"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithHexString:@"3a3c3c"]];
    [label setFont:[STConfig fontWithSize:14]];
    [self addSubview:label];
}

#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createLabel];
    }
    return self;
}


@end
