//
//  STHistoryCell.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 29/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STHistoryCell.h"
#import "STHistory.h"
#import "STSpeedtest.h"


@interface STHistoryCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *connectionLabel;
@property (nonatomic, strong) UILabel *downloadMegabyteLabel;
@property (nonatomic, strong) UILabel *downloadMegabitLabel;
@property (nonatomic, strong) UILabel *uploadMegabyteLabel;
@property (nonatomic, strong) UILabel *uploadMegabitLabel;

@end


@implementation STHistoryCell


#pragma mark Creating elements

- (UILabel *)labelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithHexString:@"3a3c3c"]];
    [label setFont:[STConfig fontWithSize:10]];
    return label;
}

- (void)createLabels {
    _dateLabel = [self labelWithFrame:CGRectMake(15, 12, 110, 18)];
    [self addSubview:_dateLabel];
    
    _connectionLabel = [self labelWithFrame:CGRectMake(15, 30, 110, 18)];
    [_connectionLabel setTextColor:[UIColor colorWithHexString:@"48C9A8"]];
    [_connectionLabel setFont:[STConfig fontWithSize:8]];
    [self addSubview:_connectionLabel];
    
    _downloadMegabyteLabel = [self labelWithFrame:CGRectMake(130, 12, 110, 18)];
    [self addSubview:_downloadMegabyteLabel];

    _downloadMegabitLabel = [self labelWithFrame:CGRectMake(130, 28, 110, 18)];
    [self addSubview:_downloadMegabitLabel];

    _uploadMegabyteLabel = [self labelWithFrame:CGRectMake(218, 12, 110, 18)];
    [self addSubview:_uploadMegabyteLabel];

    _uploadMegabitLabel = [self labelWithFrame:CGRectMake(218, 28, 110, 18)];
    [self addSubview:_uploadMegabitLabel];
}

#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createLabels];
    }
    return self;
}

#pragma mark Settings

- (void)setHistory:(STHistory *)history {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yy h:mma"];
    [_dateLabel setText:[dateFormat stringFromDate:history.date]];
    [_connectionLabel setText:[NSString stringWithFormat:@"%@ (%@)", history.network, history.connection]];
    [_downloadMegabyteLabel setText:[NSString stringWithFormat:@"%.1f MB/s", [STSpeedtest getMegabytes:[history.download floatValue]]]];
    [_downloadMegabitLabel setText:[NSString stringWithFormat:@"%.1f MBit/s", [STSpeedtest getMegabites:[history.download floatValue]]]];
    [_uploadMegabyteLabel setText:[NSString stringWithFormat:@"%.1f MB/s", [STSpeedtest getMegabytes:[history.upload floatValue]]]];
    [_uploadMegabitLabel setText:[NSString stringWithFormat:@"%.1f MBit/s", [STSpeedtest getMegabites:[history.upload floatValue]]]];
}


@end
