//
//  UserInfo.h
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfo : UIView<UITableViewDataSource,UITableViewDelegate>
@property(assign,nonatomic)BOOL isAmious;
@property(retain,nonatomic)NSArray* dataArray;
@property(retain,nonatomic)UITableView* tableView;
@end
