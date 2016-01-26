//
//  loginViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "loginViewController.h"
#import "APService.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "MMDrawerController.h"
#import "WeChatBindController.h"
#import "RegisteViewController.h"
#import "UserInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ForgetPassViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
@interface loginViewController ()<UITextFieldDelegate,WXApiDelegate>
{
    UIActivityIndicatorView* activity;
    UIScrollView* scrollView;
    
    UILabel* label;
    NSString* openId;
    NSString* password;
}
@property(retain,nonatomic)MMDrawerController* drawerController;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏导航栏
    
    //设置背景色
    self.view.backgroundColor=ColorTheme;
    
    //==============================导航栏区域开始==============================//
    [self.navView removeFromSuperview];
    

    UIImageView* imgView = [[UIImageView alloc]initWithFrame:FRAME(self.view)];
    imgView.image = IMAGE(@"login", @"png");
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    //登录背景添加至滚动视图
    [self.view addSubview:imgView];
    
    CGRect frame = self.view.frame;
    //==============================滚动时图区域开始==============================//
    scrollView = [[UIScrollView alloc]initWithFrame:frame];
    scrollView.backgroundColor = ClearColor;
    [scrollView setContentSize:CGSizeMake(WIDTH(self.view), HEIGHT(self.view)+220)];
    [self.view addSubview:scrollView];
    //==============================滚动时图区域开始==============================//
    
    //==============================滚动时图子视图添加开始==============================//
    
    //手机号码输入框
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(30,80, WIDTH(self.view)-60, 45)];
    
    //设置属性
    self.phoneTextField.tag=1004;
    self.phoneTextField.delegate=self;
    self.phoneTextField.font = SYSTEMFONT(16);
    self.phoneTextField.textColor =WriteColor;
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.returnKeyType = UIReturnKeyDone;
    self.phoneTextField.backgroundColor = RGBACOLOR(203, 203, 203, 0.4);
//    self.phoneTextField.layer.borderColor =RGBACOLOR(203, 203, 203, 0.3).CGColor;
    self.phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.phoneTextField.layer.cornerRadius = 2;
    self.phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    //设置输入框左侧图标
    [TDUtil setTextFieldLeftPadding:self.phoneTextField forImage:@"shuruphone"];
    
    //将输入框添加至滚动视图
    [scrollView addSubview:self.phoneTextField];
    
    //密码输入框
    self.passwordTextField =[[UITextField alloc]initWithFrame:CGRectMake(30, POS_Y(self.phoneTextField)+20, WIDTH(self.phoneTextField), 45)];
    
    //设置属性
    self.passwordTextField.delegate=self;
    self.passwordTextField.secureTextEntry=YES;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.font = SYSTEMFONT(16);
    self.passwordTextField.textColor = WriteColor;
    self.passwordTextField.placeholder =@"请输入登录密码";
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
//    self.passwordTextField.layer.borderColor =self.phoneTextField.backgroundColor.CGColor;
    self.passwordTextField.backgroundColor  =self.phoneTextField.backgroundColor;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.layer.cornerRadius = 2;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    //设置输入框左侧图标
    [TDUtil setTextFieldLeftPadding:self.passwordTextField forImage:@"shurumima"];
    
    //密码输入框添加至滚动视图
    [scrollView addSubview:self.passwordTextField];
    
    //登录按钮
    self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(self.passwordTextField)+30, WIDTH(scrollView) - 60, 40)];
    
    //设置登录按钮属性
    [self.loginButton.layer setBorderWidth:1];
    [self.loginButton setBackgroundColor:AppColorTheme];
    [self.loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [self.loginButton.layer setCornerRadius:2];
    [self.loginButton setTitleColor:WriteColor forState:UIControlStateNormal];
    [self.loginButton.layer setBorderColor:AppColorTheme.CGColor];
    [self.loginButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //将登录按钮添加至滚动视图
    [scrollView addSubview:self.loginButton];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(X(self.loginButton), POS_Y(self.loginButton)+15, WIDTH(self.view)/2, 40)];
    label.textColor = WriteColor;
    label.font = SYSTEMFONT(14);
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registeAction:)]];
    [scrollView addSubview:label];
    
    //设置UIButton特殊样式
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"还未注册？请点击注册"];
    [str addAttribute:NSForegroundColorAttributeName value:self.loginButton.backgroundColor range:NSMakeRange(5, 5)];
    label.attributedText = str;
    
    
    //忘记密码按钮
    UIButton* btnActionLeft = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self.loginButton)*2/3+X(self.loginButton)+18, POS_Y(self.loginButton)+15, WIDTH(self.loginButton)/3, 40)];
    
    //设置忘记密码按钮样式
    [btnActionLeft addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置UIButton特殊样式
    str = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSFontAttributeName value:SYSTEMFONT(14) range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    //赋富文本值
    [btnActionLeft setAttributedTitle:str forState:UIControlStateNormal];
    
    //将忘记密码按钮添加至滚动视图
    [scrollView addSubview:btnActionLeft];
    
    //==============================滚动时图子视图添加开始==============================//
    
    //==============================微信登录开始==============================//
    
    if ([WXApi isWXAppInstalled]) {
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, HEIGHT(self.view)-100, WIDTH(self.view)/2-50, 1)];
        imgView.backgroundColor  =[TDUtil colorWithHexString:@"b4bdc8"];;
        [scrollView addSubview:imgView];
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)-WIDTH(imgView)-10, Y(imgView), WIDTH(imgView), HEIGHT(imgView))];
        imgView.backgroundColor  =[TDUtil colorWithHexString:@"b4bdc8"];
        [scrollView addSubview:imgView];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2-20, Y(imgView)-50, 40, 40)];
        imgView.image =IMAGENAMED(@"WeChatLogo");
        imgView.layer.cornerRadius = 5;
        imgView.layer.masksToBounds=YES;
        imgView.userInteractionEnabled  =YES;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(WeChatAction:)]];
        [scrollView addSubview:imgView];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(X(imgView)-20, POS_Y(imgView), WIDTH(imgView)+40, 21)];
        label.textColor = WriteColor;
        label.text = @"微信登录";
        label.font  =SYSTEMFONT(14);
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
        
    }
    
    //监听
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT(self.view)-30, WIDTH(self.view), 21)];
    label.textColor = WriteColor;
    label.text = @"金指投";
    label.font  =SYSTEMFONT(14);
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    //==============================微信登录结束==============================//

    
    //加载本地默认数据
    [self loadDefaultData];
}

