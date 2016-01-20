//
//  RoadShowDetailViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "RootViewController.h"
#import "RoadShowTableViewCell.h"

@interface RoadShowDetailViewController : RootViewController
@property(assign,nonatomic)int type;
@property (retain, nonatomic) NSMutableDictionary * dic;
@property(retain,nonatomic)Project * project;
@property(retain,nonatomic)NSString* backTitle;

@end
