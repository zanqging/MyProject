//
//  BannerViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "BannerViewController.h"
#import "ShareView.h"
#import "ShareNewsView.h"
@interface BannerViewController ()<UIWebViewDelegate>
{
    BOOL isGetStatus;
    ShareNewsView* shareNewsView;
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
    self.navView.imageView.alpha=1;
    [self.navView setTitle:self.titleStr];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.title forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    if (self.type == 3) {
        [self.navView.rightButton setImage:IMAGENAMED(@"share") forState:UIControlStateNormal];
        [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ShareAction)]];
    }
    [self.view addSubview:self.navView];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
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

-(void)shareNews:(NSNotification*)dic
{
    shareNewsView = [[ShareNewsView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    shareNewsView.dic = self.dic;
    [self.view addSubview:shareNewsView];
}

/**
 *  分享咨询
 */
-(void)ShareAction
{
    UIWindow* window =[UIApplication sharedApplication].windows[0];
    ShareView* shareView =[[ShareView alloc]initWithFrame:window.frame isShareNews:YES];
    shareView.type = 3;
    shareView.projectId = [[self.dic valueForKey:@"id"] integerValue];
    [window addSubview:shareView];
}


-(void)likeAction:(id)sender
{
    
}

-(void)publishContent:(NSNotification*)dic
{
    NSString* content = [[dic valueForKey:@"userInfo"] valueForKey:@"data"];
    NSMutableDictionary* tempDic =[[NSMutableDictionary alloc]init];
    [tempDic setValue:content forKey:@"content"];
    [tempDic setValue:[self.dic valueForKey:@"id"] forKey:@"news"];
    
    
    [self.httpUtil getDataFromAPIWithOps:CYCLE_CONTENT_PUBLISH postParam:tempDic type:0 delegate:self sel:@selector(requestPublishContent:)];
    
    self.startLoading = YES;
    self.isTransparent = YES;
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    self.loadingViewFrame = CGRectMake(0, POS_X(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_X(self.navView));
    self.startLoading = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.startLoading =NO;
    [self.webView.scrollView setContentSize:CGSizeMake(WIDTH(self.webView.scrollView), self.webView.scrollView.contentSize.height + 80)];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
    self.isNetRequestError = YES;
}

-(void)refresh
{
    [super refresh];

    [self loadUrl];
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shareNews:) name:@"shareNews" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishContent:) name:@"shareNewContent" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shareNews" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shareNewContent" object:nil];
}
-(void)dealloc
{
    self.webView = nil;
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

-(void)requestPublishContent:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue] == 0) {
            [shareNewsView removeFromSuperview];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
        }
        self.startLoading = NO;
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
    }
}
@end
