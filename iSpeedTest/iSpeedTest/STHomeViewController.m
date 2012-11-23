//
//  STHomeViewController.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STHomeViewController.h"
#import "STSpeedtestView.h"


@interface STHomeViewController ()

@property (nonatomic, strong) STSpeedtestView *speedtestView;

@end


@implementation STHomeViewController


#pragma mark Creating elements

- (void)configureView {
    [self.view setBackgroundColor:[UIColor redColor]];
}

- (void)createSpeedtestView {
    if (!_speedtestView) {
        _speedtestView = [[STSpeedtestView alloc] initWithFrame:[super fullscreenFrame]];
        [_speedtestView setBackgroundColor:[UIColor greenColor]];
        [self.view addSubview:_speedtestView];
    }
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createSpeedtestView];
}


@end
