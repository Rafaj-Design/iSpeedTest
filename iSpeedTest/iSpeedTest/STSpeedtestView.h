//
//  STSpeedtestView.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STSubsectionView.h"
#import "STSpeedtest.h"


@class STSpeedtestView;

@protocol STSpeedtestViewDelegate <NSObject>

@optional

- (void)speedtestViewDidStartMeasurment:(STSpeedtestView *)view;
- (void)speedtestViewDidStopMeasurment:(STSpeedtestView *)view;

@end


@interface STSpeedtestView : STSubsectionView <STSpeedtestDelegate>

@end
