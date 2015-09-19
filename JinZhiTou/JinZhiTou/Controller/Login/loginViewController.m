//
//  loginViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "loginViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "MMDrawerController.h"
#import "RegisteViewController.h"
#import "UserInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MMExampleDrawerVisualStateManager.h"
@interface loginViewController ()<ASIHTTPRequestDelegate,UITextFieldDelegate>
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
    [self.navigationController.navigationBar setHidden:YES];
    self.view.backgroundColor=ColorTheme;
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"登录"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"登陆注册" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.view addSubview:self.navView];

    CGRect frame = self.view.frame;
    frame.origin.y = POS_Y(self.navView);
    frame.size.height = HEIGHT(self.view)-POS_Y(self.navView);
    
    scrollView = [[UIScrollView alloc]initWithFrame:frame];
    scrollView.backgroundColor = WriteColor;
    [self.view addSubview:scrollView];
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:scrollView.frame];
    imgView.image = IMAGENAMED(@"denglu");
    [scrollView addSubview:imgView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, WIDTH(self.view), 40)];
    label.textColor = ColorTheme;
    label.text =@"让梦想从这里启航";
    label.font = SYSTEMFONT(30);
    label.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:label];
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(30, POS_Y(label)+20, WIDTH(self.view)-60, 45)];
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
    
    [TDUtil setTextFieldLeftPadding:self.phoneTextField forImage:@"shuruphone"];
    [scrollView addSubview:self.phoneTextField];
    
    
    self.passwordTextField =[[UITextField alloc]initWithFrame:CGRectMake(30, POS_Y(self.phoneTextField)+20, WIDTH(self.phoneTextField), 45)];
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
    
    [TDUtil setTextFieldLeftPadding:self.passwordTextField forImage:@"mima"];
    
    [scrollView addSubview:self.passwordTextField];
    
    
    
    self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(self.passwordTextField)+40, WIDTH(scrollView)-60, 40)];
    self.loginButton.layer.cornerRadius = 5;
    [self.loginButton setBackgroundColor:ColorTheme];
    [self.loginButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:WriteColor forState:UIControlStateNormal];
    [scrollView addSubview:self.loginButton];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CreateUserAction:)];
    self.userImageView.userInteractionEnabled = YES;
    [self.userImageView addGestureRecognizer:recognizer];
    
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ForgetPassAction:)];
    self.forgetPassImgView.userInteractionEnabled = YES;
    [self.forgetPassImgView addGestureRecognizer:recognizer];
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ForgetPassAction:)];
    self.forgetPassLabel.userInteractionEnabled = YES;
    [self.forgetPassLabel addGestureRecognizer:recognizer];
    
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)CreateUserAction:(id)sender
{
    UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller =[board instantiateViewControllerWithIdentifier:@"RegisteController"];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)ForgetPassAction:(id)sender
{
    UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller =[board instantiateViewControllerWithIdentifier:@"ModifyPasswordController"];
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (BOOL)doAction:(id)sender {
    
    [self resignKeyboard];
    HttpUtils* httpUtil =[[HttpUtils alloc]init];
    NSDictionary* dic =[[NSMutableDictionary alloc]init];
    NSString* phoneNumber =self.phoneTextField.text;
    password = self.passwordTextField.text;
    
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
    NSLog(@"password:%@",password);
    [dic setValue:phoneNumber forKey:@"telephone"];
    [dic setValue:password forKey:@"password"];
    
    if (!activity) {
        //进度
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(self.loginButton)/3-15, HEIGHT(self.loginButton)/2-15, 30, 30)];//指定进度轮的大小
        
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        [self.loginButton addSubview:activity];
    }else{
        if (!activity.isAnimating) {
            [activity startAnimating];
        }
    }
   
    [activity startAnimating];
    [httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:dic type:1 delegate:self sel:@selector(requestLogin:)];
    return YES;
}

#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointMake(0, 90) animated:YES];
    [UIView animateWithDuration:0.5 animations:^(void){
        [label setAlpha:0];
    }];
}

-(void)resignKeyboard
{
    //收起键盘
    for (UIView * v in scrollView.subviews){
        if (v.class ==  UITextField.class) {
            [(UITextField*)v resignFirstResponder];
        }
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:1 animations:^(void){
        [label setAlpha:1];
    }];
    return YES;
}

-(void)textFieldDidChange:(id)sender
{
    
}

#pragma ASIHttpRequester
//===========================================================网络请求=====================================
//登录
-(void)requestLogin:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            NSLog(@"登录成功!");
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* controller =[storyBoard instantiateViewControllerWithIdentifier:@"HomeTabController"];
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:self.phoneTextField.text forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            [data setValue:password forKey:STATIC_USER_PASSWORD];
            [data setValue:@"YES" forKey:@"isLogin"];
            [data setValue:@"NO" forKey:@"isAnimous"];
            
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
            [self.navigationController pushViewController:self.drawerController animated:YES];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            
        }else{
            NSLog(@"登录失败!");
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        }
        [activity stopAnimating];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}
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
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
