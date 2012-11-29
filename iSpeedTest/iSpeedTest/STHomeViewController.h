//
//  STHomeViewController.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STViewController.h"
#import "STSpeedtestView.h"


@interface STHomeViewController : STViewController <STSpeedtestViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


@end
