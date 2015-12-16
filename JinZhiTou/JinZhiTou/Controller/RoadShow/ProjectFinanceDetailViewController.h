//
//  RoadShowDetailViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "RoadShowTableViewCell.h"

@interface ProjectFinanceDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(assign,nonatomic)int type;
@property (strong, nonatomic)NavView *navView;
@property(retain,nonatomic)NSString* backTitle;
@property(assign,nonatomic)NSInteger projectId;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
