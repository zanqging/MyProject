//
//  AppDelegate.m
//  JinZhiTou
//
//  Created by air on 15/7/1.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "AppDelegate.h"
#import "TDUtil.h"
#import "MobClick.h"
#import "AlertView.h"
#import "APService.h"
#import "HttpUtils.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "MasterViewController.h"
#import "BannerViewController.h"
#import "UserInfoViewController.h"
#import "FinialAuthViewController.h"
#import "StartPageViewController.h"
#import "RoadShowDetailViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "ActionDetailViewController.h"
#import "UserTraceViewController.h"

@interface AppDelegate ()<UIAlertViewDelegate>
{
    HttpUtils* httpUtils;
    UIWindow *m_brightnessWindow;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //获取缓存数据
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
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
            [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
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
            
            //////自定义抽屉手势   结束///////////
            self.iNav = [[UINavigationController alloc]initWithRootViewController:self.drawerController];
        }else{
            
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //将导航条添加到视图
    [self.window addSubview:self.iNav.view];
    
    //设置整个视图背景颜色
    [self.window setBackgroundColor:ColorTheme];
    [self.window makeKeyAndVisible];
    
    //向微信注册
    [WXApi registerApp:@"wx33aa0167f6a81dac" withDescription:@"jinzht"];
    
    //友盟统计
    [MobClick startWithAppkey:@"55c7684de0f55a0d0d0042a8" reportPolicy:BATCH   channelId:nil];
    
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
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(login) name:@"login" object:nil];
    
    [self performSelectorOnMainThread:@selector(installBrightnessWindow) withObject:nil waitUntilDone:NO];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            NSDictionary *dic = @{@"code":code};
            [[NSNotificationCenter defaultCenter]postNotificationName:@"WeChatBind" object:nil userInfo:dic];
        }
    }
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
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
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
    return [TencentOAuth HandleOpenURL:url] ||
    [WXApi handleOpenURL:url delegate:self] ;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@",url.host);
    if ([sourceApplication isEqualToString:@"com.apple.mobilesafari"] || [sourceApplication isEqualToString:@"com.apple.MobileSMS"]) {
        if ([url.host containsString:@"project"] || [url.host containsString:@"projectId"] || [url.host containsString:@"projectDetail"]) {
            NSArray *array = [[NSString stringWithFormat:@"%@",url] componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
            id obj = array[array.count-2];
            if ((NSInteger)obj) {
                NSInteger index = [obj integerValue];
                [self loadProjectDetail:index];
            }
        }else{
            NSString * urlStr = [[NSString stringWithFormat:@"%@",url] stringByReplacingOccurrencesOfString:@"jinzht://" withString:@""];
            [self loadWebViewDetail:[NSURL URLWithString:urlStr]];
        }
        return true;
    }else{
        return [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self];
    }
}



