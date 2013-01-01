//
//  STHistoryHeaderView.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 29/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STHistoryHeaderView.h"

@implementation STHistoryHeaderView


#pragma mark Creating elements

- (UILabel *)labelWithColor:(UIColor *)color andFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithHexString:@"3a3c3c"]];
    [label setTextColor:color];
    [label setFont:[STConfig fontWithSize:14]];
    return label;
}

- (void)createLabels {
    UILabel *download = [self labelWithColor:[UIColor colorWithHexString:@"F59C73"] andFrame:CGRectMake(130, 25, 88, 14)];
    [download setText:@"DOWN"];
    [self addSubview:download];
    
    UILabel *upload = [self labelWithColor:[UIColor colorWithHexString:@"59B9C7"] andFrame:CGRectMake(218, 25, 88, 14)];
    [upload setText:@"UP"];
    [self addSubview:upload];
}

#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHexString:@"EFEDD2"]];
        [self createLabels];
    }
    return self;
}


@end
