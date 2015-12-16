//
//  AboutMeViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCustomView.h"
#import "NavView.h"
@interface AboutMeViewController : UIViewController
@property (strong, nonatomic)NavView *navView;
@property (retain, nonatomic)UITableViewCustomView *tableView;
@property(retain,nonatomic)NSMutableArray* dataArray;
@end
