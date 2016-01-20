//
//  RegisteViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "APService.h"
#import "MMDrawerController.h"
#import "PrivacyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserInfoViewController.h"
#import "UserInfoViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
@interface ResetPasswordViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView* scrollView;
    UIActivityIndicatorView* activity;
}
@property(retain,nonatomic)MMDrawerController* drawerController;
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景
    self.view.backgroundColor=ColorTheme;
    //设置属性
    self.navView.imageView.alpha=1;
//    [self.navView setTitle:@"修改密码"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.navView), HEIGHT(self.view)-POS_Y(self.navView))];
    imgView.contentMode  =UIViewContentModeScaleAspectFill;
    imgView.image= IMAGE(@"login", @"png");
    [self.view addSubview:imgView];
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.navView), HEIGHT(self.view)-POS_Y(self.navView))];
    
    scrollView.backgroundColor = ClearColor;
    [scrollView setContentSize:CGSizeMake(WIDTH(scrollView), HEIGHT(scrollView)+100)];
    
    [self.view addSubview:scrollView];
    
    self.codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 30, WIDTH(self.view)-30, 45)];
    self.codeTextField.tag=1005;
    self.codeTextField.delegate=self;
    self.codeTextField.font = SYSTEMFONT(16);
    self.codeTextField.textColor = WriteColor;
    self.codeTextField.secureTextEntry  =YES;
    self.codeTextField.placeholder = @"请输入旧密码";
    self.codeTextField.returnKeyType = UIReturnKeyDone;
    self.codeTextField.borderStyle =UITextBorderStyleNone;
    self.codeTextField.backgroundColor  =RGBACOLOR(203, 203, 203, 0.4);
    self.codeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTextField.layer.cornerRadius = HEIGHT(self.codeTextField)/2;
    self.codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [scrollView addSubview:self.codeTextField];
    //设置输入框左侧图标
    [TDUtil setTextFieldLeftPadding:self.codeTextField forImage:@"yanzhengma"];

    self.passTextField = [[UITextField alloc]initWithFrame:CGRectMake(X(self.codeTextField), POS_Y(self.codeTextField)+10, WIDTH(self.codeTextField), HEIGHT(self.codeTextField))];
    self.passTextField.tag=1004;
    self.passTextField.delegate=self;
    self.passTextField.secureTextEntry = YES;
    self.passTextField.font = SYSTEMFONT(16);
    self.passTextField.textColor = WriteColor;
    self.passTextField.placeholder = @"请输入密码";
    self.passTextField.returnKeyType = UIReturnKeyDone;
    self.passTextField.borderStyle =UITextBorderStyleNone;
    self.passTextField.backgroundColor  =RGBACOLOR(203, 203, 203, 0.2);
    self.passTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passTextField.layer.cornerRadius = HEIGHT(self.codeTextField)/2;
    self.passTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [scrollView addSubview:self.passTextField];
    
    //设置输入框左侧图标
    [TDUtil setTextFieldLeftPadding:self.passTextField forImage:@"shurumima"];
    

    self.passRepeatTextField = [[UITextField alloc]initWithFrame:CGRectMake(X(self.passTextField), POS_Y(self.passTextField)+10, WIDTH(self.codeTextField), HEIGHT(self.codeTextField))];
    self.passRepeatTextField.tag=1004;
    self.passRepeatTextField.delegate=self;
    self.passRepeatTextField.secureTextEntry = YES;
    self.passRepeatTextField.font = SYSTEMFONT(16);
    self.passRepeatTextField.textColor = WriteColor;
    self.passRepeatTextField.placeholder = @"请重复密码";
    self.passRepeatTextField.returnKeyType = UIReturnKeyDone;
    self.passRepeatTextField.borderStyle =UITextBorderStyleNone;
    self.passRepeatTextField.backgroundColor  =RGBACOLOR(203, 203, 203, 0.2);
    self.passRepeatTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passRepeatTextField.layer.cornerRadius = HEIGHT(self.codeTextField)/2;
    self.passRepeatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passRepeatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [scrollView addSubview:self.passRepeatTextField];
    
    //设置输入框左侧图标
    [TDUtil setTextFieldLeftPadding:self.passRepeatTextField forImage:@"mima"];
    
    
    self.regietButton = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(self.passRepeatTextField)+30, WIDTH(self.view)-60, 40)];
    self.regietButton.layer.cornerRadius = 5;
    [self.regietButton setTitle:@"立即修改" forState:UIControlStateNormal];
    [self.regietButton addTarget:self action:@selector(doRegistAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.regietButton setTitleColor:WriteColor forState:UIControlStateNormal];
    [self.regietButton setBackgroundColor:AppColorTheme];
    [scrollView addSubview:self.regietButton];
    
}

-(void)protocolAction:(id)sender
{
    //收起键盘
    [self resignKeyboard];
    
    PrivacyViewController* controller = [[PrivacyViewController alloc]init];
    controller.serverUrl = useragreement;
    controller.title = @"返回";
    controller.titleStr =@"金指投用户协议";
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doAction:(id)sender
{
    UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"金指投提醒" message:@"金指投协议阅读该功能最后做" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
}


- (BOOL)doRegistAction:(id)sender {
    
    [self resignKeyboard];
    NSString* oldPassword = self.codeTextField.text;
    NSString* password  =self.passTextField.text;
    NSString* passwordRepeat = self.passRepeatTextField.text;
    
    if (!oldPassword || [oldPassword isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入旧密码"];
        return NO;
    }
    
    if (!password || [password isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入密码"];
         return NO;
    }
    
    if (!passwordRepeat || [passwordRepeat isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请再次输入密码"];
         return NO;
    }
    if ([passwordRepeat intValue]!=[password intValue]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"两次密码输入不一致"];
         return NO;
    }
    
    //加密
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    
    NSString* phoneNumber=[data valueForKey:USER_STATIC_TEL];
    oldPassword = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:oldPassword];
    password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:password];
    
    NSDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:oldPassword forKey:@"old"];
    [dic setValue:password forKey:@"new"];
    
    
    //加载动画
    //加载动画控件
    if (!activity) {
        //进度
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(self.regietButton)/3-18, HEIGHT(self.regietButton)/2-15, 30, 30)];//指定进度轮的大小
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        [self.regietButton addSubview:activity];
    }else{
        if (!activity.isAnimating) {
            [activity startAnimating];
        }
    }
    [activity setColor:WriteColor];
    
    //开始加载动画
    [activity startAnimating];
    
    
    [self.httpUtil getDataFromAPIWithOps:USER_RESET_PW postParam:dic type:0 delegate:self sel:@selector(requestRegiste:)];
    return YES;
}


#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [scrollView setContentOffset:CGPointMake(0, 50) animated:YES];
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
    return YES;
}

-(void)textFieldDidChange:(id)sender
{

}

#pragma ASIHttpRequester
//===========================================================网络请求=====================================
//发送验证码
-(void)requestSendeCode:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        }else{
             [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        }
    }
}
//注册
-(void)requestRegiste:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            NSString* password  =self.passTextField.text;
            NSString* phoneNumber=[data valueForKey:USER_STATIC_TEL];
            password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:password];
            [data setValue:password forKey:STATIC_USER_PASSWORD];
            
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            
            //进度查看
            double delayInSeconds = 1.0;
            //__block RoadShowDetailViewController* bself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self back:nil];
            });
            
        }else{
            NSString* msg =[jsonDic valueForKey:@"msg"];
             [[DialogUtil sharedInstance]showDlg:self.view textOnly:msg];
        }
        [activity stopAnimating];
    }

}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    [activity stopAnimating];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

@end
