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
@interface ForgetPassViewController ()<UITextFieldDelegate,ASIHTTPRequestDelegate>
{
    HttpUtils* httpUtils;
}
@property(retain,nonatomic)MMDrawerController* drawerController;
@end

@implementation ForgetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    if (self.type==0) {
        [self.navView setTitle:@"忘记密码"];
    }else{
        [self.navView setTitle:@"修改密码"];
    }
    
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.view addSubview:self.navView];
    
    
    self.configBtn.backgroundColor= ColorTheme;
    [self.configBtn addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    self.configBtn.layer.cornerRadius = HEIGHT(self.configBtn)/2;
    
    self.phoneTextField.layer.borderWidth = 1;
    self.phoneTextField.font  =SYSTEMFONT(14);
    self.phoneTextField.layer.borderColor = WriteColor.CGColor;
    self.phoneTextField.borderStyle =UITextBorderStyleNone;
    self.phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.phoneTextField.returnKeyType = UIReturnKeyDone;
    self.phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.phoneTextField.delegate = self;
    
    self.passTextField.secureTextEntry = YES;
    self.passTextField.font  =SYSTEMFONT(14);
    self.passTextField.layer.borderWidth = 1;
    self.passTextField.returnKeyType = UIReturnKeyDone;
    self.passTextField.layer.borderColor = WriteColor.CGColor;
    self.passTextField.layer.shadowColor=WriteColor.CGColor;
    self.passTextField.borderStyle =UITextBorderStyleNone;
    self.passTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passTextField.delegate = self;
    
    
    self.codeTextField.layer.borderWidth = 1;
    self.codeTextField.font  =SYSTEMFONT(14);
    self.codeTextField.layer.borderColor = WriteColor.CGColor;
    self.codeTextField.layer.shadowColor=WriteColor.CGColor;
    self.codeTextField.borderStyle =UITextBorderStyleNone;
    self.codeTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.codeTextField.returnKeyType = UIReturnKeyDone;
    self.codeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.codeTextField.delegate = self;
    
    self.codeButton.layer.cornerRadius = 5;
    self.codeButton.layer.borderWidth = 1;
    [self.codeButton addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
    self.codeButton.layer.borderColor = ColorTheme.CGColor;
    [self.codeButton setTitleColor:ColorTheme forState:UIControlStateNormal];
    
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
    
    httpUtils = [[HttpUtils alloc]init];
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

            [httpUtils getDataFromAPIWithOps:SEND_MESSAGE_CODE postParam:[NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"telephone",@"1",@"flag", nil] type:0 delegate:self sel:@selector(requestSendeCode:)];
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
    
    
    password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:password];
    
    if (![TDUtil isValidString:password]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"系统错误"];
        return NO;
    }
    NSDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:phoneNumber forKey:@"telephone"];
    [dic setValue:password forKey:@"password"];
    [dic setValue:code forKey:@"code"];
    NSString* server_url = RESET_PASSWORD;
    [httpUtils getDataFromAPIWithOps:server_url postParam:dic type:0 delegate:self sel:@selector(requestRestPass:)];
    return YES;
    
}
#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)resignKeyboard
{
    //收起键盘
    for (UIView * v in self.subView.subviews){
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
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"验证码发送成功!" ];
            NSLog(@"验证码发送成功!");
        }else{
            if ([status intValue] == 1) {
                [self.codeButton stop];
            }
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            NSLog(@"验证码发送失败!");
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
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
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
        }else{
            NSString* msg =[jsonDic valueForKey:@"msg"];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:msg];
            
        }
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
