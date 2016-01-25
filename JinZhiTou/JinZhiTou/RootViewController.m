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

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    CGRect rect = CGRectMake(0, 0, WIDTH(self.view), kTopBarHeight+kStatusBarHeight);
//    gradient.frame = rect;
//    gradient.colors = [NSArray arrayWithObjects:(id)ColorTheme.CGColor,
//                       (id)[UIColor colorWithRed:129.0/255 green:129.0/255 blue:129./255 alpha:1].CGColor,nil];
//    [self.view.layer insertSublayer:gradient atIndex:0];
    
    self.view.backgroundColor = ColorTheme;
    //初始化网络请求对象
    self.httpUtil  =[[HttpUtils alloc]init];
    //导航栏设置
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    [self.navView setTitle:self.title];
    self.navView.imageView.alpha  = 0;
    self.navView.titleLable.textColor=WriteColor;
    [self.view addSubview:self.navView];
    
    //改变亮度
//    [self sliderValueChanged:0];
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
            if (self.loadingViewFrame.size.height>0) {
                loadingView =[LoadingUtil shareinstance:self.view frame:self.loadingViewFrame];
            }else{
                loadingView = [LoadingUtil shareinstance:self.view];
            }
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
            if (self.loadingViewFrame.size.height>0) {
                loadingView =[LoadingUtil shareinstance:self.view frame:self.loadingViewFrame];
            }else{
                loadingView = [LoadingUtil shareinstance:self.view];
            }
            loadingView.delegate  =self;
        }else{
            if (self.loadingViewFrame.size.height>0) {
                [loadingView setFrame:self.loadingViewFrame];
            }
        }
        
        self.isNetRequestError  =NO;
        loadingView.isTransparent  = NO;
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

-(void)setLoadingViewFrame:(CGRect)loadingViewFrame
{
    self->_loadingViewFrame =loadingViewFrame;
    
}

-(void)setContent:(NSString *)content
{
    self->_content  =content;
    if ([TDUtil isValidString:self.content]) {
        loadingView.content  = self.content;
    }
}

- (void)viewWillAppear:(BOOL)animated { [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:self.navView.title];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated { [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:self.navView.title];
}

-(void)setDataDic:(NSMutableDictionary *)dataDic
{
    self->_dataDic = dataDic;
    if (self.dataDic) {
        int code = [[dataDic valueForKey:@"code"] intValue];
        //设置状态码
        [self setCode:code];
    }
}
-(void)setCode:(int)code
{
    self->_code = code;
    switch (self.code) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case -1:
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
            break;
        default:
            break;
    }
}

//==============================网络请求处理开始==============================//
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    self.startLoading =NO;
    //self.isNetRequestError = YES;
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    //self.startLoading =NO;
    self.isNetRequestError = YES;
    
}
//==============================网络请求处理结束==============================//

-(void)resetLoadingView
{
    [self.view bringSubviewToFront:loadingView];
}

-(void)refresh
{
    self.startLoading = YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
