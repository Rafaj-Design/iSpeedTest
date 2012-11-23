//
//  STViewController.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STViewController.h"

@interface STViewController ()

@end

@implementation STViewController


#pragma mark Devices

- (STDeviceType)deviceType {
    return STDeviceTypeiPhone5;
}

#pragma mark Positioning

- (CGRect)fullscreenFrame {
    CGRect r = CGRectZero;
    STDeviceType d = [self deviceType];
    if (d != STDeviceTypeiPad) {
        if (d == STDeviceTypeiPhone5) {
            r.size = CGSizeMake(320, 547);
        }
        else {
            r.size = CGSizeMake(320, 460);
        }
    }
    else {
        if (_isLandscape) {
            r.size = CGSizeMake(1024, 748);
        }
        else {
            r.size = CGSizeMake(768, 1004);
        }
    }
    return r;
}

- (void)repositionElements {
    if (_backgroundView) {
        [_backgroundView setFrame:[self fullscreenFrame]];
        [self.view sendSubviewToBack:_backgroundView];
    }
}

#pragma mark Creating elements

- (void)configureView {
    
}

- (void)createBackgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:[self fullscreenFrame]];
        [self.view addSubview:_backgroundView];
    }
}

- (void)createAllElements {
    
}

#pragma mark Settings

- (void)setBackgroundImage:(NSString *)imageName {
    [self createBackgroundView];
}

#pragma mark Initialization

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self createAllElements];
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self repositionElements];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    BOOL ok = NO;
    STDeviceType d = [self deviceType];
    if (d != STDeviceTypeiPad) {
        ok = (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    }
    else {
        ok = YES;
    }
    if (ok) {
        _isLandscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    }
    return ok;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self repositionElements];
}

#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self createAllElements];
}


@end
