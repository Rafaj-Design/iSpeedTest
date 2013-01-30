//
//  STInfoViewController.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 14/01/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "STInfoViewController.h"


@interface STInfoViewController ()

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) FTCoreTextView *coreTextView;

@end


@implementation STInfoViewController


#pragma mark Positioning

- (CGFloat)screenHeight {
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        return 548;
    }
    else return 460;
}

- (CGRect)mainViewRect {
    return CGRectMake(5, 5, 310, ([self screenHeight] - 10));
}

#pragma mark Creating elements

- (void)createMainView {
    _mainView = [[UIView alloc] initWithFrame:[self mainViewRect]];
    [_mainView setClipsToBounds:YES];
    [_mainView setBackgroundColor:[STConfig backgroundColor]];
    [_mainView.layer setCornerRadius:5];
    [self.view addSubview:_mainView];
}

- (void)applyTextEffectsOnBarButtonItem:(UIBarButtonItem *)item {
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor], UITextAttributeTextColor, [UIColor clearColor], UITextAttributeTextShadowColor, nil] forState:UIControlStateNormal];
}

- (void)createTopBar {
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 310, 44)];
    [_toolbar setTintColor:[STConfig backgroundMenuColor]];
    [_mainView addSubview:_toolbar];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    [self applyTextEffectsOnBarButtonItem:item];
    [arr addObject:item];
    
    item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [arr addObject:item];
    
    item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"About", @"") style:UIBarButtonItemStylePlain target:nil action:nil];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, [NSValue valueWithUIOffset:UIOffsetMake(1, 1)], UITextAttributeTextShadowOffset, nil] forState:UIControlStateNormal];
    [arr addObject:item];
    
    item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [arr addObject:item];
    
    item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Web", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(openWebsite)];
    [self applyTextEffectsOnBarButtonItem:item];
    [arr addObject:item];
    
    [_toolbar setItems:arr];
}

- (void)createCoreTextView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 310, ([self screenHeight] - 10 - 44))];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    CGSize s = _scrollView.size;
    s.height += 1;
    [_scrollView setContentSize:s];
    [_mainView addSubview:_scrollView];
    
    CGRect r = _scrollView.bounds;
    r.origin.x += 10;
    r.size.width -= 20;
    _coreTextView = [[FTCoreTextView alloc] initWithFrame:r];
    [_coreTextView setDelegate:self];
    [_coreTextView setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:_coreTextView];
    
    FTCoreTextStyle *style = [[FTCoreTextStyle alloc] init];
    [style setFont:[STConfig fontWithSize:18]];
    [style setName:@"h1"];
    [style setLeading:0];
    [_coreTextView addStyle:style];
    
    style = [[FTCoreTextStyle alloc] init];
    [style setName:@"p"];
    [style setLeading:0];
    [style setColor:[UIColor grayColor]];
    [_coreTextView addStyle:style];
    
    style = [[FTCoreTextStyle alloc] init];
    [style setName:@"_bullet"];
    [style setLeading:0];
    [style setColor:[UIColor grayColor]];
    [_coreTextView addStyle:style];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"xml"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [_coreTextView setText:content];
    s = [_coreTextView suggestedSizeConstrainedToSize:CGSizeMake(290, 999999)];
    [_scrollView setContentSize:s];
    [_coreTextView setSize:s];
}

- (void)createAllElements {
    [super createAllElements];
    [self createMainView];
    [self createTopBar];
    [self createCoreTextView];
}

#pragma mark Core text delegate method

- (void)coreTextView:(FTCoreTextView *)coreTextView receivedTouchOnData:(NSDictionary *)data {
    if ([data objectForKey:@"url"]) {
        [[UIApplication sharedApplication] openURL:[data objectForKey:@"url"]];
    }
}

#pragma mark Actions

- (void)openWebsite {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[STConfig developerUrl]]];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
