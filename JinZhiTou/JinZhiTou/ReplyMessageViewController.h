//
//  ViewController.h
//  AGTableViewCell
//
//  Created by Agenric on 15/9/22.
//  Copyright (c) 2015年 Agenric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGTableViewCell.h"
#import "RootViewController.h"
#import "UITableViewCustomView.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@interface ReplyMessageViewController : RootViewController
@property(retain,nonatomic)NSMutableArray* dataArray;
@property (retain, nonatomic) UITableViewCustomView *tableView;


@end

