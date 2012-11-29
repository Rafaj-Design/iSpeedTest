//
//  STSpeedtestView.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STSpeedtestView.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "Reachability.h"
#import "STAppDelegate.h"


@interface STSpeedtestView ()

@property (nonatomic) CGFloat downloadSpeed;
@property (nonatomic) CGFloat uploadSpeed;

@property (nonatomic, strong) STSpeedtest *downloadSpeedtest;
@property (nonatomic, strong) STSpeedtest *uploadSpeedtest;

@property (nonatomic, strong) UIButton *startButton;

@property (nonatomic, strong) UIImageView *measurementChartView;

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


#pragma mark Positioning

- (CGFloat)startPositionForBottomElements {
    return (self.height - 100);
}

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
    [_startButton setFrame:CGRectMake(10, 20, 50, 22)];
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
    [self addSubview:_startButton];
}

- (void)createGauge {
    _measurementChartView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_speed_circle_bg"]];
    [_measurementChartView setYOrigin:50];
    [self addSubview:_measurementChartView];
    [_measurementChartView centerHorizontally];
}

- (UILabel *)labelWithFontSize:(CGFloat)size andFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithHexString:@"3a3c3c"]];
    [label setFont:[STConfig fontWithSize:size]];
    return label;
}

- (void)createLabels {
    _networkLabel = [self labelWithFontSize:10 andFrame:CGRectMake(0, 76, 130, 12)];
    [_networkLabel setTextAlignment:NSTextAlignmentCenter];
    [_networkLabel setText:@"-"];
    [self addSubview:_networkLabel];
    [_networkLabel centerHorizontally];
    
    _connectionLabel = [self labelWithFontSize:12 andFrame:CGRectMake(0, (_networkLabel.bottom + 0), 130, 14)];
    [_connectionLabel setTextAlignment:NSTextAlignmentCenter];
    [_connectionLabel setText:@"-"];
    [self addSubview:_connectionLabel];
    [_connectionLabel centerHorizontally];
    
    _currentSpeedLabel = [self labelWithFontSize:54 andFrame:CGRectMake(0, (_connectionLabel.bottom + 30), 180, 60)];
    [_currentSpeedLabel setTextAlignment:NSTextAlignmentCenter];
    [_currentSpeedLabel setText:@"-.-"];
    [self addSubview:_currentSpeedLabel];
    [_currentSpeedLabel centerHorizontally];
    
    _currentSpeedUnitLabel = [self labelWithFontSize:10 andFrame:CGRectMake(0, (_currentSpeedLabel.bottom + 0), 130, 12)];
    [_currentSpeedUnitLabel setTextAlignment:NSTextAlignmentCenter];
    [_currentSpeedUnitLabel setText:@"kB/s"];
    [self addSubview:_currentSpeedUnitLabel];
    [_currentSpeedUnitLabel centerHorizontally];
    
    _percentageLabel = [self labelWithFontSize:10 andFrame:CGRectMake(0, (_currentSpeedUnitLabel.bottom + 30), 130, 12)];
    [_percentageLabel setTextAlignment:NSTextAlignmentCenter];
    [_percentageLabel setText:@"-"];
    [self addSubview:_percentageLabel];
    [_percentageLabel centerHorizontally];
    
    _dataProgressLabel = [self labelWithFontSize:10 andFrame:CGRectMake(0, (_percentageLabel.bottom + 0), 130, 12)];
    [_dataProgressLabel setTextAlignment:NSTextAlignmentCenter];
    [_dataProgressLabel setText:@"- / -"];
    [self addSubview:_dataProgressLabel];
    [_dataProgressLabel centerHorizontally];
    
    // Download section
    UILabel *download = [self labelWithFontSize:14 andFrame:CGRectMake(30, [self startPositionForBottomElements], 130, 14)];
    [download setTextColor:[UIColor colorWithHexString:@"F59C73"]];
    [download setText:@"DOWNLOAD"];
    [self addSubview:download];
    
    _downloadMByteLabel = [self labelWithFontSize:25 andFrame:CGRectMake(30, (download.bottom + 5), 130, 25)];
    [_downloadMByteLabel setText:@"-"];
    [self addSubview:_downloadMByteLabel];
    
    _downloadMBitLabel = [self labelWithFontSize:25 andFrame:CGRectMake(30, (_downloadMByteLabel.bottom + 0), 130, 25)];
    [_downloadMBitLabel setText:@"-"];
    [self addSubview:_downloadMBitLabel];
    
    // Upload section
    UILabel *upload = [self labelWithFontSize:14 andFrame:CGRectMake(198, [self startPositionForBottomElements], 130, 14)];
    [upload setTextColor:[UIColor colorWithHexString:@"59B9C7"]];
    [upload setText:@"UPLOAD"];
    [self addSubview:upload];
    
    _uploadMByteLabel = [self labelWithFontSize:25 andFrame:CGRectMake(198, (download.bottom + 5), 130, 25)];
    [_uploadMByteLabel setText:@"-"];
    [self addSubview:_uploadMByteLabel];
    
    _uploadMBitLabel = [self labelWithFontSize:25 andFrame:CGRectMake(198, (_uploadMByteLabel.bottom + 0), 130, 25)];
    [_uploadMBitLabel setText:@"-"];
    [self addSubview:_uploadMBitLabel];
}

