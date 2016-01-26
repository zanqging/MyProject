//
//  FinialAuthViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "WeChatBindController.h"
#import "APService.h"
#import "ZHPickView.h"
#import "UIImageView+WebCache.h"
#import "UserInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MMExampleDrawerVisualStateManager.h"

@interface WeChatBindController ()<UIScrollViewDelegate,UITextFieldDelegate,ZHPickViewDelegate>
{
    BOOL isHidePassword;
    UIButton* btnAction;
    UITextField* IDTextField;
    UIScrollView* scrollView;
    UITextField* nameTextField;
    UITextField* positionTextField;
    UITextField* companyTextField;
    UITextField* addressTextField;
    UIActivityIndicatorView* activity;
}
@end

@implementation WeChatBindController
@synthesize nameTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
    //网络初始化
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"手机绑定"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self addPersonalView];

}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addPersonalView
{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    scrollView.tag =40001;
    scrollView.delegate=self;
    scrollView.bounces = NO;
    scrollView.backgroundColor=BackColor;
    scrollView.contentSize = CGSizeMake(WIDTH(scrollView), HEIGHT(scrollView));
    [self.view addSubview:scrollView];
    UIView* view;
    UILabel* label;
    //填写信息
    view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(self.view)-20, 240)];
    view.tag = 30001;
    view.layer.cornerRadius=5;
    view.backgroundColor  =WriteColor;
    [scrollView addSubview:view];
    UIImageView* headerView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-50, 20, 100, 100)];
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    
    NSString* str = [data valueForKey:USER_STATIC_HEADER_PIC];
    [headerView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:IMAGENAMED(@"coremember") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [TDUtil saveCameraPicture:image fileName:STATIC_USER_DEFAULT_PIC];
    }];
    headerView.contentMode = UIViewContentModeScaleAspectFill;
    headerView.layer.cornerRadius = 50;
    headerView.layer.masksToBounds  =YES;
    [view addSubview:headerView];
    
    
    //姓名
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(headerView)+20, WIDTH(scrollView)*1/6, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"手机号";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入姓名
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollView)*2/3-20, 30)];
    nameTextField.font  =SYSTEMFONT(16);
    nameTextField.tag = 500001;
    nameTextField.delegate = self;
    nameTextField.placeholder  =@"请输入手机号";
//    nameTextField.text = [data valueForKey:USER_STATIC_NICKNAME];
    nameTextField.returnKeyType = UIReturnKeyDone;
    nameTextField.layer.borderColor =ColorTheme.CGColor;
    nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:nameTextField];
    
    UIImageView* lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(nameTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label)+10, WIDTH(label), 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"验证码";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    IDTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(nameTextField)-50, 30)];
    IDTextField.tag = 500002;
    IDTextField.delegate = self;
    IDTextField.font  =SYSTEMFONT(16);
    IDTextField.placeholder = @"请输入验证码";
    IDTextField.returnKeyType = UIReturnKeyDone;
    IDTextField.layer.borderColor =ColorTheme.CGColor;
    IDTextField.keyboardType = UIKeyboardTypeDecimalPad;
    IDTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    IDTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    IDTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:IDTextField];
    
    self.codeButton = [[JKCountDownButton alloc]initWithFrame:CGRectMake(POS_X(IDTextField), Y(IDTextField)-5, 90, 35)];
    self.codeButton.layer.borderWidth = 1;
    self.codeButton.layer.cornerRadius = 5;
    [self.codeButton.titleLabel setFont:SYSTEMFONT(13)];
    self.codeButton.layer.borderColor = FONT_COLOR_GRAY.CGColor;
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.codeButton];
    
    __block WeChatBindController * cSelf = self;
    [self.codeButton addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
        
        NSString* phoneNumber = cSelf.nameTextField.text;
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
    

    
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(IDTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label)+10, WIDTH(label), 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"密  码";
    label.tag=20001;
    label.font = SYSTEMFONT(16);
    label.alpha=0;
    [view addSubview:label];
    
    //输入职位
    addressTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(nameTextField), 30)];
    addressTextField.alpha=0;
    addressTextField.tag = 500002;
    addressTextField.delegate = self;
    addressTextField.secureTextEntry  =YES;
    addressTextField.font  =SYSTEMFONT(16);
    addressTextField.placeholder = @"请输入密码";
    addressTextField.returnKeyType = UIReturnKeyDone;
    addressTextField.layer.borderColor =ColorTheme.CGColor;
    addressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addressTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:addressTextField];
    
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(addressTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    btnAction =[[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(view)+20, WIDTH(scrollView)-60, 35)];
    btnAction.layer.cornerRadius =5;
    btnAction.backgroundColor =AppColorTheme;
    [btnAction setTitle:@"确定绑定" forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(doRegistAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnAction];
}

-(void)sendMessage:(id)sender
{
    [self resignKeyboard];
    NSString* phoneNumber =self.nameTextField.text;
    if (phoneNumber) {
        if ([TDUtil validateMobile:phoneNumber]) {
            NSString* serverUrl = [SEND_MESSAGE_CODE stringByAppendingFormat:@"0/1/"];
            [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:[NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"tel",self.openId,@"openid",nil] type:0 delegate:self sel:@selector(requestSendeCode:)];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码格式不正确"];
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"手机号码不能为空"];
    }
}
/**
 *  绑定手机号码
 *
 *  @param sender
 *
 *  @return
 */
- (BOOL)doRegistAction:(id)sender {
    
    [self resignKeyboard];
    //注册
    NSString* code  =IDTextField.text;
    NSString* password = addressTextField.text;
    NSString* phoneNumber =self.nameTextField.text;
    
    
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
    
    if (!isHidePassword) {
        if (!password || [password isEqualToString:@""]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入密码"];
            return NO;
        }
    }
    
    //加密
    password = [TDUtil encryptPhoneNumWithMD5:phoneNumber passString:password];
    
    NSString* regId = [APService registrationID];
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    
    NSDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:code forKey:@"code"];
    [dic setValue:[data valueForKey:USER_STATIC_NICKNAME] forKey:@"nickname"];
    [dic setValue:regId forKey:@"regid"];
    [dic setValue:phoneNumber forKey:@"tel"];
    [dic setValue:self.openId forKey:@"openid"];
    if (!isHidePassword) {
        [dic setValue:password forKey:@"passwd"];
    }
    [dic setValue:@"2.1.0" forKey:@"version"];
    //ios 使用：1，Android 使用:2；
    NSString* serverUrl = [USER_REGIST stringByAppendingString:@"1/"];
    
    //加载动画
    //加载动画控件
    if (!activity) {
        //进度
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(WIDTH(btnAction)/3-30,HEIGHT(btnAction)/2-15, 30, 30)];//指定进度轮的大小
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];//设置进度轮显示类型
        [btnAction addSubview:activity];
    }else{
        if (!activity.isAnimating) {
            [activity startAnimating];
        }
    }
    [activity setColor:ColorTheme];
    
    //开始加载动画
    [activity startAnimating];
    
    
