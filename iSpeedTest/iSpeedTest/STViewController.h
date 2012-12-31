//
//  STViewController.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface STViewController : UIViewController


@property (nonatomic, strong, readonly) UIImageView *backgroundView;
@property (nonatomic, readonly) BOOL isLandscape;


- (CGRect)fullscreenFrame;

- (void)setBackgroundImage:(NSString *)imageName;

- (void)repositionElements;
- (void)configureView;
- (void)createAllElements;


@end
