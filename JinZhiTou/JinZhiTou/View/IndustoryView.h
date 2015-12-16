//
//  IndustoryView.h
//  JinZhiTou
//
//  Created by air on 15/9/9.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndustoryTableViewCell.h"
@interface IndustoryView : UIView<UITableViewDataSource,UITableViewDelegate,IndustorySelectedDelegate>
{
    NSMutableArray* selectArray;
}
@property(retain,nonatomic)UITableView* tableView;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)id controller;
@end
