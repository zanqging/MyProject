//
//  HomeTabBarViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "HomeTabBarViewController.h"
#import "TDUtil.h"
#import "MenuView.h"
#import "DataModel.h"
#import "APService.h"
#import "ShareView.h"
#import "HttpUtils.h"
#import "SphereMenu.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "LoadingView.h"
#import "LoadingUtil.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import <MessageUI/MessageUI.h>
#import "PECropViewController.h"
#import "AboutUsViewController.h"
#import "UserInfoAuthController.h"
#import "FinialAuthViewController.h"
#import "UserFinialViewController.h"
#import "UserTraceViewController.h"
#import "UserInfoSettingViewController.h"
@interface HomeTabBarViewController ()<SphereMenuDelegate,MFMessageComposeViewControllerDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>
{
    BOOL isShow;
    HttpUtils* httpUtils;
    SphereMenu *sphereMenu;
    DialogView* dialogView;
    UIImageView* menuBackView;
    LoadingView* loadingView;
}
@end
@implementation HomeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* view =[[UIView alloc]initWithFrame:self.tabBar.frame];
    view.backgroundColor =WriteColor;
    [self.tabBar insertSubview:view atIndex:0];
    self.tabBar.opaque = YES;
    
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    NSString* auth = [data valueForKey:@"auth"];
    //添加TabBar中间＋号视图
    NSMutableArray* dataArray=[[NSMutableArray alloc]init];
    DataModel* model=[[DataModel alloc]init];
    if ([auth boolValue] || [auth isEqualToString:@"None"]) {
        [model setDesc1:@"认证信息"];
    }else{
        [model setDesc1:@"我要认证"];
    }
    [model setDesc2:@"woyaorenzheng"];
    [dataArray addObject:model];
    
    
    model=[[DataModel alloc]init];
    [model setDesc1:@"上传项目"];
    [model setDesc2:@"woyaoluyan"];
    [dataArray addObject:model];
    
    model=[[DataModel alloc]init];
    [model setDesc1:@"我要分享"];
    [model setDesc2:@"woyaofenxiang"];
    [dataArray addObject:model];
    
//    model=[[DataModel alloc]init];
//    [model setDesc1:@"我要签到"];
//    [model setDesc2:@"woyaoqiandao"];
//    [dataArray addObject:model];
    
    
    UIImage *startImage = [UIImage imageNamed:@"jiahao"];
    
    sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(WIDTH(self.view)/2, HEIGHT(self.view)-kBottomBarHeight/2)
                                                         startImage:startImage
                                                      data:dataArray];
    sphereMenu.delegate = self;
    sphereMenu.tag=10000;
    //添加到当前视图中
    [self.view addSubview:sphereMenu];

    //各项选择
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInfoAction:) name:@"userInfoAction" object:nil];
    
    //发送短信
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showMessageView:) name:@"showMessageView" object:nil];

    
    httpUtils = [[HttpUtils alloc]init];
    //检测用户是否已经登录
//    [self isUserHasLogin];

    //发送短信
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alert:) name:@"alert" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateStatus) name:@"updateStatus" object:nil];
    
    //初始化数据
    [self loadData];
}

-(void)loadData
{
    //检测更新
    [self checkUpdate];
    //用户信息
    [self userInfo];
    //更新信息
    [self updateStatus];
}

-(void)userInfo
{
    [httpUtils getDataFromAPIWithOps:USERINFO postParam:nil type:0 delegate:self sel:@selector(requestUserInfo:)];
}

-(void)updateStatus
{
    //新消息
    [self hasNewMessage];
    [self hasNewSystemMessage];
    
    NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
    NSString* updateTime =[dataStore valueForKey:@"NewFinialUpdateTime"];
    NSString* isUpdate =[dataStore valueForKey:@"IsNewFinialUpdate"];
    if (![updateTime isEqualToString:[TDUtil CurrentDay]]) {
        //新三板更新数据
        if (isUpdate) {
            [self NewFinialUpdateInfo];
        }
    }
    updateTime = [dataStore valueForKey:@"KnowledgeUpdateTime"];
    isUpdate =[dataStore valueForKey:@"IsKnowledgeUpdate"];
    //知识库更新数据
    if (![updateTime isEqualToString:[TDUtil CurrentDay]]) {
        //新三板更新数据
        if (isUpdate) {
            [self KnowledgeUpdateInfo];
        }
    }
    
}

