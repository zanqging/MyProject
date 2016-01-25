//
//  RegisteViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RegisteViewController.h"
#import "APService.h"
#import "MMDrawerController.h"
#import "PrivacyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserInfoViewController.h"
#import "UserInfoViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
@interface RegisteViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView* scrollView;
    UIActivityIndicatorView* activity;
}
@property(retain,nonatomic)MMDrawerController* drawerController;
@end

@implementation RegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景
    self.view.backgroundColor=ColorTheme;
    //设置属性
    self.navView.imageView.alpha=1;
//    [self.navView setTitle:@"注册"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.navView), HEIGHT(self.view)-POS_Y(self.navView))];
    imgView.contentMode  =UIViewContentModeScaleToFill;
    imgView.image= IMAGE(@"login", @"png");
    [self.view addSubview:imgView];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.navView), HEIGHT(self.view)-POS_Y(self.navView))];
    
    scrollView.backgroundColor = ClearColor;
    scrollView.bounces  = YES;
    [scrollView setContentSize:CGSizeMake(WIDTH(scrollView), HEIGHT(scrollView)+100)];
    
    [self.view addSubview:scrollView];
    
    
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 30, WIDTH(self.view)-30, 45)];
    self.phoneTextField.tag=1004;
    self.phoneTextField.delegate=self;
    self.phoneTextField.font = SYSTEMFONT(16);
    self.phoneTextField.textColor = WriteColor;
    self.phoneTextField.placeholder = @"请输入手机号";
    self.phoneTextField.returnKeyType = UIReturnKeyDone;
    self.phoneTextField.borderStyle =UITextBorderStyleNone;
    self.phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.phoneTextField.backgroundColor  =RGBACOLOR(203, 203, 203, 0.4);
    self.phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.layer.cornerRadius = 2;
    self.phoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [scrollView addSubview:self.phoneTextField];
    //设置输入框左侧图标
    [TDUtil setTextFieldLeftPadding:self.phoneTextField forImage:@"shoujihao"];
    
    
    self.codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(X( self.phoneTextField), POS_Y(self.phoneTextField)+10, WIDTH(self.phoneTextField), HEIGHT(self.phoneTextField))];
    self.codeTextField.tag=1005;
    self.codeTextField.clearButtonMode = UITextFieldViewModeNever;
    self.codeTextField.delegate=self;
    self.codeTextField.font = SYSTEMFONT(16);
    self.codeTextField.textColor = WriteColor;
    self.codeTextField.placeholder = @"请输入验证码";
    self.codeTextField.returnKeyType = UIReturnKeyDone;
    self.codeTextField.borderStyle =UITextBorderStyleNone;
    self.codeTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.codeTextField.backgroundColor  =RGBACOLOR(203, 203, 203, 0.4);
    self.codeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.codeTextField.layer.cornerRadius = 2;
    self.codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [scrollView addSubview:self.codeTextField];
    //设置输入框左侧图标
    [TDUtil setTextFieldLeftPadding:self.codeTextField forImage:@"yanzhengma"];
    
    self.codeButton = [[JKCountDownButton alloc]initWithFrame:CGRectMake(POS_X(self.codeTextField)-110, Y(self.codeTextField)+5, 90, 35)];
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.cornerRadius = 5;
    [self.codeButton.titleLabel setFont:SYSTEMFONT(13)];
    [self.codeButton setBackgroundColor:AppColorTheme];
    self.codeButton.layer.borderColor = AppColorTheme.CGColor;
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:WriteColor forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:self.codeButton];
    
    __block RegisteViewController * cSelf = self;
    [self.codeButton addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
        
        NSString* phoneNumber = cSelf.phoneTextField.text;
        if ([TDUtil isValidString:phoneNumber]) {
            if ([TDUtil validateMobile:phoneNumber]) {
                cSelf.isCountDown = YES;
            }
        }
        if (cSelf.isCountDown) {
             sender.enabled = NO;
            [sender startWithSecond:60];
            
            [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
                NSString *title = [NSString stringWithFormat:@"剩余%d秒",second];
                return title;
            }];
            [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
                countDownButton.enabled = YES;
                return @"点击重新获取";
                
            }];
        }
    }];
    

    self.passTextField = [[UITextField alloc]initWithFrame:CGRectMake(X(self.codeTextField), POS_Y(self.codeTextField)+10, WIDTH(self.phoneTextField), HEIGHT(self.phoneTextField))];
    self.passTextField.tag=1004;
    self.passTextField.delegate=self;
    self.passTextField.secureTextEntry = YES;
    self.passTextField.font = SYSTEMFONT(16);
    self.passTextField.textColor = WriteColor;
    self.passTextField.placeholder = @"请输入密码";
    self.passTextField.returnKeyType = UIReturnKeyDone;
    self.passTextField.borderStyle =UITextBorderStyleNone;
    self.passTextField.backgroundColor  =RGBACOLOR(203, 203, 203, 0.4);
    self.passTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passTextField.layer.cornerRadius = 2;
    self.passTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [scrollView addSubview:self.passTextField];
    
    //设置输入框左侧图标
    [TDUtil setTextFieldLeftPadding:self.passTextField forImage:@"shurumima"];
    

    self.passRepeatTextField = [[UITextField alloc]initWithFrame:CGRectMake(X(self.passTextField), POS_Y(self.passTextField)+10, WIDTH(self.phoneTextField), HEIGHT(self.phoneTextField))];
    self.passRepeatTextField.tag=1004;
    self.passRepeatTextField.delegate=self;
    self.passRepeatTextField.secureTextEntry = YES;
    self.passRepeatTextField.font = SYSTEMFONT(16);
    self.passRepeatTextField.textColor = WriteColor;
    self.passRepeatTextField.placeholder = @"请重复密码";
    self.passRepeatTextField.returnKeyType = UIReturnKeyDone;
    self.passRepeatTextField.borderStyle =UITextBorderStyleNone;
    self.passRepeatTextField.backgroundColor  =RGBACOLOR(203, 203, 203, 0.4);
    self.passRepeatTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passRepeatTextField.layer.cornerRadius = 2;
    self.passRepeatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passRepeatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [scrollView addSubview:self.passRepeatTextField];
    
    //设置输入框左侧图标
    [TDUtil setTextFieldLeftPadding:self.passRepeatTextField forImage:@"mima"];

    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0,POS_Y(self.passRepeatTextField)+20, WIDTH(scrollView), 20)];
    label.font = SYSTEMFONT(14);
    label.userInteractionEnabled = YES;
    label.textColor = BackColor;
    label.textAlignment = NSTextAlignmentCenter;
    NSString* content =@"新注册用户请查看《金指投用户协议》";

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSForegroundColorAttributeName value:AppColorTheme range:NSMakeRange(8, [content length]-8)];
    
    label.attributedText = attributedString;//ios 6
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(protocolAction:)]];
    [scrollView addSubview:label];
    
    
    self.regietButton = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(label)+60, WIDTH(self.view)-60, 40)];
    self.regietButton.layer.cornerRadius = 5;
    [self.regietButton setTitle:@"立即注册" forState:UIControlStateNormal];
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

