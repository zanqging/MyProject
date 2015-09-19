//
//  RegisteViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RegisteViewController.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "MMDrawerController.h"
#import "PrivacyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserInfoViewController.h"
#import "UserInfoViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
@interface RegisteViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    UIScrollView* scrollView;
    HttpUtils* httpUtils;
}
@property(retain,nonatomic)MMDrawerController* drawerController;
@end

@implementation RegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ColorTheme;
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"注册"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"登陆注册" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.view addSubview:self.navView];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.navView), HEIGHT(self.view)-POS_Y(self.navView))];
    scrollView.backgroundColor = BackColor;
    [self.view addSubview:scrollView];
    
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, 30, WIDTH(self.view), 230)];
    view.backgroundColor = WriteColor;
    view.tag =20001;
    [scrollView addSubview:view];
    
    
    // 忘记密码
    UIImageView* imgView =[[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 15, 15)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = IMAGENAMED(@"shoujihao");
    [view addSubview:imgView];
    
    
    UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10, Y(imgView)-5, 40, 25)];
    label.textAlignment = NSTextAlignmentRight;
    label.text =@"手机";
    [view addSubview:label];
    
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+5, Y(label), WIDTH(self.view)-POS_X(label)-5, 30)];
    self.phoneTextField.tag=1004;
    self.phoneTextField.delegate=self;
    self.phoneTextField.font = SYSTEMFONT(16);
    self.phoneTextField.layer.borderWidth = 1;
    self.phoneTextField.placeholder = @"请输入您的手机号";
    self.phoneTextField.returnKeyType = UIReturnKeyDone;
    self.phoneTextField.borderStyle =UITextBorderStyleNone;
    self.phoneTextField.textColor =BACKGROUND_LIGHT_GRAY_COLOR;
    self.phoneTextField.layer.borderColor = WriteColor.CGColor;
    self.phoneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.phoneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [view addSubview:self.phoneTextField];
    
    UIImageView* lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(label), POS_Y(self.phoneTextField)+10, WIDTH(self.view)-X(label)-20, 1)];
    lineImgView.backgroundColor = BackColor;
    [view addSubview:lineImgView];
    
    
    imgView =[[UIImageView alloc]initWithFrame:CGRectMake(X(imgView), POS_Y(self.phoneTextField)+30, 15, 15)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = IMAGENAMED(@"yanzhengma");
    [view addSubview:imgView];
    
    
    label =[[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10, Y(imgView)-5, 40, 25)];
    label.textAlignment = NSTextAlignmentRight;
    label.text =@"";
    [view addSubview:label];
    
    self.codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+5, Y(label), 110, 30)];
    self.codeTextField.tag=1005;
    self.codeTextField.placeholder = @"请输入验证码";
    self.codeTextField.delegate=self;
    self.codeTextField.font = SYSTEMFONT(16);
    self.codeTextField.layer.borderWidth = 1;
    self.codeTextField.layer.shadowColor=WriteColor.CGColor;
    self.codeTextField.layer.borderColor = WriteColor.CGColor;
    self.codeTextField.returnKeyType = UIReturnKeyDone;
    self.codeTextField.borderStyle =UITextBorderStyleNone;
    self.codeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:self.codeTextField];
    
    self.codeButton = [[JKCountDownButton alloc]initWithFrame:CGRectMake(POS_X(self.codeTextField), Y(self.codeTextField)-5, 90, 35)];
    self.codeButton.layer.cornerRadius = 5;
    self.codeButton.layer.borderWidth = 1;
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton.titleLabel setFont:SYSTEMFONT(13)];
    self.codeButton.layer.borderColor = ColorTheme.CGColor;
    [self.codeButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.codeButton setTitleColor:ColorTheme forState:UIControlStateNormal];
    [view addSubview:self.codeButton];
    
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
    
    
    lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(label), POS_Y(self.codeTextField)+10, WIDTH(self.view)-X(label)-20, 1)];
    lineImgView.backgroundColor = BackColor;
    [view addSubview:lineImgView];
    
    
    
    imgView =[[UIImageView alloc]initWithFrame:CGRectMake(X(imgView), POS_Y(self.codeButton)+30, 15, 15)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = IMAGENAMED(@"shurumima");
    [view addSubview:imgView];
    
    
    label =[[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10, Y(imgView)-5, 40, 25)];
    label.textAlignment = NSTextAlignmentRight;
    label.text =@"密码";
    [view addSubview:label];

    self.passTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+5, Y(label), WIDTH(self.view)-POS_X(label)-5, 30)];
    self.passTextField.tag=1004;
    self.passTextField.delegate=self;
    self.passTextField.font = SYSTEMFONT(16);
    self.passTextField.placeholder = @"请输入密码";
    self.passTextField.layer.borderWidth = 1;
    self.passTextField.secureTextEntry = YES;
    self.passTextField.returnKeyType = UIReturnKeyDone;
    self.passTextField.borderStyle =UITextBorderStyleNone;
    self.passTextField.layer.shadowColor=WriteColor.CGColor;
    self.passTextField.layer.borderColor = WriteColor.CGColor;
    self.passTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:self.passTextField];
    
    lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(label), POS_Y(self.passTextField)+10, WIDTH(self.view)-X(label)-20, 1)];
    lineImgView.backgroundColor = BackColor;
    [view addSubview:lineImgView];
    

    self.passRepeatTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+5, POS_Y(self.passTextField)+20, WIDTH(self.phoneTextField), HEIGHT(self.phoneTextField))];
    self.passRepeatTextField.tag=1004;
    self.passRepeatTextField.delegate=self;
    self.passRepeatTextField.layer.borderWidth = 1;
    self.passRepeatTextField.font = SYSTEMFONT(16);
    self.passRepeatTextField.secureTextEntry = YES;
    self.passRepeatTextField.placeholder = @"请重复密码";
    self.passRepeatTextField.layer.shadowColor=WriteColor.CGColor;
    self.passRepeatTextField.layer.borderColor = WriteColor.CGColor;
    self.passRepeatTextField.returnKeyType = UIReturnKeyDone;
    self.passRepeatTextField.borderStyle =UITextBorderStyleNone;
    self.passRepeatTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passRepeatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passRepeatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:self.passRepeatTextField];

    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0,POS_Y(view)+20, WIDTH(scrollView), 20)];
    label.font = SYSTEMFONT(14);
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"点击“立即注册“意味着您同意 金指投用户协议";
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(protocolAction:)]];
    [scrollView addSubview:label];
    
    
    self.regietButton = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(label)+30, WIDTH(self.view)-60, 40)];
    self.regietButton.backgroundColor= ColorTheme;
    self.regietButton.layer.cornerRadius = HEIGHT(self.regietButton)/2;
    [self.regietButton setTitle:@"立即注册" forState:UIControlStateNormal];
    [self.regietButton addTarget:self action:@selector(doRegistAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.regietButton setTitleColor:WriteColor forState:UIControlStateNormal];
    [scrollView addSubview:self.regietButton];
    
    
    //初始化网络请求对象
    httpUtils = [[HttpUtils alloc]init];
}

