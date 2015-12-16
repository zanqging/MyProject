//
//  UserInfoViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface UserInfoViewController : RootViewController
@property(retain,nonatomic)NSArray* dataArray;
@property (strong, nonatomic)UITableView *tableView;


@end