-(void)updateTabBarStatus
{
    NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
    for (int i =0; i<self.tabBar.items.count; i++) {
        UITabBarItem*  item = self.tabBar.items[i];
        [item setTitlePositionAdjustment:UIOffsetMake(0, -5)];
        
        //处理第三个按钮
        if (i==2) {
            item.enabled = NO;
        }else if (i==3){
                NSString* newFinialCount = [[dataStore valueForKey:@"NewFinialCount"] stringValue];
                if ([newFinialCount integerValue]>0) {
                    [item setBadgeValue:newFinialCount];
                }
            
        }else if (i==4){
            NSString* newFinialCount = [[dataStore valueForKey:@"KnowledgeCount"] stringValue];
            if ([newFinialCount integerValue]>0) {
                [item setBadgeValue:newFinialCount];
            }
        }
    }
    
    
}
-(void)alert:(NSDictionary*)dic
{
    
    if (!dialogView) {
        dialogView =[TDUtil shareInstanceDialogView:self.view];
    }
    
    NSDictionary* dictionary =[dic  valueForKey:@"userInfo"];
    NSString* title = [dictionary valueForKey:@"msg"];
    if(title && ![title isEqual:@""]){
        dialogView.title = title;
    }else{
        dialogView.title = @"您没有查看权限，请先登录";
    }
    
    dialogView.type = [[dictionary valueForKey:@"type"] intValue];
    if (dialogView.type==4) {
        [dialogView hideCancelButton];
    }
    [dialogView.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [dialogView.shureButton addTarget:self action:@selector(shure:) forControlEvents:UIControlEventTouchUpInside];
    [dialogView.cancelButton setTitle:[dictionary valueForKey:@"cancel"] forState:UIControlStateNormal];
    [dialogView.shureButton setTitle:[dictionary valueForKey:@"sure"] forState:UIControlStateNormal];
    dialogView.tag =10001;
    
    if (!dialogView.status) {
        [([UIApplication sharedApplication]).windows[0] addSubview:dialogView];
        dialogView.status = YES;
    }
    
    
}

-(void)cancel:(id)sender
{
    dialogView.status = NO;
    [dialogView removeFromSuperview];
}

-(void)shure:(UIButton*)sender
{
    [self cancel:nil];
//    for (UIViewController* controller in self.navigationController.childViewControllers) {
//        [controller removeFromParentViewController];
//    }
    
    if (dialogView.type==3) {
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
        [self.navigationController pushViewController:controller animated:YES];
        
        for(UIViewController* c in self.navigationController.childViewControllers){
            if (![c isKindOfClass:controller.class]) {
                [c removeFromParentViewController];
            }
        }
    }else if(dialogView.type==4){
        [dialogView removeFromSuperview];
    }else{
//        FinialAuthViewController* controller = [[FinialAuthViewController alloc]init];
//        controller.type = 1;
//        controller.titleStr = @"项目详情";
//        [self.navigationController pushViewController:controller animated:YES];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showAuth" object:nil];
    }
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
}
- (void)sphereDidSelected:(int)index
{
    NSLog(@"sphere %d selected", index);
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    BOOL isAnimous = [[data valueForKey:@"isAnimous"] boolValue];
    if (isAnimous && index!=1003) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObject:@"title" forKey:@"msg"]];
    }else{
        switch (index) {
            case 1000:
                [self AuthApplyAction];
                break;
            case 1001:
                [self RoadShowAction];
                break;
            case 1002:
                [self ShareAction];
                break;
            case 1003:
                [self ActionArriveAction];
                break;
            default:
                [self AuthApplyAction];
                break;
        }
    }
}

-(void)ShareAction
{
    UIWindow* window =[UIApplication sharedApplication].windows[0];
    ShareView* shareView =[[ShareView alloc]initWithFrame:window.frame];
    shareView.type = 1;
    [window addSubview:shareView];
}