-(void)protocolAction:(id)sender
{
    PrivacyViewController* controller = [[PrivacyViewController alloc]init];
    controller.serverUrl = useragreement;
    controller.title = self.navView.title;
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
            [httpUtils getDataFromAPIWithOps:SEND_MESSAGE_CODE postParam:[NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"telephone",@"0",@"flag", nil] type:0 delegate:self sel:@selector(requestSendeCode:)];
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
    //注册
    httpUtils = [[HttpUtils alloc]init];
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
    
    
    password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:password];
    NSDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:code forKey:@"code"];
    [dic setValue:@"1" forKey:@"system"];
    [dic setValue:phoneNumber forKey:@"telephone"];
    [dic setValue:password forKey:@"password"];
    [httpUtils getDataFromAPIWithOps:USER_REGIST postParam:dic type:0 delegate:self sel:@selector(requestRegiste:)];
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
    UIView* view = [scrollView viewWithTag:20001];
    for (UIView * v in view.subviews){
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
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"验证码发送成功!" ];
            NSLog(@"验证码发送成功!");
        }else{
             [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            NSLog(@"验证码发送失败!");
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
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            NSLog(@"注册成功!");
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
            [data setValue:@"YES" forKey:@"isLogin"];
            [data setValue:@"NO" forKey:@"isAnimous"];
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
            NSLog(@"注册失败!");
            
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
