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
    
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    
    //设置属性
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"注册"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"登陆注册" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.view addSubview:self.navView];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.navView), HEIGHT(self.view)-POS_Y(self.navView))];
    
    scrollView.backgroundColor = BackColor;
    [scrollView setContentSize:CGSizeMake(WIDTH(scrollView), HEIGHT(scrollView)+100)];
    
    [self.view addSubview:scrollView];
    
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, 30, WIDTH(self.view), 230)];
    view.backgroundColor = WriteColor;
    view.tag =20001;
    [scrollView addSubview:view];
    
    
    // 忘记密码
    UIImageView* imgView =[[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 15, 15)];
    imgView.image = IMAGENAMED(@"shoujihao");
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imgView];
    
    
    UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10, Y(imgView)-5, 40, 25)];
    label.text =@"手机";
    label.textAlignment = NSTextAlignmentRight;
    [view addSubview:label];
    
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+5, Y(label), WIDTH(self.view)-POS_X(label)-100, 30)];
    self.phoneTextField.tag=1004;
    self.phoneTextField.delegate=self;
    self.phoneTextField.layer.borderWidth = 1;
    self.phoneTextField.font = SYSTEMFONT(16);
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
    imgView.image = IMAGENAMED(@"yanzhengma");
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imgView];
    
    
    label =[[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10, Y(imgView)-5, 40, 25)];
    label.text =@"";
    label.textAlignment = NSTextAlignmentRight;
    [view addSubview:label];
    
    self.codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+5, Y(label), 110, 30)];
    self.codeTextField.tag=1005;
    self.codeTextField.delegate=self;
    self.codeTextField.layer.borderWidth = 1;
    self.codeTextField.font = SYSTEMFONT(16);
    self.codeTextField.placeholder = @"请输入验证码";
    self.codeTextField.returnKeyType = UIReturnKeyDone;
    self.codeTextField.borderStyle =UITextBorderStyleNone;
    self.codeTextField.layer.shadowColor=WriteColor.CGColor;
    self.codeTextField.layer.borderColor = WriteColor.CGColor;
    self.codeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:self.codeTextField];
    
    self.codeButton = [[JKCountDownButton alloc]initWithFrame:CGRectMake(POS_X(self.codeTextField), Y(self.codeTextField)-5, 90, 35)];
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.cornerRadius = 5;
    [self.codeButton.titleLabel setFont:SYSTEMFONT(13)];
    self.codeButton.layer.borderColor = ColorTheme.CGColor;
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:ColorTheme forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(sendCode:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.codeButton];
    
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
    
    self.passTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+5, Y(label), WIDTH(self.phoneTextField), 30)];
    self.passTextField.tag=1004;
    self.passTextField.delegate=self;
    self.passTextField.layer.borderWidth = 1;
    self.passTextField.secureTextEntry = YES;
    self.passTextField.font = SYSTEMFONT(16);
    self.passTextField.placeholder = @"请输入密码";
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
    self.passRepeatTextField.secureTextEntry = YES;
    self.passRepeatTextField.font = SYSTEMFONT(16);
    self.passRepeatTextField.placeholder = @"请重复密码";
    self.passRepeatTextField.returnKeyType = UIReturnKeyDone;
    self.passRepeatTextField.borderStyle =UITextBorderStyleNone;
    self.passRepeatTextField.layer.shadowColor=WriteColor.CGColor;
    self.passRepeatTextField.layer.borderColor = WriteColor.CGColor;
    self.passRepeatTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passRepeatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passRepeatTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:self.passRepeatTextField];
    
    
    self.configBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(view)+30, WIDTH(self.view)-60, 40)];
    self.configBtn.layer.cornerRadius = 5;
    [self.configBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.configBtn addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.configBtn.layer setBorderWidth:1];
    [self.configBtn.layer setBorderColor:ColorTheme.CGColor];
    [self.configBtn setTitleColor:ColorTheme forState:UIControlStateNormal];
    [scrollView addSubview:self.configBtn];
    
    
    //初始化网络请求对象
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

             NSString* serverUrl = [SEND_MESSAGE_CODE stringByAppendingFormat:@"1/0/"];
            [httpUtils getDataFromAPIWithOps:serverUrl postParam:[NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"tel", nil] type:0 delegate:self sel:@selector(requestSendeCode:)];
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
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(self.configBtn)/3-18, HEIGHT(self.configBtn)/2-15, 30, 30)];//指定进度轮的大小
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        [self.configBtn addSubview:activity];
    }else{
        if (!activity.isAnimating) {
            [activity startAnimating];
        }
    }
    [activity setColor:ColorTheme];
    
    //开始加载动画
    [activity startAnimating];
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
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
