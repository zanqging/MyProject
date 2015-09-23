//
//  WeiboViewControlle.h
//  wq
//
//  Created by weqia on 13-8-28.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "LoadingView.h"
#import "LoadingUtil.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "UITableViewCustomView.h"
#define WeiboUpdateNotification  @"WeiboUpdateNotification"
@interface WeiboViewControlle : UIViewController<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL  animationEnd;
    
    void(^_block)(NSString*string);
    LoadingView* loadingView;
    HttpUtils* httpUtils;
    NSMutableArray * _artArr;
    NSIndexPath *_deletePath;
    NSMutableDictionary * _artDic;
}
@property(nonatomic,strong)NSArray*datas;
@property(retain,nonatomic)NavView* navView;
@property(nonatomic,strong) UIView * superView;
@property(assign,nonatomic)NSInteger project_id;
@property(assign,nonatomic)BOOL isEndOfPageSize;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property (retain, nonatomic) UIButton *btnReplay;
@property(nonatomic,retain) UITableViewCustomView * tableView;

@end
