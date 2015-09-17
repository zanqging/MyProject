//
//  FinialPersonTableViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/31.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "UITableViewCustomView.h"
@interface FinialPersonTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)NavView *navView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property(assign,nonatomic)NSInteger projectId;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property (weak, nonatomic) IBOutlet UITableViewCustomView *tableView;
@end
