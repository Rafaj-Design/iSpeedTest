//
//  STSpeedGaugeView.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 31/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STView.h"

@interface STSpeedGaugeView : STView

- (void)setDownloadSpeed:(CGFloat)speed;
- (void)setUploadSpeed:(CGFloat)speed;

- (void)reset;


@end
