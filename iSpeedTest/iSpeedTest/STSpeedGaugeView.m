//
//  STSpeedGaugeView.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 31/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STSpeedGaugeView.h"
#import "STSpeedtest.h"

CG_INLINE CGRect
CGRectMakeWithCenter(CGFloat centerX, CGFloat centerY, CGFloat width, CGFloat height)
{
	CGRect rect;
	rect.origin.x = centerX - width / 2.0;
	rect.origin.y = centerY - height / 2.0;
	rect.size.width = width; rect.size.height = height;
	return rect;
}

#define toRad(degree) (M_PI * (degree) / 180.0)
#define toDeg(radiant) (180.0 * (radiant) / M_PI)

@interface STSpeedGaugeView ()

@property (nonatomic, strong) UIView *downloadPoint;
@property (nonatomic, strong) UIView *uploadPoint;
@property (nonatomic, strong) UIImageView* downloadGaugeColor;
@property (nonatomic, strong) UIImageView* downloadGaugeGray;
@property (nonatomic, strong) UIImageView* uploadGaugeColor;
@property (nonatomic, strong) UIImageView* uploadGaugeGray;

@property (nonatomic) CGFloat wheelRadius;
@property (nonatomic) CGFloat xOffset;
@property (nonatomic) CGFloat yOffset;
@property (nonatomic) CGPoint wheelCenter;

@end


@implementation STSpeedGaugeView


#pragma mark - Fade animation

- (void)animateFadeIn
{
    [UIView animateWithDuration:0.6f animations:^{
        _uploadGaugeColor.alpha = 1.0f;
        _uploadGaugeGray.alpha = 0.0f;
        _downloadGaugeColor.alpha = 1.0f;
        _downloadGaugeGray.alpha = 0.0f;
    }];
}

- (void)animateFadeOut
{
    [UIView animateWithDuration:0.2f animations:^{
        _uploadGaugeColor.alpha = 0.0f;
        _uploadGaugeGray.alpha = 1.0f;
        _downloadGaugeColor.alpha = 0.0f;
        _downloadGaugeGray.alpha = 1.0f;
    }];
}


#pragma mark Initialization & creating elements

- (void)createBackgroundGauges {
    // Download
    _downloadGaugeColor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_speed_download"]];
    [self addSubview:_downloadGaugeColor];
    _downloadGaugeColor.alpha=0.0f;
    _downloadGaugeGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_speed_download_gray"]];
    [self addSubview:_downloadGaugeGray];
    
    _downloadPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9, 9)];
    [_downloadPoint.layer setCornerRadius:4.5];
    [_downloadPoint setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_downloadPoint];
    
    // Upload
    _uploadGaugeColor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_speed_upload"]];
    [self addSubview:_uploadGaugeColor];
    [_uploadGaugeColor centerHorizontally];
    [_uploadGaugeColor setBottomMargin:0];
    _uploadGaugeColor.yOrigin += 2;
    _uploadGaugeColor.alpha =0.0f;
    
    _uploadGaugeGray = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_speed_upload_gray"]];
    [self addSubview:_uploadGaugeGray];
    [_uploadGaugeGray centerHorizontally];
    [_uploadGaugeGray setBottomMargin:0];
    _uploadGaugeGray.yOrigin += 2;
    
	
    _uploadPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    [_uploadPoint.layer setCornerRadius:2.5];
    [_uploadPoint setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:_uploadPoint];
}

- (void)setupView {
    _wheelRadius = 110.5;
    _wheelCenter = CGPointMake(116, 116);
    _xOffset = _wheelCenter.x - _wheelRadius;
    _yOffset = _wheelCenter.y - _wheelRadius;
    
    [self createBackgroundGauges];
}

#pragma mark Animations

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

- (CGRect)pointerFrameForCenter:(CGPoint)centerPoint
{
	CGRect currentbtnFrame = _downloadPoint.frame;
	return CGRectMake( roundf(centerPoint.x - CGRectGetWidth(currentbtnFrame) / 2), roundf(centerPoint.y - CGRectGetHeight(currentbtnFrame) / 2), currentbtnFrame.size.width, currentbtnFrame.size.height);
}

- (float)percentageForValue:(float)mBytes
{
	float v = 0;
	if (mBytes <= 20.0) {
		v = 0.683 * mBytes / 20.0;
	} else if (mBytes <= 35) {
		v = 0.683 + (0.833 - 0.683) * (mBytes - 20) / 15;
	} else {
		v = 0.833 + (1 - 0.833) * (mBytes - 35) / 15;
	}
	if (v < 0) v = 0;
	else if (v > 1) v = 1;
	return v;
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

- (void)setDownloadPercentage:(CGFloat)ratio
{
	float angle = -31 + 242.0 * (1 - ratio);
	angle = toRad(angle);
	
	CGPoint pointCenter = [self centerForAngle:angle];
    _downloadPoint.frame = CGRectMakeWithCenter(pointCenter.x, pointCenter.y, _downloadPoint.width, _downloadPoint.height);
}

- (void)setUploadPercentage:(CGFloat)ratio
{
	float angle = -41 - 98 * (1 - ratio);
	angle = toRad(angle);
	
	CGPoint pointCenter = [self centerForAngle:angle];
    _uploadPoint.frame = CGRectMakeWithCenter(pointCenter.x, pointCenter.y, _uploadPoint.width, _uploadPoint.height);
}


- (void)setDownloadSpeed:(CGFloat)bytes
{
	CGFloat mbit = [STSpeedtest getMegabites:bytes];

	float ratio = [self percentageForValue:mbit];
	
	float angle = -31 + 242.0 * (1 - ratio);
	angle = toRad(angle);
	
	CGPoint pointCenter = [self centerForAngle:angle];
    _downloadPoint.frame = CGRectMakeWithCenter(pointCenter.x, pointCenter.y, _downloadPoint.width, _downloadPoint.height);
}

- (void)setUploadSpeed:(CGFloat)bytes
{
	CGFloat mbit = [STSpeedtest getMegabites:bytes];
	
	float ratio = [self percentageForValue:mbit];
	
	float angle = -41 - 98 * (1 - ratio);
	angle = toRad(angle);
	
	CGPoint pointCenter = [self centerForAngle:angle];	
    _uploadPoint.frame = CGRectMakeWithCenter(pointCenter.x, pointCenter.y, _uploadPoint.width, _uploadPoint.height);
}

- (void)reset {
    [self setDownloadSpeed:0];
	[self setUploadSpeed:0];
}


@end
