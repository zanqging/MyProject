//
//  BannerViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface BannerViewController : RootViewController
@property(retain,nonatomic)NSDictionary* dic;
@property(retain,nonatomic)UIWebView* webView;
@property(retain,nonatomic)NSString* titleStr;
@property(retain,nonatomic)NSURL* url;
@property(assign,nonatomic)int type;
@end
