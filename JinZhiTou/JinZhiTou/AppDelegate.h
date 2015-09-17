//
//  AppDelegate.h
//  JinZhiTou
//
//  Created by air on 15/7/1.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "Reachability.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UIAlertViewDelegate>
{
    Reachability  *hostReach;
   
}

@property (strong, nonatomic) UIWindow *window;
@property (retain,nonatomic) UINavigationController *iNav;
@property(retain,nonatomic)MMDrawerController * drawerController;


@end

