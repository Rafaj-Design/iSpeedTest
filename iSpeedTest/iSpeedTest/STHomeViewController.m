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
#import "STSharingObject.h"
#import <Social/Social.h>


@interface STHomeViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *tabBarView;
@property (nonatomic, strong) UIImageView *tabBarIndicatorView;
@property (nonatomic, strong) UIButton *mapTabButton;
@property (nonatomic, strong) UIButton *speedTabButton;
@property (nonatomic, strong) UIButton *historyTabButton;

@property (nonatomic, strong) STMapView *mapView;
@property (nonatomic, strong) STSpeedtestView *speedtestView;
@property (nonatomic, strong) STHistoryView *historyView;

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

- (CGRect)scrollviewRect {
    return CGRectMake(0, 44, 310, ([self screenHeight] - 49));
}

- (CGRect)insideRectAtIndex:(NSInteger)index {
    return CGRectMake((index * 310), 0, 310, _scrollView.height);
}

#pragma mark Animations

- (void)animateIndicatorForTabButton:(UIButton *)button {
	BOOL bounce = NO;
    button.selected = YES;
    CGRect newFrame = button.frame;
    newFrame.origin.x -= 10;
    int position = 0;
    if (newFrame.origin.x < _tabBarIndicatorView.frame.origin.x) position = -1; // To the left
    else position = 1; // To the right
    
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    if (bounce) {
        animation.duration = 0.3;
        animation.values = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:[[_tabBarIndicatorView.layer presentationLayer] frame].origin.x + _tabBarIndicatorView.width / 2],
                            [NSNumber numberWithFloat:newFrame.origin.x + 6 * position + _tabBarIndicatorView.width / 2],
                            [NSNumber numberWithFloat:newFrame.origin.x - 6 * position + _tabBarIndicatorView.width / 2],
                            [NSNumber numberWithFloat:newFrame.origin.x + _tabBarIndicatorView.width / 2], nil];
        animation.keyTimes = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:0.70],
                              [NSNumber numberWithFloat:0.850],
                              [NSNumber numberWithFloat:1.0], nil];
        
        animation.timingFunctions = [NSArray arrayWithObjects:
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], nil];
    }
    else {
        animation.duration = 0.4;
        animation.values = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:[[_tabBarIndicatorView.layer presentationLayer] frame].origin.x + _tabBarIndicatorView.width/2],
                            [NSNumber numberWithFloat:newFrame.origin.x + _tabBarIndicatorView.width/2], nil];
        animation.keyTimes = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:1.0], nil];
        
        animation.timingFunctions = [NSArray arrayWithObjects:
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], nil];
    }
    
    [_tabBarIndicatorView.layer addAnimation:animation forKey:@"boing"];
    [_tabBarIndicatorView setXOrigin:newFrame.origin.x];
}

#pragma mark Creating elements

- (void)configureView {
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)createSpeedtestView {
    if (!_speedtestView) {
        _speedtestView = [[STSpeedtestView alloc] initWithFrame:[self insideRectAtIndex:1]];
        [_speedtestView setDelegate:self];
        [_speedtestView setControllerDelegate:self];
    }
    [_scrollView addSubview:_speedtestView];
}

- (void)createMapView {
    _mapView = [[STMapView alloc] initWithFrame:[self insideRectAtIndex:0]];
    [_mapView setControllerDelegate:self];
    [_scrollView addSubview:_mapView];
}

- (void)createHistoryView {
    _historyView = [[STHistoryView alloc] initWithFrame:[self insideRectAtIndex:2]];
    [_historyView setControllerDelegate:self];
    [_scrollView addSubview:_historyView];
}

- (void)createMainView {
    // Creating main view
    _mainView = [[UIView alloc] initWithFrame:[self mainViewRect]];
    [_mainView setAlpha:0];
    [_mainView setClipsToBounds:YES];
    [_mainView setBackgroundColor:[UIColor colorWithHexString:@"EFEDD2"]];
    [_mainView.layer setCornerRadius:5];
    [self.view addSubview:_mainView];
}

