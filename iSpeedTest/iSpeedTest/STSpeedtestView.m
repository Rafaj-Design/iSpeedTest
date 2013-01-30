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
#import <CFNetwork/CFNetwork.h>
#import "Reachability.h"
#import "STAppDelegate.h"
#import "STAPISendReportConnection.h"
#import "STSpeedGaugeView.h"

@interface STSpeedtestView ()

@property (nonatomic) CGFloat downloadSpeed;
@property (nonatomic) CGFloat uploadSpeed;
@property (nonatomic) CGFloat pingMsec;
@property (nonatomic, strong) STSpeedtest *downloadSpeedtest;
@property (nonatomic, strong) STSpeedtest *uploadSpeedtest;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) STSpeedGaugeView *measurementChartView;
@property (nonatomic, strong) UILabel *networkLabel;
@property (nonatomic, strong) UILabel *connectionLabel;
@property (nonatomic, strong) UILabel *currentSpeedLabel;
@property (nonatomic, strong) UILabel *currentSpeedUnitLabel;
@property (nonatomic, strong) UILabel *percentageLabel;
@property (nonatomic, strong) UILabel *dataProgressLabel;
@property (nonatomic, strong) UILabel *pingLabel;
@property (nonatomic, strong) UILabel *pingMsecLabel;
@property (nonatomic, strong) UILabel *pingMsecDescriptionLabel;
@property (nonatomic, strong) UILabel *downloadLabel;
@property (nonatomic, strong) UILabel *downloadMByteLabel;
@property (nonatomic, strong) UILabel *downloadMBitLabel;
@property (nonatomic, strong) UILabel *uploadLabel;
@property (nonatomic, strong) UILabel *uploadMByteLabel;
@property (nonatomic, strong) UILabel *uploadMBitLabel;
@property (nonatomic, strong) UILabel *downloadMByteDescriptionLabel;
@property (nonatomic, strong) UILabel *downloadMBitDescriptionLabel;
@property (nonatomic, strong) UILabel *uploadMByteDescriptionLabel;
@property (nonatomic, strong) UILabel *uploadMBitDescriptionLabel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic, strong) NSTimer *isWorkingTimer;

@end


@implementation STSpeedtestView


#pragma mark Positioning

- (CGFloat)startPositionForBottomElements {
    return (self.height - 100);
}

#pragma mark Creating elements

- (UILabel *)labelWithFontSize:(CGFloat)size andFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithHexString:@"3a3c3c"]];
    [label setFont:[STConfig fontWithSize:size]];
    return label;
}

- (void)createDownoadMeter {
    if (!_downloadSpeedtest) {
        _downloadSpeedtest = [[STSpeedtest alloc] init];
        [_downloadSpeedtest setDelegate:self];
    }
}

- (void)createUploadMeter {
    if (!_uploadSpeedtest) {
        _uploadSpeedtest = [[STSpeedtest alloc] init];
        [_uploadSpeedtest setDelegate:self];
    }
}

- (void)createButtons {
    UIImage *img = [UIImage imageNamed:@"SP_bg_go"];
    CGRect r = CGRectZero;
    r.origin.y = 71;
    r.size = img.size;
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startButton setBackgroundImage:img forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startMeasurement:) forControlEvents:UIControlEventTouchUpInside];
    [_startButton setFrame:r];
    [_startButton setTitle:@"GO" forState:UIControlStateNormal];
    [_startButton.titleLabel setTextColor:[UIColor colorWithHexString:@"3a3c3c"]];
    [_startButton.titleLabel setFont:[STConfig fontWithSize:55]];
    [self addSubview:_startButton];
    [_startButton centerHorizontally];
}

