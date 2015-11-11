//
//  loginViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "loginViewController.h"
#import "APService.h"
#import "MMDrawerController.h"
#import "RegisteViewController.h"
#import "UserInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ForgetPassViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
@interface loginViewController ()<UITextFieldDelegate>
{
    UIActivityIndicatorView* activity;
    UIScrollView* scrollView;
    
    UILabel* label;
    
    NSString* password;
}
@property(retain,nonatomic)MMDrawerController* drawerController;
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    
    //设置背景色
    self.view.backgroundColor=ColorTheme;
    
    //==============================导航栏区域开始==============================//
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"登录"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"登陆注册" forState:UIControlStateNormal];
    
    //添加事件
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    //==============================导航栏区域结束==============================//
    

    CGRect frame = self.view.frame;
    frame.origin.y = POS_Y(self.navView);
    frame.size.height = HEIGHT(self.view)-POS_Y(self.navView);
    
    //==============================滚动时图区域开始==============================//
    scrollView = [[UIScrollView alloc]initWithFrame:frame];
    scrollView.backgroundColor = WriteColor;
    
    [self.view addSubview:scrollView];
    //==============================滚动时图区域开始==============================//
    
    //==============================滚动时图子视图添加开始==============================//
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:scrollView.frame];
    imgView.image = IMAGENAMED(@"denglu");
    
    //登录背景添加至滚动视图
    [scrollView addSubview:imgView];
    
    //标题
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, WIDTH(self.view), 40)];
    label.textColor = ColorTheme;
    label.text =@"让梦想从这里启航";
    label.font = SYSTEMFONT(30);
    label.textAlignment = NSTextAlignmentCenter;
    
    //将标签添加至滚动视图
    [scrollView addSubview:label];
    
    //手机号码输入框
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(30, POS_Y(label)+20, WIDTH(self.view)-60, 45)];
    
    //设置属性
    self.phoneTextField.tag=1004;
    self.phoneTextField.delegate=self;
    self.phoneTextField.font = SYSTEMFONT(16);
    self.phoneTextField.textColor =ColorTheme;
    self.phoneTextField.placeholder = @"请输入手机号码";
    self.phoneTextField.returnKeyType = UIReturnKeyDone;
    self.phoneTextField.layer.borderColor =ColorTheme.CGColor;
    self.phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.phoneTextField.layer.cornerRadius=HEIGHT(self.phoneTextField)/2;
    self.phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.phoneTextField.layer.borderWidth =1;
    
    //设置输入框左侧图标
    [TDUtil setTextFieldLeftPadding:self.phoneTextField forImage:@"shuruphone"];
    
    //将输入框添加至滚动视图
    [scrollView addSubview:self.phoneTextField];
    
    //密码输入框
    self.passwordTextField =[[UITextField alloc]initWithFrame:CGRectMake(30, POS_Y(self.phoneTextField)+20, WIDTH(self.phoneTextField), 45)];
    
    //设置属性
    self.passwordTextField.delegate=self;
    self.passwordTextField.layer.borderWidth =1;
    self.passwordTextField.secureTextEntry=YES;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.font = SYSTEMFONT(16);
    self.passwordTextField.textColor = ColorTheme;
    self.passwordTextField.placeholder =@"请输入登录密码";
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.layer.borderColor =ColorTheme.CGColor;
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.layer.cornerRadius=HEIGHT(self.passwordTextField)/2;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    //设置输入框左侧图标
    [TDUtil setTextFieldLeftPadding:self.passwordTextField forImage:@"mima"];
    
    //密码输入框添加至滚动视图
    [scrollView addSubview:self.passwordTextField];
    
    
    //登录按钮
    self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(self.passwordTextField)+40, WIDTH(scrollView) - 60, 40)];
    
    //设置登录按钮属性
    [self.loginButton.layer setCornerRadius:5];
    [self.loginButton.layer setBorderWidth:1];
    [self.loginButton.layer setBorderColor:ColorTheme.CGColor];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:ColorTheme forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //将登录按钮添加至滚动视图
    [scrollView addSubview:self.loginButton];
    
    //忘记密码按钮
    UIButton* btnActionLeft = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self.loginButton)*2/3+X(self.loginButton)+18, POS_Y(self.loginButton)+15, WIDTH(self.loginButton)/3, 40)];
    
    //设置忘记密码按钮样式
    [btnActionLeft addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置UIButton特殊样式
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记密码"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSFontAttributeName value:SYSTEMFONT(14) range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    //赋富文本值
    [btnActionLeft setAttributedTitle:str forState:UIControlStateNormal];
    
    //将忘记密码按钮添加至滚动视图
    [scrollView addSubview:btnActionLeft];
    //==============================滚动时图子视图添加开始==============================//

    
}

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
    //装载数据
    NSDictionary* dic =[[NSMutableDictionary alloc]init];

    [dic setValue:regId forKey:@"regid"];
    [dic setValue:phoneNumber forKey:@"tel"];
    [dic setValue:@"2.1.0" forKey:@"version"];
    [dic setValue:password forKey:@"passwd"];
    
    //加载动画
    //加载动画控件
    if (!activity) {
        //进度
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(self.loginButton)/3-18, HEIGHT(self.loginButton)/2-15, 30, 30)];//指定进度轮的大小
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        [self.loginButton addSubview:activity];
    }else{
        if (!activity.isAnimating) {
            [activity startAnimating];
        }
    }
    [activity setColor:ColorTheme];
    
    //开始加载动画
    [activity startAnimating];
    
    
    //开始请求
    [self.httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:dic type:0 delegate:self sel:@selector(requestLogin:)];
    
    return YES;
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointMake(0, 90) animated:YES];
    [UIView animateWithDuration:0.5 animations:^(void){
        [label setAlpha:0];
    }];
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
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    [UIView animateWithDuration:1 animations:^(void){
        [label setAlpha:1];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:1 animations:^(void){
        [label setAlpha:1];
    }];
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
            [data setValue:[[jsonDic valueForKey:@"data"] valueForKey:@"auth"] forKey:@"auth"];
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
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        }
        [activity stopAnimating];
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
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络请求错误"];
    [activity stopAnimating];
    
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
}

/**
 *  释放内存空间
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
