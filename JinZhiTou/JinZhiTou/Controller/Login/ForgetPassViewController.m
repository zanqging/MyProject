//
//  ForgetPassViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ForgetPassViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "MMDrawerController.h"
#import "UserInfoViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
@interface ForgetPassViewController ()<UITextFieldDelegate>
{
    UIScrollView* scrollView;
    UIActivityIndicatorView* activity;
}
@property(retain,nonatomic)MMDrawerController* drawerController;
@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //背景
    self.view.backgroundColor=ColorTheme;
    //设置属性
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@""];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.navView), HEIGHT(self.view)-POS_Y(self.navView))];
    imgView.contentMode  =UIViewContentModeScaleAspectFill;
    imgView.image= IMAGE(@"login", @"png");
    [self.view addSubview:imgView];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.navView), HEIGHT(self.view)-POS_Y(self.navView))];
    
    scrollView.backgroundColor = ClearColor;
    [scrollView setContentSize:CGSizeMake(WIDTH(scrollView), HEIGHT(scrollView)+100)];
    
    [self.view addSubview:scrollView];
    
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 30, WIDTH(self.view)-30, 45)];
    self.phoneTextField.tag=1004;
    self.phoneTextField.delegate=self;
    self.phoneTextField.font = SYSTEMFONT(16);
    self.phoneTextField.textColor =WriteColor;
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
    self.codeTextField.delegate=self;
    self.codeTextField.clearButtonMode = UITextFieldViewModeNever;
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
    [self.codeButton addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:self.codeButton];
    
    __block ForgetPassViewController * cSelf = self;
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
    
    
    self.regietButton = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(self.passRepeatTextField)+60, WIDTH(self.view)-60, 40)];
    self.regietButton.layer.cornerRadius = 5;
    [self.regietButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [self.regietButton addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.regietButton setTitleColor:WriteColor forState:UIControlStateNormal];
    [self.regietButton setBackgroundColor:AppColorTheme];
    [scrollView addSubview:self.regietButton];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)sendCode:(id)sender
{
    [self resignKeyboard];
    NSString* phoneNumber =self.phoneTextField.text;
    if ([TDUtil isValidString:phoneNumber]) {
        if ([TDUtil validateMobile:phoneNumber]) {

             NSString* serverUrl = [SEND_MESSAGE_CODE stringByAppendingFormat:@"1/0/"];
            [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:[NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"tel", nil] type:0 delegate:self sel:@selector(requestSendeCode:)];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码格式不正确"];
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码不能为空"];
    }
}

-(BOOL)doAction:(id)sender
{
    [self resignKeyboard];
    NSString* code =self.codeTextField.text;
    NSString* password = self.passTextField.text;
    NSString* phoneNumber =self.phoneTextField.text;
    NSString* passwordRepeat = self.passRepeatTextField.text;
    
    if ([TDUtil isValidString:phoneNumber]) {
        if (![TDUtil validateMobile:phoneNumber]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码格式不正确"];
            return NO;
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入手机号码"];
        return NO;
    }
    
    if (![TDUtil isValidString:code]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入验证码"];
        return NO;
    }
    
    if (![TDUtil isValidString:password]) {
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
    
    
    password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:password];
    
    if (![TDUtil isValidString:password]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"系统错误"];
        return NO;
    }
    NSDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:phoneNumber forKey:@"tel"];
    [dic setValue:password forKey:@"passwd"];
    [dic setValue:code forKey:@"code"];
    
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
    NSString* server_url = RESET_PASSWORD;
    [self.httpUtil getDataFromAPIWithOps:server_url postParam:dic type:0 delegate:self sel:@selector(requestRestPass:)];
    return YES;
    
}
#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)resignKeyboard
{
    //收起键盘
    UIView* view = [scrollView viewWithTag:20001];
    for (UIView * v in view.subviews){
        if (v.class ==  UITextField.class) {
            [(UITextField*)v resignFirstResponder];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
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
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"验证码发送成功!" ];
        }else{
            if ([code intValue] == 1) {
                [self.codeButton stop];
            }
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            [self.codeButton stop];
        }
    }
}
//注册
-(void)requestRestPass:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UIViewController* controller =[storyBoard instantiateViewControllerWithIdentifier:@"HomeTabController"];
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:@"YES" forKey:@"isLogin"];
            [data setValue:@"NO" forKey:@"isAnimous"];
            NSString* phoneNumber = self.phoneTextField.text;
            NSString* password =self.passTextField.text;
            password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:password];
            
            [data setValue:phoneNumber forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
            [data setValue:password forKey:STATIC_USER_PASSWORD];
            
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

@end
