//
//  STSpeedtestView.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STSpeedtestView.h"


@interface STSpeedtestView ()

@property (nonatomic, strong) STSpeedtest *downloadSpeedtest;
@property (nonatomic, strong) STSpeedtest *uploadSpeedtest;

@property (nonatomic, strong) UIButton *startButton;

@property (nonatomic, strong) UILabel *networkLabel;
@property (nonatomic, strong) UILabel *connectionLabel;
@property (nonatomic, strong) UILabel *currentSpeedLabel;
@property (nonatomic, strong) UILabel *currentSpeedUnitLabel;
@property (nonatomic, strong) UILabel *percentageLabel;
@property (nonatomic, strong) UILabel *dataProgressLabel;
@property (nonatomic, strong) UILabel *downloadMByteLabel;
@property (nonatomic, strong) UILabel *downloadMBitLabel;
@property (nonatomic, strong) UILabel *uploadMByteLabel;
@property (nonatomic, strong) UILabel *uploadMBitLabel;

@end


@implementation STSpeedtestView


#pragma mark Creating elements

- (void)createDownoadMeter {
    _downloadSpeedtest = [[STSpeedtest alloc] init];
    [_downloadSpeedtest setDelegate:self];
}

- (void)createUploadMeter {
    _uploadSpeedtest = [[STSpeedtest alloc] init];
    [_uploadSpeedtest setDelegate:self];
}

- (void)createButtons {
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_startButton addTarget:_downloadSpeedtest action:@selector(startDownload) forControlEvents:UIControlEventTouchUpInside];
    [_startButton setFrame:CGRectMake(50, 50, 120, 44)];
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
    [self addSubview:_startButton];
}

- (void)createGauge {
    
}

- (UILabel *)labelVithFontSize:(CGFloat)size andFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor redColor]];
    [label setTextColor:[UIColor colorWithHexString:@"3a3c3c"]];
    [label setFont:[STConfig fontWithSize:size]];
    return label;
}

- (void)createLabels {
    
}

#pragma mark Initializations

- (void)setupView {
    [super setupView];
    
    [self createDownoadMeter];
    [self createUploadMeter];
    [self createButtons];
    
    [self createGauge];
    [self createLabels];
}

#pragma mark Speedtest delegate methods

- (void)speedtest:(STSpeedtest *)test didReceiveUpdate:(struct STSpeedtestUpdate)update {
    if (test == _downloadSpeedtest) {
//        //NSLog(@"Percent downloaded: %.02f", update.percentDone);
//        //NSLog(@"Download time: %f)", update.elapsedTime);
//        //NSLog(@"Percent done: %f", update.percentDone);
//        NSLog(@"Connection speed: %.2f (%.2f)", update.speed, update.averageSpeed);
//        [_kilobitLabel setText:[NSString stringWithFormat:@"%.3f KBit/s", [STSpeedtest getKilobites:update.averageSpeed]]];
//        [_megabitLabel setText:[NSString stringWithFormat:@"%.3f MBit/s", [STSpeedtest getMegabites:update.averageSpeed]]];
//        [_megabyteLabel setText:[NSString stringWithFormat:@"%.3f Mb/s", [STSpeedtest getMegabytes:update.averageSpeed]]];
//        [_percentLabel setText:[NSString stringWithFormat:@"%.3f %%", update.percentDone]];
    }
    else {
        NSLog(@"Percent uploaded: %.02f", update.percentDone);
    }
}


@end
