//
//  STAutoLineView.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STView.h"


@interface STAutoLineView : STView

@property (nonatomic) BOOL enableSideSpace;

- (void)layoutElements;


@end
