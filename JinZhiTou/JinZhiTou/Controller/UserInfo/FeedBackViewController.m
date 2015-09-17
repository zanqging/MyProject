//
//  FeedBackViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/7.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FeedBackViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
@interface FeedBackViewController ()<UITextViewDelegate,ASIHTTPRequestDelegate>
{
    HttpUtils* httpUtils;
    LoadingView* loadingView;
}
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"在线反馈"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"设置" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.view addSubview:self.navView];
    
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    view.backgroundColor =BackColor;
    [self.view addSubview:view];
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(self.view)-20, 150)];
    self.textView.text =@"请输入您宝贵的意见、建议";
    self.textView.delegate = self;
    self.textView.font = SYSTEMFONT(16);
    [view addSubview:self.textView];
    self.sendButton = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(self.textView)+20, WIDTH(self.view)-60, 35)];
    self.sendButton.layer.cornerRadius =5;
    self.sendButton.backgroundColor = ColorTheme;
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendFeedBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton setTitleColor:WriteColor forState:UIControlStateNormal];
    [view addSubview:self.sendButton];
    
}

-(void)sendFeedBack:(id)sender
{
    httpUtils = [[HttpUtils alloc]init];
    loadingView = [LoadingUtil shareinstance:self.view];
    loadingView.isTransparent = YES;
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    
    NSString* text = self.textView.text;
    if ([TDUtil isValidString:text]) {
        [httpUtils getDataFromAPIWithOps:FEEDBACK postParam:[NSDictionary dictionaryWithObject:self.textView.text forKey:@"advice"] type:0 delegate:self sel:@selector(requestFeedBack:)];
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入反馈信息"];
    }
    
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSString* str = textView.text;
    if ([str  isEqualToString:@"请输入您宝贵的意见、建议"]) {
        textView.text = @"";
    }
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSString* str = textView.text;
    if ([str  isEqualToString:@""]) {
        textView.text = @"请输入您宝贵的意见、建议";
    }
    [textView resignFirstResponder];
}

#pragma ASIHttpRequester
//===========================================================网络请求=====================================
-(void)requestFeedBack:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            [LoadingUtil closeLoadingView:loadingView];
        }
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
    loadingView.isError = YES;
    loadingView.content =@"网络连接失败!";
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
