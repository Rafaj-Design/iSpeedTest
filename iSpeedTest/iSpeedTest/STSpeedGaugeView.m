//
//  STSpeedGaugeView.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 31/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STSpeedGaugeView.h"
#import "STSpeedtest.h"


@interface STSpeedGaugeView ()

@property (nonatomic, strong) UIView *downloadPoint;
@property (nonatomic, strong) UIView *uploadPoint;

@property (nonatomic) CGFloat wheelRadius;
@property (nonatomic) CGFloat xOffset;
@property (nonatomic) CGFloat yOffset;
@property (nonatomic) CGPoint wheelCenter;

@property (nonatomic) CGFloat lastAngle;

@end


@implementation STSpeedGaugeView


#pragma mark Initialization & creating elements

- (void)createBackgroundGauges {
    // Download
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_speed_download"]];
    [self addSubview:iv];
    
    _downloadPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9, 9)];
    [_downloadPoint.layer setCornerRadius:5];
    [_downloadPoint setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_downloadPoint];
    
    // Upload
    iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_speed_upload"]];
    [self addSubview:iv];
    [iv centerHorizontally];
    [iv setBottomMargin:0];
    
    _uploadPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
    [_uploadPoint.layer setCornerRadius:3];
    [_uploadPoint setBackgroundColor:[UIColor darkGrayColor]];
    [self addSubview:_uploadPoint];
}

- (void)setupView {
    _wheelRadius = 111;
    _wheelCenter = CGPointMake(116, 116);
    _xOffset = _wheelCenter.x - _wheelRadius;
    _yOffset = _wheelCenter.y - _wheelRadius;
    
    [self createBackgroundGauges];
}

#pragma mark Animations

- (CGFloat)angleForValue:(CGFloat)value {
    CGFloat mbit = [STSpeedtest getMegabites:value];
    if (mbit < 1000) {
        value = ((mbit * 180.0) / 10);
    }
    if (value > 225) value = 225;
    value -= 60;
    CGFloat v = (value - _lastAngle);
    _lastAngle = value;
	NSLog(@"Angle diff: %.3f for angle: %.2f", v, value);
    return v;
}

- (CGFloat)angleForPoint:(CGPoint)point {
    CGFloat y = (_yOffset +_wheelRadius - point.y) / _wheelRadius;
    CGFloat x = (point.x - _xOffset - _wheelRadius) / _wheelRadius;
    CGFloat newRadius = sqrtf(powf(x, 2) + powf(y, 2));
    CGFloat angleFromCos = acos(x / newRadius);
    if (y < 0) angleFromCos = 2 * M_PI - angleFromCos;
    return angleFromCos;
}

- (CGPoint)centerForAngle:(CGFloat)angle
{
	CGFloat x = _wheelRadius * cosf(-angle) + _wheelRadius;
	CGFloat y = _wheelRadius * sinf(-angle) + _wheelRadius;
	return CGPointMake(x + _xOffset, y + _yOffset);
}

- (CGPoint)pointerCenterForValue:(CGFloat)value
{
	return [self centerForAngle:[self angleForValue:value]];
}

- (CGRect)pointerFrameForValue:(CGFloat)value
{
	CGPoint point = [self pointerCenterForValue:value];
	return [self pointerFrameForCenter:point];
}

- (CGRect)pointerFrameForCenter:(CGPoint)centerPoint
{
	CGRect currentbtnFrame = _downloadPoint.frame;
	return CGRectMake( roundf(centerPoint.x - CGRectGetWidth(currentbtnFrame) / 2), roundf(centerPoint.y - CGRectGetHeight(currentbtnFrame) / 2), currentbtnFrame.size.width, currentbtnFrame.size.height);
}

- (void)slideToSelectedAnimated:(BOOL)animated {
	if (animated) {
//		CGFloat currentAngle = [self angleForPoint:_downloadPoint.center];
//		CGFloat finalAngle = [self angleForValue:_selectedValue];
//		
//		BOOL clockwise;
//        
//		CGFloat centralAngle = fabsf(finalAngle - currentAngle);
//		if (centralAngle > M_PI) {
//			
//			clockwise = !(finalAngle > currentAngle);
//		}
//		else {
//			clockwise = (finalAngle > currentAngle);
//		}
//        
//		CGMutablePathRef path = CGPathCreateMutable();
//		CGPathAddArc(path, NULL, self.center.x, self.center.y, _wheelRadius, -currentAngle, -finalAngle, clockwise);
//        
//		CAKeyframeAnimation *slidingAnimation = [CAKeyframeAnimation animation];
//		slidingAnimation.keyPath = @"position";
//		slidingAnimation.duration = 0.3;
//		slidingAnimation.path = path;
//		CGPathRelease(path);
//		
//		[_downloadPoint.layer addAnimation:slidingAnimation forKey:nil];
//		_downloadPoint.frame = [self pointerFrameForValue:_selectedValue];
	}
	else {
		//_downloadPoint.frame = [self pointerFrameForValue:_selectedValue];
	}
}

#pragma mark Settings

- (void)setDownloadSpeed:(CGFloat)speed {
    _downloadPoint.frame = [self pointerFrameForValue:speed];
}

- (void)setUploadSpeed:(CGFloat)speed {
    
}

- (void)reset {
    _lastAngle = -60;
    [self setDownloadSpeed:0];
}


@end
