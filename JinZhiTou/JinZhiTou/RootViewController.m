//
//  RootViewController.m
//  JinZhiTou
//
//  Created by air on 15/11/3.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "RootViewController.h"
@interface RootViewController ()
{
    LoadingView* loadingView;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化网络请求对象
    self.httpUtil  =[[HttpUtils alloc]init];
    //导航栏设置
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    [self.navView setTitle:self.title];
    self.navView.imageView.alpha  = 0;
    self.navView.titleLable.textColor=WriteColor;
    [self.view addSubview:self.navView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  网络请求错误
 *
 *  @param isNetRequestError 是否网络请求错误
 */
-(void)setIsNetRequestError:(BOOL)isNetRequestError
{
    self->_isNetRequestError = isNetRequestError;
    if (self.isNetRequestError) {
        if (!loadingView) {
            loadingView = [LoadingUtil shareinstance:self.view];
            loadingView.delegate  =self;
        }
        loadingView.isTransparent  = NO;
        loadingView.isError = YES;
    }else{
        [LoadingUtil close:loadingView];
        loadingView.isError = NO;
        loadingView.isTransparent  = YES;
    }
}

-(void)setStartLoading:(BOOL)startLoading
{
    self->_startLoading  = startLoading;
    if (self.startLoading) {
        if (!loadingView) {
            loadingView = [LoadingUtil shareinstance:self.view];
            loadingView.delegate  =self;
        }
        [LoadingUtil show:loadingView];
    }else{
        [LoadingUtil close:loadingView];
    }
}

-(void)setIsTransparent:(BOOL)isTransparent
{
    self->_isTransparent  =isTransparent;
    loadingView.isTransparent  =isTransparent;
}


- (void)viewWillAppear:(BOOL)animated { [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:self.navView.title];
}

- (void)viewWillDisappear:(BOOL)animated { [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:self.navView.title];
}

//==============================网络请求处理开始==============================//
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    self.isNetRequestError = YES;
}
//==============================网络请求处理结束==============================//


-(void)refresh
{

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
