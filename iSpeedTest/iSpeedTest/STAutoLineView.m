//
//  STAutoLineView.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STAutoLineView.h"


@implementation STAutoLineView


#pragma mark Initialization

- (void)doSetup {
	_enableSideSpace = YES;
}

- (id)init {
    self = [super init];
    if (self) {
        [self doSetup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doSetup];
    }
    return self;
}

#pragma mark Settings

- (void)layoutElements {
	CGFloat elementsWidth = 0;
	for (UIView *v in self.subviews) {
		elementsWidth += [v width];
	}
	int add = (_enableSideSpace) ? 1 : -1;
	CGFloat step = (([self width] - elementsWidth) / ([self.subviews count] + add));
	CGFloat xPos = (_enableSideSpace) ? step : 0;
	for (UIView *v in self.subviews) {
		[v setXOrigin:xPos];
		xPos += (step + [v width]);
	}
}


@end
