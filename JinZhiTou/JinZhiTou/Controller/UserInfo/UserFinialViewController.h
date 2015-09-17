//
//  UserFinialViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/8.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "UITableViewCustomView.h"
@interface UserFinialViewController : UIViewController

@property(assign,nonatomic)BOOL isBackHome;
@property(retain,nonatomic)NSString* navTitle;
@property (strong, nonatomic)NavView *navView;
@property (nonatomic,assign)BOOL isEndOfPageSize;
@property (strong, nonatomic)UITableViewCustomView *tableView;
@property(retain,nonatomic)NSMutableArray* dataCreateArray;
@property(retain,nonatomic)NSMutableArray* dataFinialArray;
@end
