//
//  TeamShowViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "UITableViewCustomView.h"
@interface TeamShowViewController : RootViewController
@property(assign,nonatomic)NSInteger projectId;
@property(assign,nonatomic)BOOL isEndOfPageSize;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)UITableViewCustomView* tableView;
@end
