//
//  FinialAuthViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserInfoConfigController.h"
#import "ZHPickView.h"
#import <QuartzCore/QuartzCore.h>

@interface UserInfoConfigController ()<UIScrollViewDelegate,UITextFieldDelegate,ZHPickViewDelegate>
{
    ZHPickView* pickview;
    UITextField* IDTextField;
    UIScrollView* scrollView;
    UITextField* nameTextField;
    UITextField* positionTextField;
    UITextField* companyTextField;
    UITextField* addressTextField;;
}
@end

@implementation UserInfoConfigController

- (void)viewDidLoad {
    [super viewDidLoad];
    //网络初始化
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"完善信息"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.navView.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commitData)]];
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
    
    //姓名
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH(scrollView)*1/4, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"真实姓名";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入姓名
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollView)*2/3-20, 30)];
    nameTextField.font  =SYSTEMFONT(16);
    nameTextField.tag = 500001;
    nameTextField.delegate = self;
    nameTextField.placeholder = @"请输入真实姓名";
    nameTextField.returnKeyType = UIReturnKeyDone;
    nameTextField.layer.borderColor =ColorTheme.CGColor;
    nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:nameTextField];
    
    UIImageView* lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(nameTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(label), 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"身份证号";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    IDTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(nameTextField), 30)];
    IDTextField.tag = 500002;
    IDTextField.delegate = self;
    IDTextField.font  =SYSTEMFONT(16);
    IDTextField.placeholder = @"请输入身份证号";
    IDTextField.returnKeyType = UIReturnKeyDone;
    IDTextField.layer.borderColor =ColorTheme.CGColor;
    IDTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    IDTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    IDTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:IDTextField];
    
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(IDTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(label), 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"现住地址";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    addressTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(nameTextField), 30)];
    addressTextField.tag = 500003;
    addressTextField.delegate = self;
    addressTextField.font  =SYSTEMFONT(16);
    addressTextField.placeholder = @"请输入现住地址";
    addressTextField.returnKeyType = UIReturnKeyDone;
    addressTextField.layer.borderColor =ColorTheme.CGColor;
    addressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addressTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:addressTextField];
    
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(addressTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(label), 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"公司名称";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    companyTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(nameTextField), 30)];
    companyTextField.tag = 500004;
    companyTextField.delegate = self;
    companyTextField.font  =SYSTEMFONT(16);
    companyTextField.placeholder = @"请输入公司名称";
    companyTextField.returnKeyType = UIReturnKeyDone;
    companyTextField.layer.borderColor =ColorTheme.CGColor;
    companyTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    companyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    companyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:companyTextField];
    
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(companyTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(label), 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"担任职位";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    positionTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(nameTextField), 30)];
    positionTextField.tag = 500005;
    positionTextField.delegate = self;
    positionTextField.font  =SYSTEMFONT(16);
    positionTextField.placeholder = @"请输入现任职位";
    positionTextField.returnKeyType = UIReturnKeyDone;
    positionTextField.layer.borderColor =ColorTheme.CGColor;
    positionTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    positionTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    positionTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:positionTextField];
    
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(positionTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    
//    UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(60, POS_Y(view)+20, WIDTH(scrollView)-120, 35)];
//    btnAction.layer.cornerRadius =5;
//    btnAction.backgroundColor = ColorTheme;
//    [btnAction setTitle:@"提交资料" forState:UIControlStateNormal];
//    [btnAction addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:btnAction];
}


-(BOOL)commitData
{
//    if (!isUploadID) {
//        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请先上传身份证" ];
//        return NO;
//    }
    NSString* userName;
    NSString* userType;
    NSString* company;
    NSString* IDNumber;
    NSString* address;
    
    IDNumber  =IDTextField.text;
    userName = nameTextField.text;
    address  =addressTextField.text;
    company  = companyTextField.text;
    userType = positionTextField.text;
    
    if (![TDUtil isValidString:userName]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:nameTextField.placeholder];
        return NO;
    }
    
    if (![TDUtil isValidString:IDNumber]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:IDTextField.placeholder];
        return NO;
    }else{
        if (![TDUtil validateIdentityCard:IDNumber]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"身份证号输入错误"];
            return NO;
        }
    }
    
    if (![TDUtil isValidString:address]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:addressTextField.placeholder];
        return NO;
    }
    
    if (![TDUtil isValidString:company]) {
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:companyTextField.placeholder];
        return NO;
    }
    if (![TDUtil isValidString:userType]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:positionTextField.placeholder];
        return NO;
    }
    
    
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc]init];
    [dataDic setValue:address forKey:@"addr"];
    [dataDic setValue:userName forKey:@"name"];
    [dataDic setValue:IDNumber forKey:@"idno"];
    [dataDic setValue:company forKey:@"company"];
    [dataDic setValue:userType forKey:@"position"];
    
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    [data setValue:userName forKey:USER_STATIC_NAME];
    [data setValue:address forKey:USER_STATIC_ADDRESS];
    [data setValue:IDNumber forKey:USER_STATIC_IDNUMBER];
    [data setValue:company forKey:USER_STATIC_COMPANY_NAME];
    [self.httpUtil getDataFromAPIWithOps:@"userinfo/" postParam:dataDic type:0 delegate:self sel:@selector(requestUserInfo:)];
    
    self.startLoading = YES;
    self.isTransparent = YES;
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
            //本地缓存数据修改
            NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
            [dataStore setValue:@"true" forKey:@"info"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"showAuth" object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:@"viewController"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
        self.startLoading = NO;
    }
    self.isNetRequestError  =YES;
}
//*********************************************************网络请求结束*****************************************************//

#pragma pickviewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    addressTextField.text  =[NSString stringWithFormat:@"%@ %@",pickView.state,pickView.city];
    
    //检测选择器是否已经打开
    if (pickView) {
        pickView.isShow  = NO;
    }
}

//*********************************************************UiTextField *****************************************************//
#pragma UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == addressTextField) {
        [self resignKeyboard];
        [textField resignFirstResponder];
        
        if (!pickview) {
            pickview=[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
            pickview.backgroundColor = ClearColor;
            pickview.delegate=self;
        }
        if (!pickview.isShow) {
            [pickview show];
        }
        return NO;
    }
    return YES;
    
}

-(void)resignKeyboard
{
    //收起键盘
    //收起键盘
    UIView* view = [scrollView viewWithTag:30001];
    for (UIView * v in view.subviews){
        if (v.class ==  UITextField.class) {
            if ([(UITextField*)v isFirstResponder]) {
                [(UITextField*)v resignFirstResponder];
            }
        }
    }
//    [nameTextField resignFirstResponder];
//    [IDTextField resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
//    [textField resignFirstResponder];
     [self resignKeyboard];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [textField resignFirstResponder];
     [self resignKeyboard];
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
