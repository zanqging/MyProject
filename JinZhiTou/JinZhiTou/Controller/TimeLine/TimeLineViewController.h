//
//  TimeLineViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "UITableViewCustomView.h"
@interface TimeLineViewController : UIViewController
@property (strong, nonatomic) IBOutlet NavView *navView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property(assign,nonatomic)BOOL isBackHome;
@property(retain,nonatomic)NSString* navTitle;
@property (nonatomic,assign)BOOL isEndOfPageSize;
@property (strong, nonatomic)UITableViewCustomView *tableView;
@property(retain,nonatomic)NSMutableArray* dataCreateArray;
@property(retain,nonatomic)NSMutableArray* dataFinialArray;
@end
