//
//  UITableViewCustomViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/14.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCustomView : UITableView
@property(assign,nonatomic)BOOL isNone;
@property(assign,nonatomic)NSString* emptyImgFileName;
@property(retain,nonatomic)NSString* content;
@end