//    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:dic type:0 delegate:self sel:@selector(requestRegiste:)];
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:dic file:STATIC_USER_DEFAULT_PIC postName:@"file" type:0 delegate:self sel:@selector(requestRegiste:)];
    return YES;
}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray=dataArray;
}

//*********************************************************网络请求开始*****************************************************//
-(void)requestUserInfo:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    
    if (dic!=nil) {
        NSString* code =[dic valueForKey:@"code"];
        if ([code integerValue]==0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
        }
    }
}

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
            NSString* flag = [[jsonDic valueForKey:@"data"] valueForKey:@"flag"];
            if ([flag boolValue]) {
                UIView* view = [scrollView viewWithTag:30001];
                UILabel* label = [view viewWithTag:20001];
                [UIView animateWithDuration:1 animations:^(void){
                    label.alpha=1;
                    addressTextField.alpha=1;
                    [view setFrame:CGRectMake(X(view), Y(view), WIDTH(view), HEIGHT(view)+40)];
                    [btnAction setFrame:CGRectMake(30, POS_Y(view)+20, WIDTH(scrollView)-60, 35)];
                }];
            }else{
                isHidePassword =YES;
            }
        }else{
            if ([code intValue] == 1) {
                [self.codeButton stop];
            }
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            [self.codeButton stop];
        }
    }
}
-(void)requestRegiste:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
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
            [data setValue:@"YES" forKey:@"isLogin"];
            [data setValue:self.nameTextField.text forKey:STATIC_USER_DEFAULT_DISPATCH_PHONE];
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
            [self removeFromParentViewController];
        }else{
            NSString* msg =[jsonDic valueForKey:@"msg"];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:msg];
        }
        [activity stopAnimating];
    }
    
}

//*********************************************************网络请求结束*****************************************************//

#pragma pickviewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    addressTextField.text  =[NSString stringWithFormat:@"%@ %@",pickView.state,pickView.city];
}

//*********************************************************UiTextField *****************************************************//
#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   [scrollView setContentOffset:CGPointMake(0, 30)];
}

-(void)resignKeyboard
{
    //收起键盘
    //收起键盘
    UIView* view = [scrollView viewWithTag:30001];
    for (UIView * v in view.subviews){
        if (v.class ==  UITextField.class) {
            [(UITextField*)v resignFirstResponder];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    [scrollView setContentOffset:CGPointMake(0, 0)];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
     [scrollView setContentOffset:CGPointMake(0, 0)];
    return YES;
}

-(void)textFieldDidChange:(id)sender
{
    
}
//*********************************************************UITextField*****************************************************//

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
