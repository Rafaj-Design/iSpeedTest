//
//  STAPIConnection.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 31/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STAPIConnection : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, strong, readonly) NSMutableData *receivedData;
@property (nonatomic, strong, readonly) NSString *receivedString;
@property (nonatomic, strong, readonly) NSDictionary *receivedJsonData;
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly) BOOL receivedMessageOK;


- (NSURLConnection *)connectionForUrl:(NSString *)url;
- (void)connection:(NSURLConnection *)connection didFinishWithError:(NSError *)error;


@end
