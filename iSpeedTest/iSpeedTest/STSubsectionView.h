//
//  STSubsectionView.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STView.h"


@class STHomeViewController;


@interface STSubsectionView : STView

@property (nonatomic, weak) STHomeViewController *controllerDelegate;

- (void)updateData;


@end
