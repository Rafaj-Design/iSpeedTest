//
//  STHomeViewController.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STViewController.h"
#import "STSpeedtestView.h"
#import <MessageUI/MessageUI.h>


@class STSharingObject;


@interface STHomeViewController : STViewController <STSpeedtestViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


- (void)shareOnFacebook:(STSharingObject *)history;
- (void)shareOnTwitter:(STSharingObject *)history;
- (void)shareViaEmail:(STSharingObject *)history;


@end