-(void)RoadShowAction
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"RoadShowApply"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)FinialApplyAction
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"FinialApply"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)AuthApplyAction
{
    if (!loadingView) {
        loadingView  =[LoadingUtil shareinstance:self.view];
        loadingView.isTransparent = YES;
    }
    [LoadingUtil show:loadingView];
    //开始获取认证信息
    [httpUtils getDataFromAPIWithOps:@"myauth/" postParam:nil type:0 delegate:self sel:@selector(requestIsAuth:)];
    
    
}
-(void)ActionArriveAction
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"ActionArrive"];
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)sphereIsDidSelected:(BOOL)selected
{
    if (selected) {
        if (!menuBackView) {
            menuBackView=[[UIImageView alloc]initWithFrame:CGRectMake(0, kTopBarHeight+kStatusBarHeight, WIDTH(self.view), HEIGHT(self.view)-kStatusBarHeight-kTopBarHeight-kBottomBarHeight)];
            menuBackView.backgroundColor=WriteColor;
            menuBackView.alpha=0.9;
        }
        [self.view addSubview:menuBackView];
        sphereMenu.selected=YES;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInteractionEnabled" object:nil userInfo:[NSDictionary dictionaryWithObject:@"NO" forKey:@"userInteractionEnabled"]];
        
    }else{
        if (menuBackView) {
            [menuBackView removeFromSuperview];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"userInteractionEnabled" object:nil userInfo:[NSDictionary dictionaryWithObject:@"Yes" forKey:@"userInteractionEnabled"]];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        
    }
}

-(void)userInfoAction:(NSDictionary*)dic
{
    NSInteger index = [[[dic valueForKey:@"userInfo"] valueForKey:@"index"] integerValue];
    
    UIStoryboard* storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NSString* name;
    switch (index) {
        case 1:
            name = @"aboutMe";
            break;
        case 2:
            name = @"MyCollecte";
            break;
        case 3:
            name = @"Myfinial";
            break;
        case 4:
            name = @"AuthConfig";
            break;
        case 5:
            name = @"aboutUs";
            break;
        default:
            break;
    }
    UIViewController* controller;
    if(index ==1){
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        controller = [storyBoard instantiateViewControllerWithIdentifier:@"SystemMessage"];
        
    }else if (index ==5){
        controller = [[AboutUsViewController alloc]init];
    }else{
        controller= [storyBoard instantiateViewControllerWithIdentifier:name];
    }
    
    if (controller) {
        if (index == 3) {
            UserFinialViewController* finialController = (UserFinialViewController*)controller;
            finialController.navTitle = @"个人中心";
            [self.navigationController pushViewController:finialController animated:YES];
        }else{
            [self.navigationController pushViewController:controller animated:YES];
        }
       
    }
}

-(void)checkUpdate
{
    NSString* url =[checkversion stringByAppendingString:@"1/"];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestCheckUpdate:)];
}
/**
 *  检测用户是否已经登录服务器端
 */
-(void)isUserHasLogin
{
    [httpUtils getDataFromAPIWithOps:ISLOGIN postParam:nil type:1 delegate:self sel:@selector(requestIsLogin:)];
}
/**
 *  发送短信消息
 */
