//
//  RootViewController.h
//  JinZhiTou
//
//  Created by air on 15/11/3.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDUtil.h"
#import "NavView.h"
#import "MobClick.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "LoadingView.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#include "JDStatusBarNotification.h"
@interface RootViewController : UIViewController<LoadingViewDelegate>
@property(assign,nonatomic)int code;
@property(assign,nonatomic)CGRect loadingViewFrame;
@property(assign,nonatomic)BOOL startLoading;
@property(retain,nonatomic)NavView* navView;
@property(assign,nonatomic)BOOL isTransparent;
@property(retain,nonatomic)NSString* content;
@property(retain,nonatomic)HttpUtils* httpUtil;
@property(assign,nonatomic)BOOL isNetRequestError;
@property(retain,nonatomic)NSMutableDictionary* dataDic;

- (void) refresh;
- (void) resetLoadingView;
@end
