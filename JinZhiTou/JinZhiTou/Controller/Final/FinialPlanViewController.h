//
//  FinialPlanViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/31.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface FinialPlanViewController : RootViewController
@property(assign,nonatomic)NSInteger projectId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
