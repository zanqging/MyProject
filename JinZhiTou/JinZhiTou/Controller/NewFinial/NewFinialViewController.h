//
//  NewFinialViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "UITableViewCustomView.h"
@interface NewFinialViewController : UIViewController
@property(assign,nonatomic)BOOL isBackHome;
@property(retain,nonatomic)NSString* navTitle;
@property (strong, nonatomic)NavView *navView;
@property (nonatomic,assign)BOOL isEndOfPageSize;
@property (strong, nonatomic)UITableViewCustomView *tableView;
@property(retain,nonatomic)NSMutableArray* dataCreateArray;

@end