- (void)createAmazonLogo {
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_amazons3_logo"]];
    [logo positionAtX:(310 - 20 - logo.width) andY:20];
    [self addSubview:logo];
}

#pragma mark Network info initialization

- (void)checkForNetworkInfo {
    // Detect network carrier
    CTTelephonyNetworkInfo *phoneInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *phoneCarrier = [phoneInfo subscriberCellularProvider];
    [_networkLabel setText:([phoneCarrier carrierName] ? [phoneCarrier carrierName] : @"Unknown carrier")];
    
    // Detect connection type
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];    
    Reachability *reachability = [Reachability reachabilityForLocalWiFi];
    [reachability startNotifier];
    [self updateInterfaceWithReachability:reachability];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == NotReachable) {
        [_connectionLabel setText:@"No connection"];
    }
    else if (status == ReachableViaWWAN) {
        [_connectionLabel setText:@"Mobile connection"];
    }
    else if (status == ReachableViaWiFi) {
        [_connectionLabel setText:@"WiFi"];
    }
}

#pragma mark Reachability notifications

- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *reachability = (Reachability *)[note object];
    NSParameterAssert([reachability isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability:reachability];
}

#pragma mark Initializations

- (void)setupView {
    [super setupView];
    
    [self createDownoadMeter];
    [self createUploadMeter];
    [self createButtons];
    
    [self createGauge];
    [self createLabels];
    [self createAmazonLogo];
    
    [self checkForNetworkInfo];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkForNetworkInfo) userInfo:nil repeats:YES];
}

#pragma mark Actions

- (void)startUpload {
    
}

- (void)resetValues {
    _downloadSpeed = 0;
    _uploadSpeed = 0;
}

#pragma mark Speedtest delegate methods

- (void)speedtest:(STSpeedtest *)test didReceiveUpdate:(struct STSpeedtestUpdate)update {
    if (update.status == STSpeedtestStatusWorking) {
        [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", [STSpeedtest getKilobytes:update.speed]]];
        
        [_percentageLabel setText:[NSString stringWithFormat:@"%.1f %%", update.percentDone]];
        [_dataProgressLabel setText:[NSString stringWithFormat:@"%.0f / %.0f kB", [STSpeedtest getKilobytes:update.processedSize], [STSpeedtest getKilobytes:update.totalSize]]];
        if (update.type == STSpeedtestTypeDownloading) {
            [_downloadMBitLabel setText:[NSString stringWithFormat:@"%.1f MBit/s", [STSpeedtest getMegabites:update.averageSpeed]]];
            [_downloadMByteLabel setText:[NSString stringWithFormat:@"%.1f Mb/s", [STSpeedtest getMegabytes:update.averageSpeed]]];
        }
        else if (update.type == STSpeedtestTypeDownloading) {
            [_uploadMBitLabel setText:[NSString stringWithFormat:@"%.1f MBit/s", [STSpeedtest getMegabites:update.averageSpeed]]];
            [_uploadMByteLabel setText:[NSString stringWithFormat:@"%.1f Mb/s", [STSpeedtest getMegabytes:update.averageSpeed]]];
        }
        else if (update.status == STSpeedtestStatusFinished) {
            [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", [STSpeedtest getKilobytes:update.averageSpeed]]];
            if (YES) {
                [self startUpload];
            }
            else {
                NSError *error;
                STHistory *history = [NSEntityDescription insertNewObjectForEntityForName:@"STHistory" inManagedObjectContext:kSTManagedObject];
                [history setDate:[NSDate date]];
                [history setDownload:[NSNumber numberWithFloat:_downloadSpeed]];
                [history setUpload:[NSNumber numberWithFloat:_uploadSpeed]];
                [history setLat:nil];
                [history setLon:nil];
                [history setNetwork:_networkLabel.text];
                [history setConnection:_connectionLabel.text];
                [history setPing:nil];
                [history setName:@""];
                [kSTManagedObject save:&error];
                if (error) NSLog(@"Error saving: %@", [error localizedDescription]);
                else {
                    if ([_delegate respondsToSelector:@selector(speedtestViewDidStopMeasurment:withResults:)]) {
                        [_delegate speedtestViewDidStopMeasurment:self withResults:history];
                    }
                }
            }
        }
    }
}


@end