-(void)sendMessage:(id)sender
{
    [self resignKeyboard];
    NSString* phoneNumber =self.phoneTextField.text;
    if (phoneNumber) {
        if ([TDUtil validateMobile:phoneNumber]) {
            NSString* serverUrl = [SEND_MESSAGE_CODE stringByAppendingFormat:@"0/0/"];
            [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:[NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"tel", nil] type:0 delegate:self sel:@selector(requestSendeCode:)];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码格式不正确"];
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码不能为空"];
    }
}
-(void)doAction:(id)sender
{
    UIAlertView* alertView=[[UIAlertView alloc]initWithTitle:@"金指投提醒" message:@"金指投协议阅读该功能最后做" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alertView show];
}


- (BOOL)doRegistAction:(id)sender {
    
    [self resignKeyboard];
    NSString* phoneNumber =self.phoneTextField.text;
    NSString* password  =self.passTextField.text;
    NSString* passwordRepeat = self.passRepeatTextField.text;
    NSString* code = self.codeTextField.text;
    
    
    if (phoneNumber && ![phoneNumber isEqualToString:@""]) {
        if (![TDUtil validateMobile:phoneNumber]) {
             [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码格式不正确"];
            return NO;
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入手机号码"];
        return NO;
    }
    
    if (!code || [code isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入验证码"];
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
    password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:password];
    
    NSString* regId = [APService registrationID];
    
    /**
     测试
     */
    if (!regId || [regId isEqualToString:@""]) {
        regId = @"1234";
    }
    
    NSDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:code forKey:@"code"];
    [dic setValue:regId forKey:@"regid"];
    [dic setValue:phoneNumber forKey:@"tel"];
    [dic setValue:password forKey:@"passwd"];
    [dic setValue:@"2.1.0" forKey:@"version"];
    
    //ios 使用：1，Android 使用:2；
    NSString* serverUrl = [USER_REGIST stringByAppendingString:@"1/"];
    
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
    
    
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:dic type:0 delegate:self sel:@selector(requestRegiste:)];
    return YES;
}


#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointMake(0, 50) animated:YES];
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
            [self.codeButton stop];
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
            NSLog(@"注册成功!");
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:@"YES" forKey:@"isLogin"];
            [data setValue:@"" forKey:@"auth"];
            [data setValue:@"false" forKey:@"info"];
            
            [data setValue:self.phoneTextField.text forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* controller =[storyBoard instantiateViewControllerWithIdentifier:@"HomeTabController"];
            
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
