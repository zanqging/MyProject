//
//  RoadShowDetailViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "RoadShowTableViewCell.h"

@interface RoadShowDetailViewController : UIViewController
@property(assign,nonatomic)int type;
@property (retain, nonatomic)NavView *navView;
@property(retain,nonatomic)NSString* backTitle;
@property(retain,nonatomic)NSMutableDictionary * dic;
@property (retain, nonatomic)UITableView *tableViewCustom;

@end
