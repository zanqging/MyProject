//
//  ViewController.h
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "WeiboTableViewCell.h"
@interface ViewController_bak : RootViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic)UITableView *tableView;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(assign,nonatomic)BOOL isEndOfPageSize;

-(void)loadData;
@end

