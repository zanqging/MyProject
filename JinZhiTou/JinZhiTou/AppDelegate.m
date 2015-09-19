//
//  AppDelegate.m
//  JinZhiTou
//
//  Created by air on 15/7/1.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "AppDelegate.h"
#import "TDUtil.h"
#import "AlertView.h"
#import "APService.h"
#import "HttpUtils.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "BannerViewController.h"
#import "UserInfoViewController.h"
#import "FinialAuthViewController.h"
#import "StartPageViewController.h"
#import "RoadShowDetailViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "MessageController.h"

@interface AppDelegate ()<UIAlertViewDelegate>
{
    HttpUtils* httpUtils;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
   //NSString* isfirstLunch= [data valueForKey:@"isFirstLunch"];
    NSString* isStart= [data valueForKey:@"isStart"];
   NSString* isLogin= [data valueForKey:@"isLogin"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (isStart && [isStart isEqualToString:@"true"]) {
        if (isLogin && [isLogin isEqualToString:@"YES"]) {
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"HomeTabController"];
            
            UserInfoViewController* userInfoController = [[UserInfoViewController alloc]init];
            self.drawerController = [[MMDrawerController alloc]
                                     initWithCenterViewController:controller
                                     leftDrawerViewController:userInfoController
                                     rightDrawerViewController:nil];
            
            [self.drawerController setShowsShadow:NO];
            [self.drawerController setRestorationIdentifier:@"MMDrawer"];
            [self.drawerController setMaximumLeftDrawerWidth:280.0];
            [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            [self.drawerController
             setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
                 MMDrawerControllerDrawerVisualStateBlock block;
                 block = [[MMExampleDrawerVisualStateManager sharedManager]
                          drawerVisualStateBlockForDrawerSide:drawerSide];
                 if(block){
                     block(drawerController, drawerSide, percentVisible);
                 }
                 
             }];
            self.iNav = [[UINavigationController alloc]initWithRootViewController:self.drawerController];
        }else{
            
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"LoginController"];
            self.iNav = [[UINavigationController alloc]initWithRootViewController:controller];
        }
    }else{
        StartPageViewController* controller=[[StartPageViewController alloc]init];
        self.iNav = [[UINavigationController alloc]initWithRootViewController:controller];
       
    }
    
    //隐藏导航栏
    [self.iNav.navigationBar setHidden:YES];
    self.window.rootViewController=self.iNav;
    
    //导航条样式
    //向下兼容 ios7以上导航条可以跟nav背景色一致
    UINavigationBar *navBar = self.iNav.navigationBar;
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [[UINavigationBar appearance] setBackgroundImage:[TDUtil createImageWithColor:[UIColor clearColor] rect:CGRectMake(0, 0, 320, 64)] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[TDUtil createImageWithColor:[UIColor clearColor] rect:CGRectMake(0, 0, 320, 64)]];
    }
    //设置标题属性，字体为白色
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    nil]];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    //启动页隐藏状态栏
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //将导航条添加到视图
    [self.window addSubview:self.iNav.view];
    //设置整个视图背景颜色
    self.window.backgroundColor = ColorTheme;
    [self.window makeKeyAndVisible];
    
    //向微信注册
    [WXApi registerApp:@"wx33aa0167f6a81dac" withDescription:@"jinzht"];
    //向QQ注册
    
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    //测试连接服务器
    hostReach = [Reachability reachabilityWithHostName:@"www.jinzht.com"];
    //开始监听
    [hostReach startNotifier];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
    //注册通知推送
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound |
                                             UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                             UIRemoteNotificationTypeSound |
                                             UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [APService setupWithOption:launchOptions];

    
    return YES;
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"金指投温馨提示"];
        if(resp.errCode==-2){
            strMsg=@"分享已取消";
        }else if(resp.errCode==0){
            strMsg=@"分享成功";
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"%@",url.host);
    //return [WXApi handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@",url.host);
    //return [WXApi handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];
}



- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"金指投温馨提示"
                                                        message:@"当前网络状况不佳，请检测网络连接!"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark Push Delegate
- (void)onMethod:(NSString*)method response:(NSDictionary*)data
{
    NSLog(@"%@",data);
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
    
    NSLog(@"%@",userInfo);
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"%@",userInfo);
    UIApplicationState state=[UIApplication sharedApplication].applicationState;
    if (state!=UIApplicationStateInactive) {
        NSString* alert = [[userInfo valueForKey:@"aps"]valueForKey:@"alert"];
        AlertView* alertView = [[AlertView alloc]initWithTitle:@"金指投温馨提示" message:alert delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        alertView.dic  =userInfo;
        alertView.tag = 20001;
        [alertView show];
        
    }else{
        [self notification:userInfo];
    }
    
    
    [APService setBadge:0];
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

-(void)notification:(NSDictionary*)dic
{
    NSString* type = [dic valueForKey:@"api"];
    
    int index=-1;
    NSString* str;
    for (int i=0; i<ROMATE_MSG_TYPE.count; i++) {
        str=[ROMATE_MSG_TYPE valueForKey:[NSString stringWithFormat:@"%d",i]];
        if ([str isEqualToString:type]) {
            index = i;
        }
    }
    if (index!=-1) {
        switch (index) {
            case 0:
                [self loadProjectDetail:[[dic valueForKey:@"pid"] integerValue]];
                break;
            case 1:
                [self loadMsgDetail:[[dic valueForKey:@"pid"] integerValue]];
                break;
            case 2:
                [self loadSystemMsgDetail:[[dic valueForKey:@"pid"] integerValue]];
                break;
            case 3:
                [self loadWebViewDetail:[NSURL URLWithString:[dic valueForKey:@"url"]]];
                break;
            default:
                break;
        }
    }

}

////为了MPMoviePlayerViewController保持横平
//- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
//{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}



-(void)loadProjectDetail:(NSInteger)index
{
    RoadShowDetailViewController* controller = [[RoadShowDetailViewController alloc]init];
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld",(long)index] forKey:@"id"];
    controller.type=1;
    controller.dic = dic;
    controller.title = @"消息推送";
    [self.iNav pushViewController:controller animated:YES];
}

-(void)loadMsgDetail:(NSInteger)index
{
    UIStoryboard* storyBorard =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MessageController* controller =(MessageController*)[storyBorard instantiateViewControllerWithIdentifier:@"ResplyMessage"];
    [self.iNav pushViewController:controller animated:YES];
}

-(void)loadSystemMsgDetail:(NSInteger)index
{
    UIStoryboard* storyBorard =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MessageController* controller =(MessageController*)[storyBorard instantiateViewControllerWithIdentifier:@"ResplyMessage"];
    [self.iNav pushViewController:controller animated:YES];
}

-(void)loadWebViewDetail:(NSURL*)url
{
    BannerViewController* controller = [[BannerViewController alloc]init];
   // NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",index] forKey:@"id"];
    controller.title = @"消息推送";
    controller.url = url;
    [self.iNav pushViewController:controller animated:YES];
}

-(void)alertView:(AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (tag  == 20001 && buttonIndex==1) {
        NSDictionary* dic =alertView.dic;
        [self notification:dic];
    }
}
@end
