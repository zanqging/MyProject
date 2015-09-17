//
//  UserInfoViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
@interface UserInfoViewController : UIViewController
@property(assign,nonatomic)BOOL isAmious;
@property(retain,nonatomic)NSArray* dataArray;
@property (strong, nonatomic)NavView *navView;
@property (strong, nonatomic)UITableView *tableView;


@end
