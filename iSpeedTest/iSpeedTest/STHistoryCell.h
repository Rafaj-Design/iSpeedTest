//
//  STHistoryCell.h
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 29/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


typedef enum {
    STHistoryCellSharingFacebook,
    STHistoryCellSharingTwitter,
    STHistoryCellSharingMail
} STHistoryCellSharing;


@class STHistory, STHistoryCell, STSharingObject;


@protocol STHistoryCellDelegate <NSObject>

- (void)historyCell:(STHistoryCell *)cell didRequestSharingOn:(STHistoryCellSharing)sharing withSharingObject:(STSharingObject *)sharingObject;

@end


@interface STHistoryCell : UITableViewCell <MKMapViewDelegate>

@property (nonatomic, weak) id <STHistoryCellDelegate> delegate;


- (void)setHistory:(STHistory *)history;
- (void)enableMap:(BOOL)enable;
- (void)showAdvancedInfo:(BOOL)show;


@end
