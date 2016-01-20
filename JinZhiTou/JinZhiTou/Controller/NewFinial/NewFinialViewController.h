//
//  NewFinialViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "BannerViewController.h"
#import "UITableViewCustomView.h"
@interface NewFinialViewController : RootViewController
@property(assign,nonatomic)BOOL isBackHome;
@property(retain,nonatomic)NSString* navTitle;
@property (nonatomic,assign)BOOL isEndOfPageSize;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(nonatomic,retain)BannerViewController* webViewController;
@property (strong, nonatomic)UITableViewCustomView *tableView;

@end
