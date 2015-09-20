//
//  BannerViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "BannerViewController.h"
#import "TDUtil.h"
#import "NavView.h"
#import "UConstants.h"
#import "ShareView.h"
#import "HttpUtils.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIHTTPRequest.h"
@interface BannerViewController ()<UIWebViewDelegate,ASIHTTPRequestDelegate>
{
    NavView* navView;
    HttpUtils* httpUtil;
    LoadingView* loadingView;
    
    BOOL isGetStatus;
}
@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor=ColorTheme;
    httpUtil = [[HttpUtils alloc]init];
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:@"详情"];
    navView.titleLable.textColor=WriteColor;
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"微路演" forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    if (self.type == 3) {
        [navView.rightButton setImage:IMAGENAMED(@"share") forState:UIControlStateNormal];
        [navView.rightButton addTarget:self action:@selector(ShareAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:navView];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    loadingView = [LoadingUtil shareinstance:self.view];
    
     [self loadUrl];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUrl:(NSURL *)url
{
    self->_url = url;
    
    [self loadUrl];
}

-(void)setDic:(NSDictionary *)dic
{
    self->_dic  = dic;
    isGetStatus = YES;
    NSString* serverUrl = [NEWS_LIKE stringByAppendingFormat:@"%ld/",(long)[[self.dic valueForKey:@"id"] integerValue]];
    [httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestFinished:)];
    [httpUtil.requestInstance setRequestMethod:@"GET"];
}


-(void)loadUrl
{
    if (!self.webView.loading) {
        NSURLRequest *request =[NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
    
}

-(void)setType:(int)type
{
    self->_type = type;
}



/**
 *  分享咨询
 */
-(void)ShareAction
{
    UIWindow* window =[UIApplication sharedApplication].windows[0];
    ShareView* shareView =[[ShareView alloc]initWithFrame:window.frame];
    shareView.type = 3;
    shareView.projectId = [[self.dic valueForKey:@"id"] integerValue];
    [window addSubview:shareView];
}


-(void)likeAction:(id)sender
{
    NSString* url = [NEWS_LIKE stringByAppendingFormat:@"%ld/",(long)[[self.dic valueForKey:@"id"] integerValue]];
    [httpUtil getDataFromAPIWithOps:url postParam:[NSDictionary dictionaryWithObject:[self.dic valueForKey:@"status"] forKey:@"flag"] type:0 delegate:self sel:@selector(requestFinished:)];
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [LoadingUtil show:loadingView];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [LoadingUtil close:loadingView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
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

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            if (isGetStatus) {
                isGetStatus = NO;
            }
            [self.dic setValue:[[jsonDic valueForKey:@"data"] stringValue] forKey:@"status"];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
}
@end