- (void)showMessageView:(NSDictionary*)dic
{
    NSDictionary* data = [dic valueForKey:@"userInfo"];
    
    if( [MFMessageComposeViewController canSendText] ){
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
        controller.recipients = [NSArray arrayWithObject:@""];
        
        int type = [[data valueForKey:@"type"] intValue];
        NSString* body,* title;
        if (type!=0) {
            if (type==1) {
                body = [NSString stringWithFormat: @"【%@】,项目类型:%@",[data valueForKey:@"company"],[data valueForKey:@"tag"]];
                title = [data valueForKey:@"title"];
            }else{
                body = [NSString stringWithFormat: @"【%@】,链接地址:%@",[data valueForKey:@"title"],[data valueForKey:@"url"]];
                title = [data valueForKey:@"title"];
                
            }
        }else{
            body = [NSString stringWithFormat: @"【%@下载链接:%@】",@"推荐金指投App，分享有好礼，快速投融资！",@"http://a.app.qq.com/o/simple.jsp?pkgname=com.jinzht.pro"];
            title  =@"金指投App分享";
        }
        
        //组装数据
        controller.body = body;
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:[data valueForKey:title]];//修改短信界面标题
        
        controller.messageComposeDelegate = self;
        
        [self.navigationController presentViewController:controller animated:YES completion:^(void){
            
        }];
        
    }else{
        
        [DialogUtil showDlgAlert:@"设备不支持发送短信"];
    }
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch ( result ) {
            
        case MessageComposeResultCancelled:
            
            [DialogUtil showDlgAlert:@"短信发送取消!"];
            break;
        case MessageComposeResultFailed:
            [DialogUtil showDlgAlert:@"短信发送失败!"];
            break;
        case MessageComposeResultSent:
            [DialogUtil showDlgAlert:@"短信发送成功!"];
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:^(void){
        
    }];
}

-(void)hasNewMessage
{
    [httpUtils getDataFromAPIWithOps:hasnewtopic type:0 delegate:self sel:@selector(requestNewMessage:) method:@"GET"];
}

-(void)hasNewSystemMessage
{
    [httpUtils getDataFromAPIWithOps:hasnewmsg  type:0 delegate:self sel:@selector(requestSystemMessage:) method:@"GET"];
}

-(void)NewFinialUpdateInfo
{
    [httpUtils getDataFromAPIWithOps:latestnewscount postParam:nil type:0 delegate:self sel:@selector(requestNewFinialUpdateInfo:)];
}

-(void)KnowledgeUpdateInfo
{
    [httpUtils getDataFromAPIWithOps:latestknowledgecount postParam:nil type:0 delegate:self sel:@selector(requestKnowledgeUpdateInfo:)];
}


#pragma ASIHttpRequester
//===========================================================网络请求=====================================
-(void)requestNewMessage:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
            NSDictionary* data = [jsonDic valueForKey:@"data"];
            [dataStore setValue:[data valueForKey:@"count"] forKey:@"NewMessageCount"];
            [dataStore setValue:[TDUtil CurrentDay] forKey:@"NewUpdateTime"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMessageStatus" object:nil];
        }
    }
}

-(void)requestSystemMessage:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
            NSDictionary* data = [jsonDic valueForKey:@"data"];
            [dataStore setValue:[data valueForKey:@"count"] forKey:@"SystemMessageCount"];
            [dataStore setValue:[TDUtil CurrentDay] forKey:@"NewUpdateTime"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateMessageStatus" object:nil];
        }
    }
}

-(void)requestNewFinialUpdateInfo:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
            NSDictionary* data = [jsonDic valueForKey:@"data"];
            [dataStore setValue:[data valueForKey:@"count"] forKey:@"NewFinialCount"];
            [dataStore setValue:@"false" forKey:@"IsNewFinialUpdate"];
            [self updateTabBarStatus];
        }
    }
}

-(void)requestKnowledgeUpdateInfo:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
            NSDictionary* data = [jsonDic valueForKey:@"data"];
            [dataStore setValue:[data valueForKey:@"count"] forKey:@"KnowledgeCount"];
            [dataStore setValue:@"false" forKey:@"IsKnowledgeUpdate"];
            
            [self updateTabBarStatus];
        }
    }
}

-(void)requestUploadTokean:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            
        }
    }
}

/**
 *  上传照片
 *
 *  @param request 返回上传结果
 */
-(void)requestUploadHeaderImg:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
}

/**
 *  检测用户是否已经登录网络请求对象
 *
 *  @param request 服务器返回用户登录状况
 */
