//
//  STSpeedtestView.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STSpeedtestView.h"
//#import "MeterView.h"


@interface STSpeedtestView ()

@property (nonatomic, strong) STSpeedtest *downloadSpeedtest;
@property (nonatomic, strong) STSpeedtest *uploadSpeedtest;

@property (nonatomic, strong) UIButton *startButton;
//@property (nonatomic, strong) MeterView *gauge;

@property (nonatomic, strong) UILabel *kilobitLabel;
@property (nonatomic, strong) UILabel *megabitLabel;
@property (nonatomic, strong) UILabel *megabyteLabel;
@property (nonatomic, strong) UILabel *percentLabel;

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
//    _gauge = [[MeterView alloc] initWithFrame:CGRectMake(50, 150, 200, 200)];
//    [_gauge setBackgroundColor:[UIColor clearColor]];
//    _gauge.startAngle = -3.0 * M_PI / 4.0;
//	_gauge.arcLength = M_PI / 0.6;
//	_gauge.value = 0.0;
//	_gauge.textLabel.text = @"Bit/s";
//	_gauge.minNumber = 0.0;
//	_gauge.maxNumber = 900000;
//	_gauge.textLabel.font = [UIFont systemFontOfSize:14];
//	_gauge.textLabel.textColor = [UIColor clearColor];
//	_gauge.needle.tintColor = [UIColor brownColor];
//	_gauge.needle.width = 1.0;
//	_gauge.value = 0;
//    [self addSubview:_gauge];
}

- (UILabel *)createLabelAtY:(CGFloat)y {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 280, 30)];
    [label setTextColor:[UIColor grayColor]];
    [label setFont:[UIFont systemFontOfSize:15]];
    return label;
}

- (void)createLabels {
    _percentLabel = [self createLabelAtY:300];
    [self addSubview:_percentLabel];

    _kilobitLabel = [self createLabelAtY:400];
    [self addSubview:_kilobitLabel];

    _megabitLabel = [self createLabelAtY:430];
    [self addSubview:_megabitLabel];

    _megabyteLabel = [self createLabelAtY:460];
    [self addSubview:_megabyteLabel];
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
        //NSLog(@"Percent downloaded: %.02f", update.percentDone);
        //NSLog(@"Download time: %f)", update.elapsedTime);
        //NSLog(@"Percent done: %f", update.percentDone);
        NSLog(@"Connection speed: %.2f (%.2f)", update.speed, update.averageSpeed);
        //[_gauge setValue:update.averageSpeed];
        [_kilobitLabel setText:[NSString stringWithFormat:@"%.3f KBit/s", [STSpeedtest getKilobites:update.averageSpeed]]];
        [_megabitLabel setText:[NSString stringWithFormat:@"%.3f MBit/s", [STSpeedtest getMegabites:update.averageSpeed]]];
        [_megabyteLabel setText:[NSString stringWithFormat:@"%.3f Mb/s", [STSpeedtest getMegabytes:update.averageSpeed]]];
        [_percentLabel setText:[NSString stringWithFormat:@"%.3f %%", update.percentDone]];
    }
    else {
        NSLog(@"Percent uploaded: %.02f", update.percentDone);
    }
}


@end
