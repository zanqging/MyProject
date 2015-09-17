//
//  RelpyMessageViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/11.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
@interface RelpyMessageViewController : UIViewController
@property(retain,nonatomic)NavView* navView;
@property (assign, nonatomic) NSInteger rowsCount;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)UITableView* tableView;
@end
