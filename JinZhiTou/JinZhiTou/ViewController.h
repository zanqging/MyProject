//
//  ViewController.h
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "WeiboTableViewCell.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic)UITableView *tableView;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)NavView* navView;
@property(assign,nonatomic)BOOL isEndOfPageSize;
@end

