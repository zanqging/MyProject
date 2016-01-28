//
//  FinialPlanViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/31.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SDAutoLayout.h"
#import "RootViewController.h"
#import "UITableViewCustomView.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@interface FinialPlanViewController : RootViewController
@property(assign,nonatomic) NSInteger projectId;
@property (retain, nonatomic) UITableView *tableView;

@end
