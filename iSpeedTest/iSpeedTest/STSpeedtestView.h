//
//  STSpeedtestView.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STSubsectionView.h"
#import "STSpeedtest.h"
#import "STHistory.h"


typedef enum {
    STSpeedtestViewDataFormatKBit,
    STSpeedtestViewDataFormatMBit,
    STSpeedtestViewDataFormatKByte,
    STSpeedtestViewDataFormatMByte
} STSpeedtestViewDataFormat;


@class STSpeedtestView;

@protocol STSpeedtestViewDelegate <NSObject>

@optional

- (void)speedtestViewDidStartMeasurment:(STSpeedtestView *)view;
- (void)speedtestViewDidStopMeasurment:(STSpeedtestView *)view withResults:(STHistory *)history;

@end


@interface STSpeedtestView : STSubsectionView <STSpeedtestDelegate>

@property (nonatomic, weak) id<STSpeedtestViewDelegate> delegate;


@end
