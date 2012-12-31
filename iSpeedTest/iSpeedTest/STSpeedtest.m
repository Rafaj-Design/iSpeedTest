//
//  STSpeedtest.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STSpeedtest.h"


#define kSTSpeedtestMaxNumberOfItemsForLocalAverage             7


@interface STSpeedtest ()

@property (nonatomic, strong) NSDate *timeStart;
@property (nonatomic) struct STSpeedtestUpdate statusUpdate;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic) NSTimeInterval lastTimeMeasured;
@property (nonatomic, strong) NSMutableArray *localAverage;

@end


@implementation STSpeedtest


#pragma mark File management

- (void)createOutputFile {
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"_speedtest/downloadedFile.dat"];
    [[NSFileManager defaultManager] createFileAtPath:filename contents:nil attributes:nil];
}

#pragma mark Data

- (void)reset {
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"_speedtest/downloadedFile.dat"];
    NSError *err;
    [[NSFileManager defaultManager] removeItemAtPath:filename error:&err];
    if (err) {
        if (kDebug) NSLog(@"Unable to remove temp file: %@", [err localizedDescription]);
    }
    
    _timeStart = nil;    
    _connection = nil;
    _error = nil;
    _localAverage = [NSMutableArray arrayWithCapacity:kSTSpeedtestMaxNumberOfItemsForLocalAverage];
    
    struct STSpeedtestUpdate u;
    u.speed = 0.0f;
    u.averageSpeed = 0.0f;
    u.percentDone = 0.0f;
    u.processedSize = 0.0f;
    u.totalSize = 0.0f;
    u.elapsedTime = 0.0f;
    u.estimatedTime = 0.0f;
    u.status = STSpeedtestStatusInactive;
    _statusUpdate = u;
}

+ (CGFloat)getKilobites:(CGFloat)bytes {
    return (bytes / 128);
}

+ (CGFloat)getMegabites:(CGFloat)bytes {
    return (bytes / 131072);
}

+ (CGFloat)getKilobytes:(CGFloat)bytes {
    return (bytes / 1024);
}

+ (CGFloat)getMegabytes:(CGFloat)bytes {
    return ([self getKilobytes:bytes] / 1024);
}

#pragma mark Initialization

+ (id)startDownloadWithDelegate:(id<STSpeedtestDelegate>)delegate {
    STSpeedtest *c = nil;
    if (delegate) {
        c = [[STSpeedtest alloc] init];
        [c setDelegate:delegate];
        [c startDownload];
    }
    return c;
}

+ (id)startUploadWithDelegate:(id<STSpeedtestDelegate>)delegate andBundleFileName:(NSString *)fileName {
    STSpeedtest *c = nil;
    if (delegate) {
        c = [[STSpeedtest alloc] init];
        [c setDelegate:delegate];
        [c startUploadWithBundleFileName:fileName];
    }
    return c;
}