- (void)createGauge {
    _measurementChartView = [[STSpeedGaugeView alloc] initWithFrame:CGRectMake(0, 0, 232, 228)];
    [_measurementChartView setYOrigin:50];
    [_measurementChartView reset];
    [self addSubview:_measurementChartView];
    [_measurementChartView centerHorizontally];
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
    _downloadLabel = [self labelWithFontSize:14 andFrame:CGRectMake(30, [self startPositionForBottomElements], 130, 14)];
    [_downloadLabel setTextColor:[UIColor colorWithHexString:@"F59C73"]];
    [_downloadLabel setText:@"DOWNLOAD"];
    [self addSubview:_downloadLabel];
    
    _downloadMByteLabel = [self labelWithFontSize:25 andFrame:CGRectMake(30, (_downloadLabel.bottom + 5), 130, 25)];
    [_downloadMByteLabel setText:@"-"];
    [self addSubview:_downloadMByteLabel];
    [_downloadMByteLabel sizeToFit];
    
    _downloadMByteDescriptionLabel = [self labelWithFontSize:10 andFrame:CGRectMake((_downloadMByteLabel.right + 3), (_downloadMByteLabel.bottom - 15), 130, 10)];
    [_downloadMByteDescriptionLabel setText:@"MB/s"];
    [self addSubview:_downloadMByteDescriptionLabel];
    
    _downloadMBitLabel = [self labelWithFontSize:25 andFrame:CGRectMake(30, (_downloadMByteLabel.bottom + 0), 130, 25)];
    [_downloadMBitLabel setText:@"-"];
    [self addSubview:_downloadMBitLabel];
    [_downloadMBitLabel sizeToFit];
    
    _downloadMBitDescriptionLabel = [self labelWithFontSize:10 andFrame:CGRectMake((_downloadMBitLabel.right + 6), (_downloadMBitLabel.bottom - 15), 130, 10)];
    [_downloadMBitDescriptionLabel setText:@"MBit/s"];
    [self addSubview:_downloadMBitDescriptionLabel];
    
    //Ping section
    _pingLabel = [self labelWithFontSize:14 andFrame:CGRectMake(30, _downloadLabel.origin.y-40, 130, 14)];
    [_pingLabel setTextColor:[UIColor colorWithHexString:@"F59C73"]];
    [_pingLabel setText:@"PING"];
    _pingLabel.alpha=0.0f;
    [self addSubview:_pingLabel];
    
    _pingMsecLabel = [self labelWithFontSize:10 andFrame:CGRectMake(30, (_pingLabel.bottom + 5), 130, 10)];
    [_pingMsecLabel setText:@"-"];
    [self addSubview:_pingMsecLabel];
    _pingMsecLabel.alpha=0.0f;
    [_pingMsecLabel sizeToFit];
    
    _pingMsecDescriptionLabel = [self labelWithFontSize:10 andFrame:CGRectMake((_pingMsecLabel.right + 6),     (_pingLabel.bottom + 5), 50, 10)];
    [_pingMsecDescriptionLabel setText:@"ms"];
    _pingMsecDescriptionLabel.alpha=0.0f;
    [self addSubview:_pingMsecDescriptionLabel];
    [_pingMsecDescriptionLabel sizeToFit];
    
    // Upload section
    _uploadLabel = [self labelWithFontSize:14 andFrame:CGRectMake(198, [self startPositionForBottomElements], 130, 14)];
    [_uploadLabel setTextColor:[UIColor colorWithHexString:@"59B9C7"]];
    [_uploadLabel setText:@"UPLOAD"];
    [self addSubview:_uploadLabel];
    
    _uploadMByteLabel = [self labelWithFontSize:25 andFrame:CGRectMake(198, (_downloadLabel.bottom + 5), 130, 25)];
    [_uploadMByteLabel setText:@"-"];
    [self addSubview:_uploadMByteLabel];
    [_uploadMByteLabel sizeToFit];
    
    _uploadMByteDescriptionLabel = [self labelWithFontSize:10 andFrame:CGRectMake((_uploadMByteLabel.right + 6), (_uploadMByteLabel.bottom - 15), 130, 10)];
    [_uploadMByteDescriptionLabel setText:@"MB/s"];
    [self addSubview:_uploadMByteDescriptionLabel];
    
    _uploadMBitLabel = [self labelWithFontSize:25 andFrame:CGRectMake(198, (_uploadMByteLabel.bottom + 0), 130, 25)];
    [_uploadMBitLabel setText:@"-"];
    [self addSubview:_uploadMBitLabel];
    [_uploadMBitLabel sizeToFit];
    
    _uploadMBitDescriptionLabel = [self labelWithFontSize:10 andFrame:CGRectMake((_uploadMBitLabel.right + 6), (_uploadMBitLabel.bottom - 15), 130, 10)];
    [_uploadMBitDescriptionLabel setText:@"MBit/s"];
    [self addSubview:_uploadMBitDescriptionLabel];
}

- (void)createAmazonLogo {
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_main_logo"]];
    [logo positionAtX:(310 - 20 - logo.width) andY:20];
    [self addSubview:logo];
}

- (void)createInfoButton {
    if ([STConfig showInfoButton]) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [b addTarget:self action:@selector(didClickInfoButton:) forControlEvents:UIControlEventTouchUpInside];
        [b setOrigin:CGPointMake(270, ([_measurementChartView bottom] - b.height))];
        [self addSubview:b];
    }
}

