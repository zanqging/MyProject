//
//  ShareView.h
//  JinZhiTou
//
//  Created by air on 15/8/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
@interface ShareView : UIView<QQApiInterfaceDelegate,TencentSessionDelegate>
{
    UIView* view;
}
@property(assign,nonatomic)int type;
@property(assign,nonatomic)NSInteger projectId;
@property(retain,nonatomic)NSMutableDictionary* dic;
@end