- (void)createScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:[self scrollviewRect]];
    [_scrollView setContentSize:CGSizeMake((3 * 310), _scrollView.size.height)];
    [_scrollView setPagingEnabled:YES];
    [_scrollView setContentOffset:CGPointMake(310, 0)];
    [_scrollView setScrollEnabled:NO];
    [_mainView addSubview:_scrollView];
    
    // Creating subviews
    [self createMapView];
    [self createSpeedtestView];
    [self createHistoryView];
}

- (void)createTabBarView {
    CGRect r = CGRectZero;
    
    // Creating top tab bar
    _tabBarView = [[UIView alloc] initWithFrame:[self tabBarRect]];
    [_tabBarView setBackgroundColor:[UIColor colorWithHexString:@"E7E5CB"]];
    [_mainView addSubview:_tabBarView];
    UIImage *img = [[UIImage imageNamed:@"SP_menu_line"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    UIImageView *bcg = [[UIImageView alloc] initWithImage:img];
    [bcg setWidth:310];
    [bcg setYOrigin:44];
    [_tabBarView addSubview:bcg];
    
    img = [UIImage imageNamed:@"SP_menu_divider"];
    r = _tabBarView.bounds;
    r.size.height = img.size.height;
    r.origin.y = 17;
    STAutoLineView *dividers = [[STAutoLineView alloc] initWithFrame:r];
    for (int i = 0; i < 2; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:img];
        [dividers addSubview:iv];
    }
    [_tabBarView addSubview:dividers];
    [dividers layoutElements];
    
    // Creating moving thingy
    _tabBarIndicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SP_menu_chosen"]];
    [_tabBarIndicatorView setYOrigin:44];
    [_tabBarView addSubview:_tabBarIndicatorView];
    [_tabBarIndicatorView centerHorizontally];
    
    // Create buttons
    r = _tabBarView.bounds;
    r.origin.x = 25;
    r.size.width -= 50;
    STAutoLineView *v = [[STAutoLineView alloc] initWithFrame:r];
    [v setEnableSideSpace:NO];
    [_tabBarView addSubview:v];
    [v setYOrigin:5];
    
    r = CGRectZero;
    r.size.height = 44;
    UIImage *btnImg = [UIImage imageNamed:@"SP_ico_menu_map"];
    UIImage *btnImgSel = [UIImage imageNamed:@"SP_ico_menu_map_active"];
    r.size.width = btnImg.size.width;
    _mapTabButton = [[UIButton alloc] initWithFrame:r];
    [_mapTabButton addTarget:self action:@selector(didPressTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [_mapTabButton setImage:btnImg forState:UIControlStateNormal];
    [_mapTabButton setImage:btnImgSel forState:UIControlStateSelected];
    [v addSubview:_mapTabButton];
    
    btnImg = [UIImage imageNamed:@"SP_ico_menu_speed"];
    btnImgSel = [UIImage imageNamed:@"SP_ico_menu_speed_active"];
    r.size.width = btnImg.size.width;
    _speedTabButton = [[UIButton alloc] initWithFrame:r];
    [_speedTabButton addTarget:self action:@selector(didPressTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [_speedTabButton setImage:btnImg forState:UIControlStateNormal];
    [_speedTabButton setImage:btnImgSel forState:UIControlStateSelected];
    [_speedTabButton setSelected:YES];
    [v addSubview:_speedTabButton];

    btnImg = [UIImage imageNamed:@"SP_ico_menu_history"];
    btnImgSel = [UIImage imageNamed:@"SP_ico_menu_history_active"];
    r.size.width = btnImg.size.width;
    _historyTabButton = [[UIButton alloc] initWithFrame:r];
    [_historyTabButton addTarget:self action:@selector(didPressTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
    [_historyTabButton setImage:btnImg forState:UIControlStateNormal];
    [_historyTabButton setImage:btnImgSel forState:UIControlStateSelected];
    [v addSubview:_historyTabButton];
    
    [v layoutElements];
}

- (void)createAllElements {
    [super createAllElements];
    
    [self createMainView];
    [self createScrollView];
    [self createTabBarView];
}

#pragma mark View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        [_mainView setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_historyView updateData];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark Actions

- (void)resetTabBarButtons {
    [_mapTabButton setSelected:NO];
    [_speedTabButton setSelected:NO];
    [_historyTabButton setSelected:NO];
}

- (void)didPressTabBarButton:(UIButton *)sender {
    if (!sender.isSelected) {
        [self resetTabBarButtons];
        [sender setSelected:YES];
        [self animateIndicatorForTabButton:sender];
        NSInteger index = [[sender.superview subviews] indexOfObject:sender];
        [_scrollView setContentOffset:CGPointMake((index * 310), 0) animated:YES];
        if (index == 0) {
            [Flurry logEvent:@"Screen: Map"];
            [NSTimer scheduledTimerWithTimeInterval:0.3 target:_mapView selector:@selector(zoomToSeeAllAnnotations) userInfo:nil repeats:NO];
        }
        else if (index == 1) [Flurry logEvent:@"Screen: Speed"];
        else if (index == 2) [Flurry logEvent:@"Screen: History"];
    }
}

#pragma mark Sharing actions

- (void)shareHistory:(STSharingObject *)sharingObject on:(NSString *)service {
    SLComposeViewController *c = [SLComposeViewController composeViewControllerForServiceType:service];
    if ([service isEqualToString:SLServiceTypeFacebook]) [c setInitialText:[sharingObject getSharingText]];
    else [c setInitialText:[sharingObject getFullSharingText]];
    if (sharingObject.mapImage) {
        [c addImage:sharingObject.mapImage];
    }
    [self presentViewController:c animated:YES completion:^{
        
    }];
}

- (void)shareOnFacebook:(STSharingObject *)sharingObject {
    [self shareHistory:sharingObject on:SLServiceTypeFacebook];
}

- (void)shareOnTwitter:(STSharingObject *)sharingObject {
    [self shareHistory:sharingObject on:SLServiceTypeTwitter];
}

- (void)shareViaEmail:(STSharingObject *)sharingObject {
    MFMailComposeViewController *c = [[MFMailComposeViewController alloc] init];
    [c setMailComposeDelegate:self];
    [c setSubject:@"Connection speed"];
    
    NSString *message = [NSString stringWithFormat:@"Hey Buddy,\n\n%@\n\nCheck your connection speed with %@ app!\n\n", [sharingObject getFullSharingText], [STConfig appName]];
    [c setMessageBody:message isHTML:NO];
    
    NSData *imageData;
    
    if (sharingObject.mapImage) {
        imageData = UIImageJPEGRepresentation(sharingObject.mapImage, 90);
        [c addAttachmentData:imageData mimeType:@"image/png" fileName:@"map.png"];
    }
    
    imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]];
	[c addAttachmentData:imageData mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@.png", [[STConfig developerName] stringByReplacingOccurrencesOfString:@" " withString:@"-"]]];
    
    [self presentViewController:c animated:YES completion:^{
        
    }];
}

#pragma mark Mail sharing delegate methords

- (void)showEmailErrorMessage:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	switch(result) {
		case MFMailComposeResultCancelled:
	        NSLog(@"Mail send canceled.");
	        break;
		case MFMailComposeResultSaved:
	        break;
		case MFMailComposeResultSent:
	        NSLog(@"Mail sent.");
	        break;
		case MFMailComposeResultFailed:
	        NSLog(@"Mail send error: %@.", [error localizedDescription]);
            [self showEmailErrorMessage:error];
	        break;
		default:
	        break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Speed test view delegate methods

- (void)speedtestViewDidStartMeasurment:(STSpeedtestView *)view {
    [Flurry logEvent:@"Action: Start measuring"];
}

- (void)speedtestViewDidStopMeasurment:(STSpeedtestView *)view withResults:(STHistory *)history {
    [_historyView updateData];
    [_mapView updateData];
}


@end
