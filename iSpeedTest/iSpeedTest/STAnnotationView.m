//
//  STAnnotationView.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 03/12/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STAnnotationView.h"
#import "STHistory.h"


@interface STAnnotationView ()

@property (nonatomic, strong) UIImageView *pinView;
@property (nonatomic, strong) UILabel *connectionLabel;

@end


@implementation STAnnotationView


#pragma mark Initialization

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setEnabled:YES];
        [self setCanShowCallout:YES];
        
        UIImage *img = [UIImage imageNamed:@"SP_ico_pin"];
        [self setImage:img];
        
        [self setCenterOffset:CGPointMake(8, -18)];
        [self setCalloutOffset:CGPointMake(-8, 0)];
        
        _connectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 10, 17, 9)];
        [_connectionLabel setFont:[STConfig fontWithSize:9]];
        [_connectionLabel setBackgroundColor:[UIColor clearColor]];
        [_connectionLabel setTextColor:[UIColor darkGrayColor]];
        [_connectionLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_connectionLabel];
    }
    return self;
}

- (void)setHistoryItem:(STHistory *)item {
    _historyItem = item;
    NSString *s = ([[_historyItem.connection lowercaseString] isEqualToString:@"wifi"] ? _historyItem.connection : _historyItem.network);
    [_connectionLabel setText:[s substringToIndex:1]];
}

@end