-(void)requestIsLogin:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == -1) {
            //重新登录
            NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
            NSString* phone = [data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            NSString* password = [data valueForKey:STATIC_USER_PASSWORD];
            NSDictionary* dic =[[NSMutableDictionary alloc]init];
            
            //加密
            NSLog(@"password:%@",password);
            //极光推送id
            NSString* regId = [APService registrationID];
            if (![TDUtil isValidString:regId]) {
                regId = @"123";
            }
            [dic setValue:regId forKey:@"regid"];
            [dic setValue:phone forKey:@"tel"];
            [dic setValue:password forKey:@"passwd"];
            
            if ([TDUtil isValidString:phone] && [TDUtil isValidString:password]) {
                [httpUtils getDataFromAPIWithOps:USER_LOGIN postParam:dic type:1 delegate:self sel:@selector(requestLogin:)];
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
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            NSLog(@"登录成功!");
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"LoginController"];
            [self.navigationController pushViewController:controller animated:YES];
            
            for(UIViewController* c in self.navigationController.childViewControllers){
                if (![c isKindOfClass:controller.class]) {
                    [c removeFromParentViewController];
                }
            }
        }
    }
}



-(void)requestCheckUpdate:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSString* version =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
            NSDictionary* data =[jsonDic valueForKey:@"data"];
            if (data) {
                BOOL force = [data valueForKey:@"force"];
                if (force) {
                    if ([[data valueForKey:@"edition"] compare:version]==NSOrderedDescending) {
                        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"金指投%@更新",[data valueForKey:@"edition"]] message:[data valueForKey:@"item"] delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil, nil];
                        alertView.delegate = self;
                        [alertView show];
                        
                    }
                }
            }
        }
    }
}

-(void)requestUserInfo:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSDictionary* dic =[jsonDic valueForKey:@"data"];
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:[self formatDic:dic key:@"tel"] forKey:USER_STATIC_TEL];
            [data setValue:[self formatDic:dic key:@"name"] forKey:USER_STATIC_NAME];
            [data setValue:[self formatDic:dic key:@"idpic"] forKey:USER_STATIC_IDPIC];
            [data setValue:[self formatDic:dic key:@"uid"] forKey:USER_STATIC_USER_ID];
            [data setValue:[self formatDic:dic key:@"addr"] forKey:USER_STATIC_ADDRESS];
            [data setValue:[self formatDic:dic key:@"gender"] forKey:USER_STATIC_GENDER];
            [data setValue:[self formatDic:dic key:@"idno"] forKey:USER_STATIC_IDNUMBER];
            [data setValue:[self formatDic:dic key:@"position"] forKey:USER_STATIC_POSITION];
            [data setValue:[self formatDic:dic key:@"company"] forKey:USER_STATIC_COMPANY_NAME];
            [data setValue:[self formatDic:dic key:@"nickname"] forKey:USER_STATIC_NICKNAME];
            //移除重新加载数据监听
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
        }else if ([code intValue]==-1){
            //添加刷新监听
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"reloadData" object:nil];
            //通知观察中心重新登录
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
        }
    }
}

-(void)requestIsAuth:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if(jsonDic!=nil)
    {
        int code = [[jsonDic valueForKey:@"code"] intValue];
        if (code==0) {
            UserInfoAuthController* controller = [[UserInfoAuthController alloc]init];
            
            NSDictionary* data = [jsonDic valueForKey:@"data"];
            NSString* auth = (NSString*)[data valueForKey:@"auth"];
            
            if ([auth isKindOfClass:NSNull.class]) {
                 controller.type=1;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                if ([auth isKindOfClass:NSString.class]) {
                    if ([auth isEqualToString:@""]) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"showAuth" object:nil];
                    }
                }else{
                    if ([auth boolValue]) {
                        controller.type=0;
                    }else if(![auth boolValue]){
                        controller.type=2;
                    }else{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"showAuth" object:nil];
                    }
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
            //关闭加载视图
            [LoadingUtil close:loadingView];
            //移除监听
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
        }else if (code==-1){
            //添加重新登录
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
            //移除监听
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
            //添加监听
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AuthApplyAction) name:@"reloadData" object:nil];
        }
    }
}

-(NSString*)formatDic:(NSDictionary*)dic key:(NSString*)key
{
    NSString* str = [dic valueForKey:key];
    if (![str isKindOfClass:NSNull.class]) {
        return str;
    }
    return nil;
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"alert" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ITUNES_URL]];
}

-(void)viewWillAppear:(BOOL)animated
{
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
@end
