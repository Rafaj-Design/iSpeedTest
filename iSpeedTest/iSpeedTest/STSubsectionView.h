//
//  STSubsectionView.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STView.h"
#import "STHistoryCell.h"


typedef enum {
    STSubsectionViewDelegateColorRed,
    STSubsectionViewDelegateColorGreen,
    STSubsectionViewDelegateColorOrange
} STSubsectionViewDelegateColor;


@class STSubsectionView;

@protocol STSubsectionViewDelegate <NSObject>

- (void)subsectionView:(STSubsectionView *)view requestNotificationMessage:(NSString *)text withColor:(STSubsectionViewDelegateColor)color;
- (void)subsectionViewDidRequestInfoScreen:(STSubsectionView *)view;

@end    


@interface STSubsectionView : STView

@property (nonatomic, weak) id <STSubsectionViewDelegate, STHistoryCellDelegate> controllerDelegate;

- (void)updateData;


@end