- (void)reachabilityChanged:(NSNotification *)note {
//    Reachability* curReach = [note object];
//    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
//    NetworkStatus status = [curReach currentReachabilityStatus];
//    
//    if (status == NotReachable) {
//NSString* title = @"金指投温馨提示";
//NSString* content = @"当前网络状况不佳，请检测网络连接!";
//#ifdef IOS8_SDK_AVAILABLE
//        UIAlertController* controller =[UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//        [controller addAction:actionSure];
//        [self.iNav presentViewController:controller animated:YES completion:nil];
//#else
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:content
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//#endif
//
//    }
    
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
    NSInteger number = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (number>0) {
        number --;
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber =number;
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    
    //更新状态
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateStatus" object:nil];
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
                [self loadProjectDetail:[[dic valueForKey:@"_id"] integerValue]];
                break;
            case 1:
                [self loadMsgDetail:[[dic valueForKey:@"_id"] integerValue]];
                break;
            case 2:
                [self loadSystemMsgDetail:[[dic valueForKey:@"_id"] integerValue]];
                break;
            case 3:
                [self loadWebViewDetail:[NSURL URLWithString:[dic valueForKey:@"url"]]];
                break;
            case 4:
                [self loadWebViewDetail:[NSURL URLWithString:[dic valueForKey:@"url"]]];
                break;
            case 5:
                [self loadWebViewDetail:[NSURL URLWithString:[dic valueForKey:@"url"]]];
                break;
            case 6:
                [self loadTraceInfo:1000];
                break;
            case 7:
                [self loadTraceInfo:1001];
                break;
            case 8:
                [self loadTraceInfo:1002];
                break;
            case 9:
                [self loadReplyInfo:[dic valueForKey:@"id"]];
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
    controller.type=1;
    controller.dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",index],@"id", nil];
    controller.title = @"首页";
    [self.iNav pushViewController:controller animated:YES];
}

-(void)loadMsgDetail:(NSInteger)index
{
    UIStoryboard* storyBorard =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MasterViewController* controller =(MasterViewController*)[storyBorard instantiateViewControllerWithIdentifier:@"SystemMessage"];
    controller.type=0;
    controller.titleStr = @"消息回复";
    [self.iNav pushViewController:controller animated:YES];
}

-(void)loadSystemMsgDetail:(NSInteger)index
{
    UIStoryboard* storyBorard =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MasterViewController* controller =(MasterViewController*)[storyBorard instantiateViewControllerWithIdentifier:@"SystemMessage"];
    controller.type=1;
    controller.titleStr = @"系统通知";
    [self.iNav pushViewController:controller animated:YES];
}

-(void)loadTraceInfo:(NSInteger)index
{
    UserTraceViewController* controller =[[UserTraceViewController alloc]init];
    controller.currentSelected =index;
    controller.titleStr = @"首页";
    [self.iNav pushViewController:controller animated:YES];
}

-(void)loadReplyInfo:(NSString*)postId
{
    ActionDetailViewController* controller =[[ActionDetailViewController alloc]init];
    controller.projectId = postId;
    [self.iNav pushViewController:controller animated:YES];
}


-(void)loadWebViewDetail:(NSURL*)url
{
    BannerViewController* controller = [[BannerViewController alloc]init];
   // NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",index] forKey:@"id"];
    controller.titleStr = @"消息推送";
    controller.title = @"首页";
    controller.type = 3;
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


-(void)login
{
    //重新登录
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    NSString* phone = [data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    NSString* password = [data valueForKey:STATIC_USER_PASSWORD];
    NSDictionary* dic =[[NSMutableDictionary alloc]init];
    
    NSString* regId = [APService registrationID];
    //加密
    [dic setValue:phone forKey:@"tel"];
    [dic setValue:regId forKey:@"regid"];
    [dic setValue:password forKey:@"passwd"];
    
    if ([TDUtil isValidString:phone] && [TDUtil isValidString:password]) {
        if (!httpUtils) {
            httpUtils  = [[HttpUtils alloc]init];
        }
        [httpUtils getDataFromAPIWithOps:USER_LOGIN postParam:dic type:0 delegate:self sel:@selector(requestLogin:)];
    }else{
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
        
        int num = 0;
        for(UIViewController* c in self.iNav.childViewControllers){
            if ([c isKindOfClass:controller.class]) {
                num ++;
            }
        }
        
        if (num==0) {
            [self.iNav pushViewController:controller animated:YES];
        }
        
        for(UIViewController* c in self.iNav.childViewControllers){
            if (![c isKindOfClass:controller.class]) {
                [c removeFromParentViewController];
            }
        }
    }
}

-(void)requestLogin:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSLog(@"登录成功!");
            //通知各个板块重新加载数据
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadData" object:nil];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.iNav.view textOnly:[jsonDic valueForKey:@"msg"]];
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
            
            
            int num = 0;
            for(UIViewController* c in self.iNav.childViewControllers){
                if ([c isKindOfClass:controller.class]) {
                    num ++;
                }
            }
            
            if (num==0) {
                [self.iNav pushViewController:controller animated:YES];
            }
            
            for(UIViewController* c in self.iNav.childViewControllers){
                if (![c isKindOfClass:controller.class]) {
                    [c removeFromParentViewController];
                }
            }
        }
    }
}

//========================扩展功能========================================//
- (void)sliderValueChanged:(NSNotification *)notification
{
    NSDictionary * userInfo = notification.userInfo;
    float value = [DICVFK(userInfo, @"value") floatValue];
    [UIView animateWithDuration:2 animations:^{
        m_brightnessWindow.alpha = 1.0 - value;
    }];
}

- (void)installBrightnessWindow
{
    m_brightnessWindow = [[UIWindow alloc] initWithFrame:self.window.frame];
    m_brightnessWindow.windowLevel = UIWindowLevelStatusBar + 1;
    m_brightnessWindow.userInteractionEnabled = NO;
    m_brightnessWindow.backgroundColor = [UIColor blackColor];
    m_brightnessWindow.alpha = 0;
    m_brightnessWindow.hidden = NO;
}
//========================扩展功能========================================//
@end
