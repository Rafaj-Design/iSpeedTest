//
//  STAPIConnection.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 31/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STAPIConnection.h"
#import "NSString+StringTools.h"


@implementation STAPIConnection


#pragma mark Connection

- (NSURLConnection *)connectionForUrl:(NSString *)url {
    url = [url stringByAppendingFormat:@"%@appId=%@", ([url containsString:@"?"] ? @"&" : @"?"), [STConfig appIdentifier]];
    _url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (kDebug) NSLog(@"Request URL: %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLCacheStorageAllowed timeoutInterval:10.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        _receivedData = [NSMutableData data];
    }
    return connection;
}

- (void)connection:(NSURLConnection *)connection didFinishWithError:(NSError *)error {
    
}

#pragma mark Connection delgate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _statusCode = [(NSHTTPURLResponse *)response statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self connection:connection didFinishWithError:error];
    if (kDebug) NSLog(@"Connection error: %@ in URL: %@", [error localizedDescription], _url);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *dataString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    _receivedString = dataString;
    NSError *err;
    _receivedJsonData = [NSJSONSerialization JSONObjectWithData:_receivedData options:NSJSONReadingMutableContainers error:&err];
    _receivedMessageOK = [[_receivedJsonData objectForKey:@"success"] boolValue];
    [self connection:connection didFinishWithError:nil];
}


@end
