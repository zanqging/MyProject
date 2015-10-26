//
//  ActionDetailViewController.h
//  Cycle
//
//  Created by air on 15/10/14.
//  Copyright © 2015年 csz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionHeader.h"
#import "NavView.h"
#import "CyclePriseTableViewCell.h"
#import "CycleShareTableViewCell.h"
@interface ActionDetailViewController : UIViewController
@property(retain,nonatomic)UITableView* tableView;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)NSString* classStringName;
@property(assign,nonatomic)NSInteger selectIndex;
@property(retain,nonatomic)NSDictionary* dic;
@property(retain,nonatomic)NSString* projectId;
@property(assign,nonatomic)BOOL isEndOfPageSize;
@property(retain,nonatomic)NavView* navView;
@end