- (id)init {
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

#pragma mark Data transfer background methods


#pragma mark Actions

- (void)startDownload {
    _statusUpdate.type = STSpeedtestTypeDownloading;
    _statusUpdate.status = STSpeedtestStatusInactive;
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://s3-eu-west-1.amazonaws.com/fuertespeedtestie/download.file"]];
    _connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [_connection start];
}

- (void)startUploadWithBundleFileName:(NSString *)fileName {
    _statusUpdate.type = STSpeedtestTypeUploading;
    _statusUpdate.status = STSpeedtestStatusInactive;
    //NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://s3-eu-west-1.amazonaws.com/fuertespeedtestie/"]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://speedtest.fuerteint.com/receive.php"]];
    NSString *myBoundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", myBoundary];
    [req addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSMutableData *postData = [NSMutableData data]; //[NSMutableData dataWithCapacity:[data length] + 512];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[NSData dataWithData:data]];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", myBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setHTTPBody:postData];
    
    [req setHTTPMethod:@"POST"];
    _connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    [_connection start];
    _statusUpdate.totalSize = postData.length;
    _statusUpdate.status = STSpeedtestStatusWorking;
    _timeStart = [NSDate date];
    [self createOutputFile];
    if ([_delegate respondsToSelector:@selector(speedtest:didReceiveUpdate:)]) {
        [_delegate speedtest:self didReceiveUpdate:_statusUpdate];
    }
}

#pragma mark Data transfer delegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _error = error;
    _statusUpdate.status = STSpeedtestStatusError;
    if ([_delegate respondsToSelector:@selector(speedtest:didReceiveUpdate:)]) {
        [_delegate speedtest:self didReceiveUpdate:_statusUpdate];
    }
    [self reset];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    if (_statusUpdate.type == STSpeedtestTypeUploading) {
        _statusUpdate.status = STSpeedtestStatusWorking;
        _statusUpdate.processedSize += bytesWritten;
        _statusUpdate.percentDone = ((100 * _statusUpdate.processedSize) / _statusUpdate.totalSize);
        NSTimeInterval t = _statusUpdate.elapsedTime;
        _statusUpdate.elapsedTime = ([[NSDate date] timeIntervalSinceNow] - [_timeStart timeIntervalSinceNow]);
        t = (_statusUpdate.elapsedTime - t);
        if ([_localAverage count] >= kSTSpeedtestMaxNumberOfItemsForLocalAverage) [_localAverage removeObjectAtIndex:0];
        [_localAverage addObject:[NSNumber numberWithFloat:(bytesWritten / t)]];
        float f = 0.0f;
        for (NSNumber *n in _localAverage) {
            f += [n floatValue];
        }
        f = (f / [_localAverage count]);
        _statusUpdate.speed = f;
        _statusUpdate.averageSpeed = (_statusUpdate.processedSize / _statusUpdate.elapsedTime);
        if ([_delegate respondsToSelector:@selector(speedtest:didReceiveUpdate:)]) {
            [_delegate speedtest:self didReceiveUpdate:_statusUpdate];
        }
    }
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (_statusUpdate.type == STSpeedtestTypeDownloading) {
        _statusUpdate.totalSize = response.expectedContentLength;
        _statusUpdate.status = STSpeedtestStatusWorking;
        _timeStart = [NSDate date];
        [self createOutputFile];
        if ([_delegate respondsToSelector:@selector(speedtest:didReceiveUpdate:)]) {
            [_delegate speedtest:self didReceiveUpdate:_statusUpdate];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (_statusUpdate.type == STSpeedtestTypeDownloading) {
        _statusUpdate.processedSize += data.length;
        _statusUpdate.percentDone = ((100 * _statusUpdate.processedSize) / _statusUpdate.totalSize);
        NSTimeInterval t = _statusUpdate.elapsedTime;
        _statusUpdate.elapsedTime = ([[NSDate date] timeIntervalSinceNow] - [_timeStart timeIntervalSinceNow]);
        t = (_statusUpdate.elapsedTime - t);
        if ([_localAverage count] >= kSTSpeedtestMaxNumberOfItemsForLocalAverage) [_localAverage removeObjectAtIndex:0];
        [_localAverage addObject:[NSNumber numberWithFloat:(data.length / t)]];
        float f = 0.0f;
        for (NSNumber *n in _localAverage) {
            f += [n floatValue];
        }
        f = (f / [_localAverage count]);
        _statusUpdate.speed = f;
        _statusUpdate.averageSpeed = (_statusUpdate.processedSize / _statusUpdate.elapsedTime);
        if ([_delegate respondsToSelector:@selector(speedtest:didReceiveUpdate:)]) {
            [_delegate speedtest:self didReceiveUpdate:_statusUpdate];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _statusUpdate.status = STSpeedtestStatusFinished;
    if ([_delegate respondsToSelector:@selector(speedtest:didReceiveUpdate:)]) {
        [_delegate speedtest:self didReceiveUpdate:_statusUpdate];
    }
    [self reset];
}


@end
