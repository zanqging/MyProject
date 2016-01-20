//
//  WMTableViewController.h
//  WMPageController
//
//  Created by Mark on 15/6/13.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "RootViewController.h"
#import "UITableViewCustomView.h"
@protocol WMtableViewCellDelegate <NSObject>
-(void)wmTableViewController:(id)wmTableViewController comFincance:(NSDictionary*)dic;
-(void)wmTableViewController:(id)wmTableViewController personalFincance:(NSDictionary*)dic;
-(void)wmTableViewController:(id)wmTableViewController thinkTankDetailData:(NSDictionary*)dic;
-(void)wmTableViewController:(id)wmTableViewController tapIndexPath:(NSIndexPath*)indexPath atSelectedIndex:(int)selectedIndex data:(NSDictionary*)dic;
-(void)wmTableViewController:(id)wmTableViewController playMedia:(BOOL)playMedia data:(NSDictionary*)dic;
-(void)wmTableViewController:(id)wmTableViewController refresh:(id)sender;
-(void)wmTableViewController:(id)wmTableViewController loadMore:(id)sender;

@end

@interface WMTableViewController : RootViewController
@property(assign,nonatomic)int menuSelectIndex;
@property(assign,nonatomic)int currentPage;
@property(assign,nonatomic)int selectIndex;
@property (nonatomic, copy) NSNumber *age;

@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)UITableViewCustomView* tableView;
@property(retain,nonatomic)id <WMtableViewCellDelegate>delegate;
@end

