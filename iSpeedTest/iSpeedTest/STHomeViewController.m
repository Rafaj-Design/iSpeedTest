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
#import "STInfoViewController.h"
#import "UILabel+DynamicHeight.h"
#import <Social/Social.h>


@interface STHomeViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) UIView *notificationLabelView;
@property (nonatomic, strong) UILabel *notificationLabel;

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

- (void)createNotificationBar {
    _notificationLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 310, 20)];
    [_notificationLabelView setBackgroundColor:[UIColor redColor]];
    [_mainView addSubview:_notificationLabelView];
    
    _notificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 290, 0)];
    [_notificationLabel setBackgroundColor:[UIColor clearColor]];
    [_notificationLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [_notificationLabel setTextColor:[UIColor whiteColor]];
    [_notificationLabelView addSubview:_notificationLabel];
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
    [_mainView setBackgroundColor:[STConfig backgroundColor]];
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
    [_tabBarView setBackgroundColor:[STConfig backgroundMenuColor]];
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
    [self createNotificationBar];
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

- (void)showNotification:(NSString *)text withColor:(UIColor *)color {
    [_notificationLabelView setBackgroundColor:color];
    [_notificationLabel setText:text withWidth:290];
    [_notificationLabelView setHeight:(_notificationLabel.height + 8)];
    [UIView animateWithDuration:0.3 animations:^{
        [_notificationLabelView setYOrigin:0];
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:0.3 delay:3.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
           [_notificationLabelView setYOrigin:-_notificationLabelView.height];
       } completion:^(BOOL finished) {
           
       }];
    }];
}

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

#pragma mark Subsection delegate methods

- (void)subsectionView:(STSubsectionView *)view requestNotificationMessage:(NSString *)text withColor:(STSubsectionViewDelegateColor)color {
    UIColor *c;
    if (color == STSubsectionViewDelegateColorRed) c = [UIColor colorWithHexString:@"D70805"];
    else if (color == STSubsectionViewDelegateColorGreen) c = [UIColor colorWithHexString:@"008C23"];
    else if (color == STSubsectionViewDelegateColorOrange) c = [UIColor colorWithHexString:@"FBA900"];
    [self showNotification:text withColor:c];
}

- (void)subsectionViewDidRequestInfoScreen:(STSubsectionView *)view {
    STInfoViewController *c = [[STInfoViewController alloc] init];
    [c setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:c animated:YES completion:^{
        
    }];
}

#pragma mark Sharing actions

- (void)shareHistory:(STSharingObject *)sharingObject on:(NSString *)service {
    SLComposeViewController *c = [SLComposeViewController composeViewControllerForServiceType:service];
    if ([service isEqualToString:SLServiceTypeFacebook]) [c setInitialText:[sharingObject getSharingText]];
    else [c setInitialText:[sharingObject getSharingTextNoAddress]];
    if (sharingObject.mapImage) {
        [c addImage:sharingObject.mapImage];
    }
    [self presentViewController:c animated:YES completion:^{
        
    }];
}

- (void)shareOnFacebook:(STSharingObject *)sharingObject {
    [Flurry logEvent:@"Sharing: Facebook"];
    [self shareHistory:sharingObject on:SLServiceTypeFacebook];
}

- (void)shareOnTwitter:(STSharingObject *)sharingObject {
    [Flurry logEvent:@"Sharing: Twitter"];
    [self shareHistory:sharingObject on:SLServiceTypeTwitter];
}

- (void)shareViaEmail:(STSharingObject *)sharingObject {
    [Flurry logEvent:@"Sharing: Email"];
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

#pragma mark History cell delegate methods

- (void)historyCell:(STHistoryCell *)cell didRequestSharingOn:(STHistoryCellSharing)sharing withSharingObject:(STSharingObject *)sharingObject {
    if (sharing == STHistoryCellSharingFacebook) [self shareOnFacebook:sharingObject];
    else if (sharing == STHistoryCellSharingTwitter) [self shareOnTwitter:sharingObject];
    else if (sharing == STHistoryCellSharingMail) [self shareViaEmail:sharingObject];
}

#pragma mark Mail sharing delegate methords

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	switch(result) {
		case MFMailComposeResultCancelled:
	        NSLog(@"Mail send canceled.");
            [Flurry logEvent:@"Sharing: Email canceled"];
	        break;
		case MFMailComposeResultSaved:
            [Flurry logEvent:@"Sharing: Email saved"];
            [self subsectionView:nil requestNotificationMessage:@"Email has been saved!" withColor:STSubsectionViewDelegateColorGreen];
	        break;
		case MFMailComposeResultSent:
	        [self subsectionView:nil requestNotificationMessage:@"Email has been sent successfully!" withColor:STSubsectionViewDelegateColorGreen];
            [Flurry logEvent:@"Sharing: Email sent"];
	        break;
		case MFMailComposeResultFailed:
	        [Flurry logError:@"Email error" message:@"" error:error];
            [self subsectionView:nil requestNotificationMessage:[NSString stringWithFormat:@"Email error: %@", [error localizedDescription]] withColor:STSubsectionViewDelegateColorRed];
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
