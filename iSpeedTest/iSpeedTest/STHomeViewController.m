//
//  STHomeViewController.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 23/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STHomeViewController.h"
#import "STSpeedtestView.h"
#import "STHistoryView.h"
#import "STMapView.h"
#import "STAutoLineView.h"


@interface STHomeViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *tabBarView;
@property (nonatomic, strong) UIImageView *tabBarIndicatorView;
@property (nonatomic, strong) UIButton *_mapTabButton;
@property (nonatomic, strong) UIButton *_speedTabButton;
@property (nonatomic, strong) UIButton *_historyTabButton;

@property (nonatomic, strong) STSpeedtestView *speedtestView;

@end


@implementation STHomeViewController


#pragma mark Positioning

- (CGFloat)screenHeight {
    if([[UIScreen mainScreen] bounds].size.height == 568) {
        return 548;
    }
    else return 460;
}

- (CGRect)mainViewRect {
    return CGRectMake(5, 5, 310, ([self screenHeight] - 10));
}

- (CGRect)tabBarRect {
    return CGRectMake(0, 0, 310, 44);
}

- (CGRect)insideRectAtIndex:(NSInteger)index {
    CGFloat ySpace = 30;
    return CGRectMake((index * 310), ySpace, 310, ([self mainViewRect].size.height - ySpace));
}

#pragma mark Data

- (void)loadData {
    /*_currentIndex = [FCConfig getLastUsedIndex];
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:kCDMessageTableName inManagedObjectContext:_managedObjectContext]];
    
    / *
     NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"views" ascending:YES];
     [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
     // * /
    
    NSString *complexPredicateFormat = [NSString stringWithFormat:@"length < 90"];
    NSPredicate *complexPredicate = [NSPredicate predicateWithFormat:complexPredicateFormat argumentArray:nil];
    [request setPredicate:complexPredicate];
    
    _data = [_managedObjectContext executeFetchRequest:request error:&error];*/
}

#pragma mark Creating elements

- (void)configureView {
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (UILabel *)labelVithFontSize:(CGFloat)size andFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setBackgroundColor:[UIColor redColor]];
    [label setTextColor:[UIColor colorWithHexString:@"3a3c3c"]];
    [label setFont:[STConfig fontWithSize:size]];
    return label;
}

- (void)createSpeedtestView {
    if (!_speedtestView) {
        _speedtestView = [[STSpeedtestView alloc] initWithFrame:[super fullscreenFrame]];
        [_speedtestView setBackgroundColor:[UIColor greenColor]];
    }
    [_mainView addSubview:_speedtestView];
}

- (void)createMapView {
    
}

- (void)createHistoryView {
    
}

- (void)createMainView {
    // Creating main view
    _mainView = [[UIView alloc] initWithFrame:[self mainViewRect]];
    [_mainView setClipsToBounds:YES];
    [_mainView setBackgroundColor:[UIColor colorWithHexString:@"EFEDD2"]];
    [_mainView.layer setCornerRadius:5];
    [self.view addSubview:_mainView];
    
    // Creating subviews
//    [self createSpeedtestView];
//    [self createSpeedtestView];
//    [self createSpeedtestView];
}

- (void)createTabBarView {
    // Creating top tab bar
    _tabBarView = [[UIView alloc] initWithFrame:[self tabBarRect]];
    [_tabBarView setBackgroundColor:[UIColor colorWithHexString:@"E7E5CB"]];
    [_mainView addSubview:_tabBarView];
    UIImage *img = [[UIImage imageNamed:@"SP_menu_line"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    UIImageView *bcg = [[UIImageView alloc] initWithImage:img];
    [bcg setWidth:310];
    [bcg setYOrigin:44];
    [_tabBarView addSubview:bcg];
    
    // Creating moving thingy
    _tabBarIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_menu_chosen"]];
    [_tabBarIndicatorView setYOrigin:44];
    [_tabBarView addSubview:_tabBarIndicatorView];
    [_tabBarIndicatorView centerHorizontally];
    
    // Create buttons
    STAutoLineView *v = [[STAutoLineView alloc] initWithFrame:_tabBarView.bounds];
    [_tabBarView addSubview:v];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createMainView];
    [self createTabBarView];
}


@end