-(void)loadDefaultData
{
    NSUserDefaults * data = [NSUserDefaults standardUserDefaults];
    NSString * phoneNumber = [data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
    if (phoneNumber) {
        self.phoneTextField.text = phoneNumber;
    }
}
/**
 *  微信登录
 *
 *  @param sender
 */
-(void)WeChatAction:(id)sender
{
    [self sendAuthRequest];
}

-(void)sendAuthRequest
{
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo,snsapi_base";
    req.state = @"0744" ;
//    [WXApi sendReq:req];
//    [WXApi sendAuthReq:req viewController:self delegate:self];
    [WXApi sendReq:req];
}

-(void)getAccess_token:(NSDictionary*)dic
{
    self.startLoading = YES;
    self.isTransparent = YES;

    NSString* code =[[dic valueForKey:@"userInfo"] valueForKey:@"code"];
    NSString* url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx33aa0167f6a81dac&secret=bc5e2b89553589bf7d9e568545793842&code=%@&grant_type=authorization_code",code];
    
//    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWXAPP_ID,kWXAPP_SECRET,self.wxCode.text];
//    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                 "expires_in" = 7200;
                 openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                 "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                 scope = "snsapi_userinfo,snsapi_base";
                 }
                 */
                
//                self.access_token.text = [dic objectForKey:@"access_token"];
//                self.openid.text = [dic objectForKey:@"openid"];
                openId =[dic objectForKey:@"openid"];
                if (openId) {
                    [self getUserInfo:[dic objectForKey:@"access_token"] openId:openId];
                }
                
            }else{
                self.startLoading =NO;
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"信息获取失败!"];
            }
        });
    });
}


-(void)getUserInfo:(NSString*)tokean openId:(NSString*)openID
{
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",tokean,openId];
//
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
//                self.nickname.text = [dic objectForKey:@"nickname"];
//                self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
                NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
                [data setValue:[dic objectForKey:@"nickname"] forKey:USER_STATIC_NICKNAME];
                [data setValue:[dic objectForKey:@"headimgurl"] forKey:USER_STATIC_HEADER_PIC];
                if (openID) {
                    [self.httpUtil getDataFromAPIWithOps:@"openid/" postParam:[NSDictionary dictionaryWithObject:openID forKey:@"openid"] type:0 delegate:self sel:@selector(requestFinished:)];
                }
            }else{
                self.startLoading =NO;
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"信息获取失败!"];
            }
        });
        
    });
}


////授权后回调 WXApiDelegate
//-(void)onResp:(BaseReq *)resp
//{
//    /*
//     ErrCode ERR_OK = 0(用户同意)
//     ERR_AUTH_DENIED = -4（用户拒绝授权）
//     ERR_USER_CANCEL = -2（用户取消）
//     code    用户换取access_token的code，仅在ErrCode为0时有效
//     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
//     lang    微信客户端当前语言
//     country 微信用户当前国家信息
//     */
//    SendAuthResp *aresp = (SendAuthResp *)resp;
//    if (aresp.errCode== 0) {
//        NSString *code = aresp.code;
//        NSDictionary *dic = @{@"code":code};
//    }
//}


/**
 *  忘记密码
 *
 *  @param sender
 */
