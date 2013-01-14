//
//  STAPISendReportConnection.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 31/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STAPIConnection.h"
#import "STHistory.h"


@interface STAPISendReportConnection : STAPIConnection

- (void)sendHistoryReport:(STHistory *)history;


@end
