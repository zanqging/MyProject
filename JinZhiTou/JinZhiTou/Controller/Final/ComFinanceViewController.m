//
//  ThinkTankViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/16.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ComFinanceViewController.h"
#import "FoldInfoView.h"
#import "CaseFoldInfoView.h"
#import "NSString+SBJSON.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"
#import "ComFinanceFoldInfoView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ComFinanceViewController ()<UIScrollViewDelegate,ASIHTTPRequestDelegate>
{
    ComFinanceFoldInfoView* _infoFoldView1;
    FoldInfoView* _infoFoldView2;
    CaseFoldInfoView* _infoFoldView3;
    NSDictionary* dataDic;
    UIScrollView* scrollView;
}
@property (nonatomic,strong) MPMoviePlayerViewController * moviePlayer;//视频播放控制器
@end

@implementation ComFinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"机构详情"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"投资人" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    //滚动视图
    scrollView =[[UIScrollView alloc]init];
    scrollView.backgroundColor  = BackColor;
    scrollView.bounces = YES;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(WIDTH(self.view), HEIGHT(self.view)+10);
    [self.view addSubview:scrollView];

    _infoFoldView1 = [[ComFinanceFoldInfoView alloc] init];
    [scrollView addSubview:_infoFoldView1];
    
    _infoFoldView1.sd_layout
    .topSpaceToView(scrollView,10)
    .leftSpaceToView(scrollView,10)
    .rightSpaceToView(scrollView,10)
    .heightIs(80);
    
    _infoFoldView2 = [[FoldInfoView alloc] init];
    [scrollView addSubview:_infoFoldView2];
    
    _infoFoldView2.sd_layout
    .topSpaceToView(_infoFoldView1,10)
    .leftEqualToView(_infoFoldView1)
    .rightEqualToView(_infoFoldView1)
    .heightIs(80);
    
    _infoFoldView3 = [[CaseFoldInfoView alloc] init];
    [scrollView addSubview:_infoFoldView3];
    
    _infoFoldView3.sd_layout
    .topSpaceToView(_infoFoldView2,10)
    .leftEqualToView(_infoFoldView2)
    .rightEqualToView(_infoFoldView2)
    .heightIs(130);
    
    scrollView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(POS_Y(self.navView), 0, 0, 0));
    
    [scrollView setupAutoContentSizeWithBottomView:_infoFoldView3 bottomMargin:10];
    

    [self loadThinkTankDetail];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)loadThinkTankDetail
{
    
    NSString* url = [COMDETAIL stringByAppendingFormat:@"%ld/",(long)[[self.dic valueForKey:@"id"] integerValue]];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestThinkTankDetail:)];
    
    //开始显示加载动画
    self.startLoading = YES;
}


-(void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [_moviePlayer.view setFrame:CGRectMake(-kTopBarHeight-kStatusBarHeight-16, kTopBarHeight+kStatusBarHeight+16, HEIGHT(self.view), WIDTH(self.view))];
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(- M_PI_2);
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
    }
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        [_moviePlayer.view setFrame:CGRectMake(-kTopBarHeight-kStatusBarHeight-16, kTopBarHeight+kStatusBarHeight+16, HEIGHT(self.view), WIDTH(self.view))];
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
    }
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        [_moviePlayer.view setFrame:CGRectMake(-kTopBarHeight-kStatusBarHeight-16, kTopBarHeight+kStatusBarHeight+16, HEIGHT(self.view), WIDTH(self.view))];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(0);
    }
    
    if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [_moviePlayer.view setFrame:CGRectMake(0,0,WIDTH(self.view),HEIGHT(self.view))];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2*2);
    }
    
    
    
    if (orientation == UIInterfaceOrientationUnknown) {
        [_moviePlayer.view setFrame:CGRectMake(0,0,WIDTH(self.view),HEIGHT(self.view))];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2*2);
    }
    
    if (orientation == UIInterfaceOrientationPortrait) {
        [_moviePlayer.view setFrame:CGRectMake(0,0,WIDTH(self.view),HEIGHT(self.view))];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(0);
    }
    
}
-(void)playMedia:(id)sender
{
    
    
    NSString* str = [dataDic valueForKey:@"url"];
    
    if (str && ![str isEqualToString:@""]) {
        NSURL* url = [NSURL URLWithString:str];
        NSLog(@"%@",url);
        _moviePlayer = [[MPMoviePlayerViewController alloc]init];
        //        [self.navigationController presentMoviePlayerViewControllerAnimated:_moviePlayer];
        [self.navigationController presentViewController:_moviePlayer animated:YES completion:^(void){
            
        }];
        
        [_moviePlayer.moviePlayer setContentURL:url];
    }
}

/**
 *  重写刷新
 */
-(void)refresh
{
    [super refresh];
    
    //重新加载数据
    [self loadThinkTankDetail];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma ASIHttpRequester
-(void)requestThinkTankDetail:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0 || [code intValue] == -1) {
            dataDic = [jsonDic valueForKey:@"data"];
            
            NSMutableDictionary* dic = [NSMutableDictionary new];
            [dic setValue:[self.dic valueForKey:@"name"] forKey:@"name"];
            [dic setValue:[self.dic valueForKey:@"addr"] forKey:@"addr"];
            [dic setValue:[self.dic valueForKey:@"logo"] forKey:@"logo"];
            [dic setValue:[dataDic valueForKey:@"homepage"] forKey:@"homepage"];
            [dic setValue:[dataDic valueForKey:@"foundingtime"] forKey:@"foundingtime"];
            [dic setValue:[dataDic valueForKey:@"fundsize"] forKey:@"fundsize"];
            [dic setValue:@"plan" forKey:@"img"];
            _infoFoldView1.dic = dic;
            
            dic = [NSMutableDictionary new];
            [dic setValue:@"机构介绍" forKey:@"title"];
            [dic setValue:[dataDic valueForKey:@"profile"] forKey:@"content"];
            [dic setValue:@"introduce" forKey:@"img"];
            _infoFoldView2.dic = dic;
            
            _infoFoldView3.dataArray = [dataDic valueForKey:@"investcase"];
            
//            _infoFoldView4.sd_layout
//            .topSpaceToView(_infoFoldView3,10)
//            .leftEqualToView(_infoFoldView3)
//            .rightEqualToView(_infoFoldView3)
//            .heightIs(500);
            
            self.startLoading = NO;
        }else{
            self.startLoading = YES;
        }
    }else{
        self.startLoading = YES;
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    self.isNetRequestError = YES;
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
