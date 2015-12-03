//
//  WMTableViewController.h
//  WMPageController
//
//  Created by Mark on 15/6/13.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "UITableViewCustomView.h"
@protocol WMtableViewCellDelegate <NSObject>
-(void)wmTableViewController:(id)wmTableViewController thinkTankDetailData:(NSDictionary*)dic;
-(void)wmTableViewController:(id)wmTableViewController tapIndexPath:(NSIndexPath*)indexPath data:(NSDictionary*)dic;
-(void)wmTableViewController:(id)wmTableViewController playMedia:(BOOL)playMedia data:(NSDictionary*)dic;
-(void)wmTableViewController:(id)wmTableViewController refresh:(id)sender;
-(void)wmTableViewController:(id)wmTableViewController loadMore:(id)sender;

@end

@interface WMTableViewController : UIViewController
@property(assign,nonatomic)int type;
@property(assign,nonatomic)int menuType;
@property (nonatomic, copy) NSNumber *age;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)UITableViewCustomView* tableView;
@property(retain,nonatomic)id <WMtableViewCellDelegate>delegate;
@end

