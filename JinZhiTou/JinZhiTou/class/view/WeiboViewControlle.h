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
#import "WeiboData.h"
#import "UConstants.h"
#import "LoadingView.h"
#import "LoadingUtil.h"
#import "HBCoreLabel.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "PageLoadFootView.h"
#import "ASIFormDataRequest.h"
#import "UITableViewCustomView.h"
#define WeiboUpdateNotification  @"WeiboUpdateNotification"
@interface WeiboViewControlle : UIViewController<UIActionSheetDelegate,HBCoreLabelDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL  animationEnd;
    
    void(^_block)(NSString*string);
    LoadingView* loadingView;
    WeiboData * _deleteWeibo;
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
@property(nonatomic,strong)WeiboData * weiboData;
@property(nonatomic,strong)WeiboData * deleteWeibo;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(nonatomic,strong)WeiboReplyData * replyData;
@property (retain, nonatomic) UIButton *btnReplay;
@property(nonatomic,retain) UITableViewCustomView * tableView;

@end