- (void)forgetAction:(id)sender
{
    if (self.phoneTextField.isFirstResponder) {
        [self.phoneTextField resignFirstResponder];
    }
    
    if (self.passwordTextField.isFirstResponder) {
        [self.passwordTextField resignFirstResponder];
    }
    
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ForgetPassViewController* controller =[storyBoard instantiateViewControllerWithIdentifier:@"ModifyPasswordController"];
    controller.type=0;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)registeAction:(id)sender
{
    UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    RegisteViewController * controller = [board instantiateViewControllerWithIdentifier:@"RegisteController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)CreateUserAction:(id)sender
{
    UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller =[board instantiateViewControllerWithIdentifier:@"RegisteController"];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)ForgetPassAction:(id)sender
{
    // 检测键盘
    if (self.phoneTextField.isFirstResponder) {
        [self.phoneTextField resignFirstResponder];
    }
    
    if (self.passwordTextField.isFirstResponder) {
        [self.passwordTextField resignFirstResponder];
    }
    
    
    UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller =[board instantiateViewControllerWithIdentifier:@"ModifyPasswordController"];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (BOOL)doAction:(id)sender {
    
    //收起键盘
    [self resignKeyboard];
    //装载数据
    NSDictionary* dic =[[NSMutableDictionary alloc]init];
    if ([sender isKindOfClass:UIButton.class]) {
        //初始化网络请求对象
        //获取数据
        NSString* phoneNumber =self.phoneTextField.text;
        password = self.passwordTextField.text;
        
        //校验数据
        if (phoneNumber && ![phoneNumber isEqualToString:@""]) {
            if (![TDUtil validateMobile:phoneNumber]) {
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入正确手机号码"];
                self.phoneTextField.text=@"";
                return NO;
            }
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入手机号码"];
            return NO;
        }
        if (!password || [password isEqualToString:@""]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入密码"];
            return NO;
        }
        
        //加密
        password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:password];
        //极光推送id
        NSString* regId = [APService registrationID];
        if ([regId isEqualToString:@""]) {
            regId = @"123";
        }
        
        [dic setValue:regId forKey:@"regid"];
        [dic setValue:phoneNumber forKey:@"tel"];
        [dic setValue:password forKey:@"passwd"];
        
        //开始加载动画
        [activity startAnimating];
    }else if([sender isKindOfClass:ASIHTTPRequest.class]){
        NSString* regId = [APService registrationID];
        [dic setValue:regId forKey:@"regid"];
        [dic setValue:openId forKey:@"openid"];
    }
    
    
    
    //加载动画控件
    if (!activity) {
        //进度
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(self.loginButton)/3-18, HEIGHT(self.loginButton)/2-15, 30, 30)];//指定进度轮的大小
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        [self.loginButton addSubview:activity];
    }
    
    if (!activity.isAnimating) {
        [activity startAnimating];
    }
    [activity setColor:WriteColor];
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:dic type:0 delegate:self sel:@selector(requestLogin:)];
    
    return YES;
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (void)resignKeyboard
{
    //收起键盘
    for (UIView * v in scrollView.subviews){
        if (v.class ==  UITextField.class) {
            [(UITextField*)v resignFirstResponder];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(id)sender
{
    
}

#pragma ASIHttpRequester
//===========================================================网络请求=====================================

/**
 *  登录
 *
 *  @param request 请求实例
 */
- (void)requestLogin:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];

    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSLog(@"登录成功!");
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* controller =[storyBoard instantiateViewControllerWithIdentifier:@"HomeTabController"];
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:self.phoneTextField.text forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            [data setValue:password forKey:STATIC_USER_PASSWORD];
            [data setValue:@"YES" forKey:@"isLogin"];

            NSString* auth =[[jsonDic valueForKey:@"data"] valueForKey:@"auth"];
            /**
             *  auth 判断用户是否已经认证: ""--> 从未提交认证信息，None-->后端正在审核中，true-->认证成功，false-->认证失败
             */
            if ([auth isKindOfClass:NSNull.class]) {
                auth = @"None";
            }else if (auth){
                if ([auth boolValue]) {
                    auth = @"true";
                }else{
                    auth  = @"false";
                }
            }
            
            [data setValue:(NSString*)auth forKey:@"auth"];
            [data setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"info"] forKey:@"info"];
            
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
            [self.navigationController pushViewController:self.drawerController animated:YES];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            [self removeFromParentViewController];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        }
        [activity stopAnimating];
    }
}

-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSString* flag = [[jsonDic valueForKey:@"data"] valueForKey:@"flag"];
            if (![flag boolValue]) {
                WeChatBindController* controller =[[WeChatBindController alloc]init];
                controller.openId = openId;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [self doAction:request];
            }
        }
        
        self.startLoading = NO;
    }
}
/**
 *  网络请求失败
 *
 *  @param request 请求实例
 */
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    self.startLoading =NO;
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络请求错误"];
    [activity stopAnimating];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
/**
 *  视图重绘
 *
 *  @param animated 是否以动画方式
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (!self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAccess_token:) name:@"WeChatBind" object:nil];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/**
 *  释放内存空间
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
