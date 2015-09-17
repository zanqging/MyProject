//
//  FinialPlanViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/31.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"

@interface FinialPlanViewController : UIViewController
@property (strong, nonatomic)NavView *navView;
@property(assign,nonatomic)NSInteger projectId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
