//
//  ModifyViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/17.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ModifyViewController.h"
#import "TDUtil.h"
#import "NavView.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
@interface ModifyViewController ()<ASIHTTPRequestDelegate,UITextFieldDelegate>
{
    NavView* navView;
    HttpUtils* httpUtils;
    UITextField* textField;
    UIScrollView* scrollView;
}
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:self.title];
    navView.titleLable.textColor=WriteColor;
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"设置" forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.rightButton setImage:nil forState:UIControlStateNormal];
    [navView.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [navView.rightButton addTarget:self action:@selector(save:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.view addSubview:navView];
    
    //scrollView
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    scrollView.backgroundColor = WriteColor;
    [self.view addSubview:scrollView];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 50, 40)];
    label.text = @"姓名";
    label.font = SYSTEMFONT(16);
    [scrollView addSubview:label];
    
    //输入姓名
    textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+5, Y(label), WIDTH(self.view)-POS_X(label)-60, 40)];
    textField.placeholder = @"请输入真实姓名";
    textField.font = SYSTEMFONT(16);
    textField.returnKeyType = UIReturnKeyDone;
    textField.borderStyle =UITextBorderStyleNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.delegate = self;
    [scrollView addSubview:textField];

    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(textField), POS_Y(textField)+5, WIDTH(textField), 1)];
    imgView.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
    [scrollView addSubview:imgView];
    
    
    //初始化网络请求对象
    httpUtils = [[HttpUtils alloc]init];
}

-(void)save:(id)sender
{
    //收起键盘
    [textField resignFirstResponder];
    NSString* name = textField.text;
    if (![TDUtil isValidString:name]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入姓名"];
    }else{
        [httpUtils getDataFromAPIWithOps:REALNAME postParam:[NSDictionary dictionaryWithObject:name forKey:@"real_name"] type:0 delegate:self sel:@selector(requestSave:)];
    }
    
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(void)resignKeyboard
{
    
}

-(void)textFieldDidEndEditing:(UITextField *)txtField
{
    [txtField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)txtField
{
    [txtField resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(id)sender
{
    
}



-(void)requestSave:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    
    if (dic!=nil) {
        NSString* status =[dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
            [data setValue:textField.text forKey:STATIC_USER_NAME];
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
     [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络请求失败"];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
