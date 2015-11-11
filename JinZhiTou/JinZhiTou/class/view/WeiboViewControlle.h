//
//  WeiboViewControlle.h
//  wq
//
//  Created by weqia on 13-8-28.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "UITableViewCustomView.h"
#define WeiboUpdateNotification  @"WeiboUpdateNotification"
@interface WeiboViewControlle : RootViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL  animationEnd;
    
    void(^_block)(NSString*string);
    NSMutableArray * _artArr;
    NSIndexPath *_deletePath;
    NSMutableDictionary * _artDic;
}
@property(nonatomic,strong)NSArray*datas;
@property(retain,nonatomic)NSString* titleStr;
@property(nonatomic,strong)UIView * superView;
@property(assign,nonatomic)NSInteger project_id;
@property(assign,nonatomic)BOOL isEndOfPageSize;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property (retain, nonatomic) UIButton *btnReplay;
@property(nonatomic,retain) UITableViewCustomView * tableView;

-(void)loadData;

@end
