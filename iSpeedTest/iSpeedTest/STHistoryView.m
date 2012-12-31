//
//  STHistoryView.m
//  iSpeedTest
//
//  Created by Ondrej Rafaj on 28/11/2012.
//  Copyright (c) 2012 Fuerte Innovations. All rights reserved.
//

#import "STHistoryView.h"
#import "STAppDelegate.h"
#import "STHistoryCell.h"
#import "STHistoryEmptyCell.h"
#import "STHistory.h"
#import "STHistoryHeaderView.h"


@interface STHistoryView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) NSIndexPath *expandedCell;

@end


@implementation STHistoryView


#pragma mark Creating elements

- (void)createTableView {
    CGRect r = self.bounds;
    r.origin.y += 10;
    r.size.height -= 15;
    _tableView = [[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_tableView];
}

#pragma mark Settings

- (void)updateData {
    NSError *error;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"STHistory" inManagedObjectContext:kSTManagedObject]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    //NSString *complexPredicateFormat = [NSString stringWithFormat:@"length < 90"];
    //NSPredicate *complexPredicate = [NSPredicate predicateWithFormat:complexPredicateFormat argumentArray:nil];
    //[request setPredicate:complexPredicate];
    
    _data = [kSTManagedObject executeFetchRequest:request error:&error];
    [_tableView reloadData];
}

- (void)resetExpandableCell {
    _expandedCell = [NSIndexPath indexPathForRow:INT16_MAX inSection:0];
}

#pragma mark Initialization

- (void)setupView {
    [super setupView];
    
    [self resetExpandableCell];
    [self createTableView];
    [self updateData];
}

#pragma mark Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([_data count] > 0) ? [_data count] : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ([_data count] > 0) ? 64 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return ([_data count] > 0) ? [[STHistoryHeaderView alloc] initWithFrame:CGRectMake(0, 0, 310, 40)] : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (_expandedCell.row == indexPath.row) ? 170 : 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_data count] > 0) {
        static NSString *cellIdentifier = @"dataCell";
        STHistoryCell *cell = (STHistoryCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[STHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        STHistory *h = [_data objectAtIndex:indexPath.row];
        [cell setHistory:h];
        [cell enableMap:(_expandedCell.row == indexPath.row)];
        return cell;
    }
    else {
        static NSString *cellIdentifier = @"emptyCell";
        STHistoryEmptyCell *cell = (STHistoryEmptyCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[STHistoryEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSIndexPath *oldPath = _expandedCell;
    if ([_data count] > 0) {
        if (_expandedCell.row == indexPath.row) {
            [self resetExpandableCell];
            [_tableView beginUpdates];
            [_tableView endUpdates];
        }
        else {
            _expandedCell = indexPath;
            
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObject:_expandedCell];
            if (oldPath.row < [_data count] && oldPath.row != _expandedCell.row) [arr addObject:oldPath];
            
            [_tableView beginUpdates];
            [_tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
            [_tableView endUpdates];
        }
    }
}


@end
