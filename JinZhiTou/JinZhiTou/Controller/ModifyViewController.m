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
    UITextField* textField;
    UIScrollView* scrollView;
}
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    
    //==============================导航栏属性区域设置开始==============================//
    self.navView.imageView.alpha=1;
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"设置" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.navView.rightButton setImage:nil forState:UIControlStateNormal];
    [self.navView.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(save:)]];
    
    //==============================导航栏属性区域设置开始==============================//
    
    
    //==============================滚动视图开始==============================//
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    scrollView.backgroundColor = WriteColor;
    
    [self.view addSubview:scrollView];
    //==============================滚动视图开始==============================//
    
    //==============================滚动视图内容设置开始==============================//
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 50, 40)];
    [TDUtil setLabelMutableText:label content:@"姓名" lineSpacing:0 headIndent:0];
    label.font = SYSTEMFONT(16);
    [scrollView addSubview:label];
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    //输入姓名
    textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+5, Y(label)-10, WIDTH(self.view)-POS_X(label)-90, 40)];
    textField.font = SYSTEMFONT(16);
    textField.placeholder = @"请输入昵称";
    textField.text = [data valueForKey:USER_STATIC_NICKNAME];
    textField.returnKeyType = UIReturnKeyDone;
    textField.borderStyle =UITextBorderStyleNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.delegate = self;
    [scrollView addSubview:textField];
    //==============================滚动视图内容开始==============================//

    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(textField), POS_Y(textField)-10, WIDTH(textField), 1)];
    imgView.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
    [scrollView addSubview:imgView];
    
}

-(void)save:(id)sender
{
    //收起键盘
    [textField resignFirstResponder];
    NSString* name = textField.text;
    if (![TDUtil isValidString:name]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入您昵称"];
    }else{
        [self.httpUtil getDataFromAPIWithOps:NICKNAME postParam:[NSDictionary dictionaryWithObject:name forKey:@"nickname"] type:0 delegate:self sel:@selector(requestSave:)];
        
        //[self.httpUtil getDataFromAPIWithOps:HOME_CREDIT postParam:[NSDictionary dictionaryWithObject:name forKey:@"wd"] type:0 delegate:self sel:@selector(requestSave:)];
        self.startLoading = YES;
        self.isTransparent  =YES;
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
        NSString* code =[dic valueForKey:@"code"];
        if ([code integerValue]==0) {
            NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
            [data setValue:textField.text forKey:USER_STATIC_NICKNAME];
            [self back:nil];
        }
        self.startLoading =NO;
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
