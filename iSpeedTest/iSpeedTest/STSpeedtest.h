//
//  STSpeedtest.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    STSpeedtestStatusInactive,
    STSpeedtestStatusWorking,
    STSpeedtestStatusFinished,
    STSpeedtestStatusError
} STSpeedtestStatus;

typedef enum {
    STSpeedtestTypeDownloading,
    STSpeedtestTypeUploading
} STSpeedtestType;


struct STSpeedtestUpdate
{
    CGFloat speed;
    CGFloat averageSpeed;
    CGFloat percentDone;
    CGFloat processedSize;
    CGFloat totalSize;
    NSTimeInterval elapsedTime;
    NSTimeInterval estimatedTime;
    STSpeedtestStatus status;
    STSpeedtestType type;
};


@class STSpeedtest;

@protocol STSpeedtestDelegate <NSObject>

- (void)speedtest:(STSpeedtest *)test didReceiveUpdate:(struct STSpeedtestUpdate)update;

@end


@interface STSpeedtest : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id<STSpeedtestDelegate> delegate;
@property (nonatomic, strong, readonly) NSError *error;

+ (id)startDownloadWithDelegate:(id<STSpeedtestDelegate>)delegate;
+ (id)startUploadWithDelegate:(id<STSpeedtestDelegate>)delegate;

- (void)startDownload;
- (void)startUpload;

+ (CGFloat)getKilobites:(CGFloat)bytes;
+ (CGFloat)getMegabites:(CGFloat)bytes;
+ (CGFloat)getKilobytes:(CGFloat)bytes;
+ (CGFloat)getMegabytes:(CGFloat)bytes;

@end
