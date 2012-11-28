//
//  STAppDelegate.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kSTManagedObject                                [(STAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]
#define kSTManagedObjectSave                            [(STAppDelegate *)[[UIApplication sharedApplication] delegate] saveContext]


@class STHomeViewController;


@interface STAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) STHomeViewController *viewController;

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;


@end
