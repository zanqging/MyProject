//
//  AutoShowView.h
//  WeiNI
//
//  Created by air on 15/3/4.
//  Copyright (c) 2015年 weini. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AutoShowView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(strong,nonatomic)NSMutableArray* dataArray;  //数据;
@property(strong,nonatomic)UITableView* tableView;  //表格视图
@property(retain,nonatomic)NSString* type;  //表格视图
@property(assign,nonatomic)BOOL isHidden;
@property(retain,nonatomic)NSString* title;
-(void)viewShowAnimation;  //加载动画
@end
