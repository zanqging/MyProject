//
//  BannerViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "BannerViewController.h"
#import "NavView.h"
#import "UConstants.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "GlobalDefine.h"
@interface BannerViewController ()<UIWebViewDelegate>
{
    NavView* navView;
    LoadingView* loadingView;
}
@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor=ColorTheme;
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


-(void)loadUrl
{
    
    NSURLRequest *request =[NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
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