#pragma mark Animations

- (void)showStartButton {
    [_startButton setAlpha:0];
    [UIView animateWithDuration:0.3 delay:1.6 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        [_startButton setAlpha:1];
    } completion:^(BOOL finished) {
        NSLog(@"Alpha: %.1f; Hidden: %d; Frame: %@", _startButton.alpha, _startButton.isHidden, NSStringFromCGRect(_startButton.frame));
    }];
}

- (void)hideStartButton {
    [UIView animateWithDuration:0.3 animations:^{
        [_startButton setAlpha:0];
    } completion:^(BOOL finished) {
        if (_startButton.yOrigin > 40) {
            [_startButton positionAtX:10 andY:20];
            UIImage *img = [UIImage imageNamed:@"SP_bg_go_small"];
            [_startButton setBackgroundImage:img forState:UIControlStateNormal];
            [_startButton setSize:img.size];
            [_startButton.titleLabel setFont:[STConfig fontWithSize:16]];
        }
    }];
}

- (void)animateAction:(UILabel *)actionLabel {
    __block CGFloat animationTime = 0.2;
    [UIView animateWithDuration:animationTime animations:^{
        [actionLabel setAlpha:0.4];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationTime animations:^{
            [actionLabel setAlpha:1];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationTime animations:^{
                [actionLabel setAlpha:0.4];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:animationTime animations:^{
                    [actionLabel setAlpha:1];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:animationTime animations:^{
                        [actionLabel setAlpha:0.4];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:animationTime animations:^{
                            [actionLabel setAlpha:1];
                        } completion:^(BOOL finished) {
                            
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (void) fadeInPingLabels {
    [UIView animateWithDuration:0.6f animations:^{
        _pingLabel.alpha = 1.0f;
        _pingMsecDescriptionLabel.alpha = 1.0f;
        _pingMsecLabel.alpha = 1.0f;
    }];
}

- (void) fadeOutPingLabels {
    [UIView animateWithDuration:0.2f animations:^{
        _pingLabel.alpha = 0.0f;
        _pingMsecDescriptionLabel.alpha = 0.0f;
        _pingMsecLabel.alpha = 0.0f;
    }];
}

#pragma mark Network info initialization

- (void)checkForNetworkInfo {
    // Detect network carrier
    CTTelephonyNetworkInfo *phoneInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *phoneCarrier = [phoneInfo subscriberCellularProvider];
    [_networkLabel setText:([phoneCarrier carrierName] ? [phoneCarrier carrierName] : @"Unknown carrier")];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    NetworkStatus status = [reachability currentReachabilityStatus];
    //    if (status == NotReachable) {
    //        [_connectionLabel setText:@"No connection"];
    //    }
    //    else if (status == ReachableViaWWAN) {
    //        [_connectionLabel setText:@"WWAN"];
    //    }
    if (status == ReachableViaWiFi) {
        [_connectionLabel setText:@"WiFi"];
    }
    else {
        bool success = false;
        const char *host_name = [@"s3-eu-west-1.amazonaws.com" cStringUsingEncoding:NSASCIIStringEncoding];
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        bool isAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        if (isAvailable) {
            [_connectionLabel setText:@"Mobile"];
        }
        else {
            [_connectionLabel setText:@"No connection"];
        }
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
    [self createGauge];
    [self createLabels];
    [self createAmazonLogo];
    [self createButtons];
    [self createInfoButton];
}

#pragma mark Actions

- (void)didClickInfoButton:(UIButton *)button {
    if ([[super controllerDelegate] respondsToSelector:@selector(subsectionViewDidRequestInfoScreen:)]) {
        [[super controllerDelegate] subsectionViewDidRequestInfoScreen:self];
    }
}

- (void)updateVerificationTimer:(NSInteger)seconds {
    if (_isWorkingTimer) {
        [_isWorkingTimer invalidate];
    }
    _isWorkingTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(measurementFailed) userInfo:nil repeats:NO];
}

- (void)measurementFailed {
    [self resetValues:NO];
    [self performSelectorOnMainThread:@selector(showStartButton) withObject:nil waitUntilDone:NO];
    if ([[super controllerDelegate] respondsToSelector:@selector(subsectionView:requestNotificationMessage:withColor:)]) {
        [[super controllerDelegate] subsectionView:self requestNotificationMessage:@"Connection Error: Please try again later!" withColor:STSubsectionViewDelegateColorRed];
    }
}

- (void)startDownload {
    [_downloadMBitLabel setText:@"-"];
    [_downloadMByteLabel setText:@"-"];
    [_uploadSpeedtest startDownload];
}

- (void)startUpload {
    [_uploadMByteLabel setText:@"-"];
    [_uploadMBitLabel setText:@"-"];
    NSString *fileName = @"upload.file";
    [_uploadSpeedtest startUploadWithBundleFileName:fileName];
}


- (void)resetValues:(BOOL)resetNetworkLabels {
    _downloadSpeed = 0;
    _uploadSpeed = 0;
    [_downloadSpeedtest setDelegate:nil];
    [_uploadSpeedtest setDelegate:nil];
    _downloadSpeedtest = nil;
    _uploadSpeedtest = nil;
    if (resetNetworkLabels) {
        [_networkLabel setText:@"-"];
        [_connectionLabel setText:@"-"];
    }
    [_currentSpeedLabel setText:@"-.-"];
    [_percentageLabel setText:@"-"];
    [_dataProgressLabel setText:@"- / -"];
    [_downloadMByteLabel setText:@"-"];
    [_downloadMBitLabel setText:@"-"];
    [_uploadMByteLabel setText:@"-"];
    [_uploadMBitLabel setText:@"-"];
    [_currentSpeedUnitLabel setText:@"kB/s"];
    [_pingMsecLabel setText:@"-"];
    [self fadeOutPingLabels];
    [_measurementChartView animateFadeOut];
    [_measurementChartView setDownloadPercentage:0.0f];
    [_measurementChartView setUploadPercentage:0.0f];
    [_percentageLabel setAlpha:0.0f];
    [_dataProgressLabel setAlpha:0.0f];
    [_measurementChartView reset];
}

- (void)doPing {
    bool success = false;
    NSString *hostName = @"s3-eu-west-1.amazonaws.com";
    const char *host_name = [hostName cStringUsingEncoding:NSASCIIStringEncoding];
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
    SCNetworkReachabilityFlags flags;
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    bool isAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    if (isAvailable) {
        [_downloadSpeedtest startPingWithHostAddress:@"www.google.com"];
        [self updateVerificationTimer:8];
    }
    else {
        [self measurementFailed];
    }
}

- (void)startMeasurement:(UIButton *)sender {
    [self resetValues:YES];
    
    [self createDownoadMeter];
    [self createUploadMeter];
    
    if ([_delegate respondsToSelector:@selector(speedtestViewDidStartMeasurment:)]) {
        [_delegate speedtestViewDidStartMeasurment:self];
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDesiredAccuracy:250];
    [_locationManager setDelegate:self];
    [_locationManager startUpdatingLocation];
    
    // Detect connection type
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    Reachability *reachability = [Reachability reachabilityForLocalWiFi];
    [reachability startNotifier];
    [self updateInterfaceWithReachability:reachability];
    
    [self checkForNetworkInfo];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkForNetworkInfo) userInfo:nil repeats:YES];
    [self hideStartButton];
    
    //Reset _pingMsec value to -1.0f that is an unreachable value for real connections and so can be safely used to indicate no value
    _pingMsec = -1.0f;
    [_currentSpeedUnitLabel setText:@"ms (Ping)"];
    [self doPing];
}

#pragma mark API connection

- (void)sendHistoryData:(STHistory *)history {
    @autoreleasepool {
        STAPISendReportConnection *api = [[STAPISendReportConnection alloc] init];
        [api sendHistoryReport:history];
    }
}

- (void)startSendingHistoryDataOnBackground:(STHistory *)history {
    @autoreleasepool {
        [self performSelectorInBackground:@selector(sendHistoryData:) withObject:history];
    }
}

#pragma mark Location manager delegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *l = (CLLocation *)[locations lastObject];
    if (_currentLocation != l && l) {
        _currentLocation = l;
        [Flurry setLatitude:l.coordinate.latitude longitude:l.coordinate.longitude horizontalAccuracy:l.horizontalAccuracy verticalAccuracy:l.verticalAccuracy];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [Flurry logError:@"Location error" message:@"CLLocationManager" error:error];
}

#pragma mark Speedtest delegate methods

- (void)speedtest:(STSpeedtest *)test didReceiveUpdate:(struct STSpeedtestUpdate)update {
    if (update.status == STSpeedtestStatusWorking) {
        [self updateVerificationTimer:8];
        [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", [STSpeedtest getKilobytes:update.averageSpeed]]];
        [_percentageLabel setText:[NSString stringWithFormat:@"%.1f %%", update.percentDone]];
        [_dataProgressLabel setText:[NSString stringWithFormat:@"%.0f / %.0f kB", [STSpeedtest getKilobytes:update.processedSize], [STSpeedtest getKilobytes:update.totalSize]]];
        if (update.type == STSpeedtestTypePinging) {
            if (update.speed > 0.0f) {
                if (_pingMsec < 0.0f) {
                    _pingMsec=update.speed;
                    [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", _pingMsec]];
                }
                else if (_pingMsec>update.speed) {
                    _pingMsec=update.speed;
                    [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", _pingMsec]];
                }
                else {
                    [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", _pingMsec]];
                }
            }
            else {
                if (_pingMsec<0.0f) {
                    [_currentSpeedLabel setText:@"-"];
                }
                else if (_pingMsec>update.speed) {
                    _pingMsec=update.speed;
                    [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", _pingMsec]];
                }
                else {
                    [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", _pingMsec]];
                }
            }
            [_measurementChartView setDownloadPercentage:update.averageSpeed];
            [_measurementChartView setUploadPercentage:update.averageSpeed];
        }
        else if (update.type == STSpeedtestTypeDownloading) {
            [_downloadMBitLabel setText:[NSString stringWithFormat:@"%.1f", [STSpeedtest getMegabites:update.averageSpeed]]];
            [_downloadMBitLabel sizeToFit];
            [_downloadMBitDescriptionLabel setXOrigin:(_downloadMBitLabel.right + 6)];
            [_downloadMByteLabel setText:[NSString stringWithFormat:@"%.1f", [STSpeedtest getMegabytes:update.averageSpeed]]];
            [_downloadMByteLabel sizeToFit];
            [_downloadMByteDescriptionLabel setXOrigin:(_downloadMByteLabel.right + 6)];
            [_measurementChartView setDownloadSpeed:update.averageSpeed];
        }
        else if (update.type == STSpeedtestTypeUploading) {
            [_uploadMBitLabel setText:[NSString stringWithFormat:@"%.1f", [STSpeedtest getMegabites:update.averageSpeed]]];
            [_uploadMBitLabel sizeToFit];
            [_uploadMBitDescriptionLabel setXOrigin:(_uploadMBitLabel.right + 6)];
            [_uploadMByteLabel setText:[NSString stringWithFormat:@"%.1f", [STSpeedtest getMegabytes:update.averageSpeed]]];
            [_uploadMByteLabel sizeToFit];
            [_uploadMByteDescriptionLabel setXOrigin:(_uploadMByteLabel.right + 6)];
            [_measurementChartView setUploadSpeed:update.averageSpeed];
        }
    }
    else if (update.status == STSpeedtestStatusFinished) {
        [_isWorkingTimer invalidate];
        if (update.type == STSpeedtestTypePinging) {
            if (update.speed>0.0f) {
                if (_pingMsec<0.0f) {
                    _pingMsec=update.speed;
                    [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", _pingMsec]];
                }
                else if (_pingMsec>update.speed) {
                    _pingMsec=update.speed;
                    [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", _pingMsec]];
                }
                else {
                    [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", _pingMsec]];
                }
            }
            else {
                if (_pingMsec<0.0f) {
                    [_currentSpeedLabel setText:@"-"];
                }
                else if (_pingMsec>update.speed) {
                    _pingMsec=update.speed;
                    [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", _pingMsec]];
                }
                else {
                    [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.1f", _pingMsec]];
                }
            }
            [_pingMsecLabel setText:_currentSpeedLabel.text];
            [_measurementChartView setDownloadPercentage:update.averageSpeed];
            [_measurementChartView setUploadPercentage:update.averageSpeed];
            [_pingMsecLabel sizeToFit];
            [_pingMsecDescriptionLabel setXOrigin:(_pingMsecLabel.right + 6)];
            [self fadeInPingLabels];
            [self animateAction:_downloadLabel];
            [_measurementChartView animateFadeIn];
            [UIView animateWithDuration:0.3 animations:^{
                [_currentSpeedLabel setAlpha:0];
                [_currentSpeedUnitLabel setAlpha:0];
                [_percentageLabel setAlpha:0];
                [_dataProgressLabel setAlpha:0];
            } completion:^(BOOL finished) {
                [_currentSpeedLabel setText:@"0.0"];
                [_currentSpeedUnitLabel setText:@"kB/s (Download)"];
                [_percentageLabel setText:@"0 %"];
                [_dataProgressLabel setText:@"0 / 0 kB"];
                [_measurementChartView setDownloadPercentage:0.0f];
                [_measurementChartView setUploadPercentage:0.0f];
                [UIView animateWithDuration:0.3 animations:^{
                    [_currentSpeedLabel setAlpha:1];
                    [_currentSpeedUnitLabel setAlpha:1];
                    [_percentageLabel setAlpha:1];
                    [_dataProgressLabel setAlpha:1];
                } completion:^(BOOL finished) {
                    
                }];
            }];
            [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(startDownload) userInfo:nil repeats:NO];
            
        }
        else if (update.type == STSpeedtestTypeDownloading) {
            _downloadSpeed = update.averageSpeed;
            [self animateAction:_uploadLabel];
            [UIView animateWithDuration:0.3 animations:^{
                [_currentSpeedLabel setAlpha:0];
                [_currentSpeedUnitLabel setAlpha:0];
                [_percentageLabel setAlpha:0];
                [_dataProgressLabel setAlpha:0];
            } completion:^(BOOL finished) {
                [_currentSpeedLabel setText:@"0.0"];
                [_currentSpeedUnitLabel setText:@"kB/s (Upload)"];
                [_percentageLabel setText:@"0 %"];
                [_dataProgressLabel setText:@"0 / 0 kB"];
                
                [UIView animateWithDuration:0.3 animations:^{
                    [_currentSpeedLabel setAlpha:1];
                    [_currentSpeedUnitLabel setAlpha:1];
                    [_percentageLabel setAlpha:1];
                    [_dataProgressLabel setAlpha:1];
                } completion:^(BOOL finished) {
                    
                }];
            }];
            [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(startUpload) userInfo:nil repeats:NO];
        }
        else if (update.type == STSpeedtestTypeUploading) {
            [self showStartButton];
            _uploadSpeed = update.averageSpeed;
            NSError *error;
            STHistory *history = [NSEntityDescription insertNewObjectForEntityForName:@"STHistory" inManagedObjectContext:kSTManagedObject];
            [history setDate:[NSDate date]];
            [history setDownload:[NSNumber numberWithFloat:_downloadSpeed]];
            [history setUpload:[NSNumber numberWithFloat:_uploadSpeed]];
            //set ping if ping != -1.0f set it if not set nil
            if (_pingMsec>-0.5f) {
                [history setPing:[NSNumber numberWithFloat:_pingMsec]];
            }
            else {
                [history setPing:nil];
            }
            if (_currentLocation) {
                [history setLat:[NSNumber numberWithDouble:_currentLocation.coordinate.latitude]];
                [history setLon:[NSNumber numberWithDouble:_currentLocation.coordinate.longitude]];
            }
            [history setNetwork:_networkLabel.text];
            [history setConnection:_connectionLabel.text];
            [history setName:@""];
            [kSTManagedObject save:&error];
            if (error) {
                [Flurry logError:@"CoreData error" message:@"save" error:error];
                NSLog(@"Error saving: %@", [error localizedDescription]);
            }
            else {
                if ([_delegate respondsToSelector:@selector(speedtestViewDidStopMeasurment:withResults:)]) {
                    [_delegate speedtestViewDidStopMeasurment:self withResults:history];
                }
                [NSThread detachNewThreadSelector:@selector(startSendingHistoryDataOnBackground:) toTarget:self withObject:history];
            }
            
            // Set the final screen info
            [UIView animateWithDuration:0.3 animations:^{
                [_currentSpeedLabel setAlpha:0];
                [_currentSpeedUnitLabel setAlpha:0];
                [_dataProgressLabel setAlpha:0];
                [_percentageLabel setAlpha:0];
            } completion:^(BOOL finished) {
                [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.3f", [STSpeedtest getMegabites:[history.download floatValue]]]];
                [_currentSpeedUnitLabel setText:@"Download in Mbit/s"];
                [_percentageLabel setText:[NSString stringWithFormat:@"%.3f Mbit/s", [STSpeedtest getMegabites:[history.upload floatValue]]]];
                [_dataProgressLabel setText:@"Upload"];
                [UIView animateWithDuration:0.3 animations:^{
                    [_currentSpeedLabel setAlpha:1];
                    [_currentSpeedUnitLabel setAlpha:1];
                    [_dataProgressLabel setAlpha:1];
                    [_percentageLabel setAlpha:1];
                } completion:^(BOOL finished) {
                    
                }];
            }];
            
            [_locationManager setDelegate:nil];
            _locationManager = nil;
        }
    }
}


@end
