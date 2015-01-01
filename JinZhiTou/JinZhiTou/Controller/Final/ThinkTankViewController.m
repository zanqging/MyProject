//
//  ThinkTankViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/16.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ThinkTankViewController.h"
#import "FoldInfoView.h"
#import "NSString+SBJSON.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ThinkTankViewController ()<UIScrollViewDelegate,ASIHTTPRequestDelegate>
{
    FoldInfoView* _infoFoldView1;
    FoldInfoView* _infoFoldView2;
    FoldInfoView* _infoFoldView3;
    FoldInfoView* _infoFoldView4;
    NSDictionary* dataDic;
    UIScrollView* scrollView;
}
@property (nonatomic,strong) MPMoviePlayerViewController * moviePlayer;//视频播放控制器
@end

@implementation ThinkTankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"智囊团详情"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"智囊团" forState:UIControlStateNormal];
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
    
    //头部
    UIView* view = [[UIView alloc]init];
    view.tag = 10001;
    view.backgroundColor  = WriteColor;
    view.userInteractionEnabled = YES;
    [scrollView addSubview:view];
    
    view.sd_layout
    .topEqualToView(scrollView)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(170);
    
    //背景
    UIImageView* imgView = [[UIImageView alloc]init];
    imgView.backgroundColor = BlackColor;
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [imgView sd_setImageWithURL:[self.dic valueForKey:@"photo"] placeholderImage:IMAGENAMED(@"coremember") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
        [imgView setContentMode:UIViewContentModeScaleToFill];
    }];
    
    [view addSubview:imgView];
    
    imgView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    
    //身份
    _infoFoldView1 = [[FoldInfoView alloc] init];
    [scrollView addSubview:_infoFoldView1];
    
    _infoFoldView1.sd_layout
    .topSpaceToView(view,10)
    .leftSpaceToView(scrollView,10)
    .rightSpaceToView(scrollView,10)
    .heightIs(80);
    
    //寄语
    _infoFoldView2 = [[FoldInfoView alloc] init];
    [scrollView addSubview:_infoFoldView2];
    
    _infoFoldView2.sd_layout
    .topSpaceToView(_infoFoldView1,10)
    .leftEqualToView(_infoFoldView1)
    .rightEqualToView(_infoFoldView1)
    .heightIs(80);
    
    //个人介绍
    _infoFoldView3 = [[FoldInfoView alloc] init];
    [scrollView addSubview:_infoFoldView3];
    
    _infoFoldView3.sd_layout
    .topSpaceToView(_infoFoldView2,10)
    .leftEqualToView(_infoFoldView2)
    .rightEqualToView(_infoFoldView2)
    .heightIs(200);
    
    //投辅案例
    _infoFoldView4 = [[FoldInfoView alloc] init];
    [scrollView addSubview:_infoFoldView4];
    
    _infoFoldView4.sd_layout
    .topSpaceToView(_infoFoldView3,10)
    .leftEqualToView(_infoFoldView3)
    .rightEqualToView(_infoFoldView3)
    .heightIs(250);
    
    scrollView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(POS_Y(self.navView), 0, 0, 0));
    
    [scrollView setupAutoContentSizeWithBottomView:_infoFoldView4 bottomMargin:10];
    
    
    [self loadThinkTankDetail];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)loadThinkTankDetail
{
    
    NSString* url = [THINK_DETAIL stringByAppendingFormat:@"%ld/",(long)[[self.dic valueForKey:@"id"] integerValue]];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestThinkTankDetail:)];
    
    //开始执行加载动画
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

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refresh
{
    [super refresh];
    
    //重新加载数据
    [self loadThinkTankDetail];
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
            
            NSString* url = [dataDic valueForKey:@"video"];
            if ([TDUtil isValidString:url]) {
                //播放按钮
                CGRect frame =CGRectMake(10, 10, WIDTH(scrollView)-20, 150);
                UIImageView* imgPlay = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-10, frame.size.height/2-10, 40, 40)];
                imgPlay.image = IMAGENAMED(@"bofang");
                imgPlay.contentMode = UIViewContentModeScaleAspectFill;
                UIView* view = [scrollView viewWithTag:10001];
                [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playMedia:)]];
                [view addSubview:imgPlay];
            }
            
            NSMutableDictionary* dic = [NSMutableDictionary new];
            [dic setValue:@"身份" forKey:@"title"];
            [dic setValue:[self.dic valueForKey:@"position"] forKey:@"content"];
            [dic setValue:@"plan" forKey:@"img"];
            _infoFoldView1.dic = dic;
            
            dic = [NSMutableDictionary new];
            [dic setValue:@"寄语" forKey:@"title"];
            [dic setValue:[dataDic valueForKey:@"signature"] forKey:@"content"];
            [dic setValue:@"comment" forKey:@"img"];
            _infoFoldView2.dic = dic;
            
            dic = [NSMutableDictionary new];
            [dic setValue:@"个人介绍" forKey:@"title"];
            [dic setValue:[dataDic valueForKey:@"experience"] forKey:@"content"];
            [dic setValue:@"introduce" forKey:@"img"];
            _infoFoldView3.dic = dic;
            
            dic = [NSMutableDictionary new];
            [dic setValue:@"投辅案例" forKey:@"title"];
            [dic setValue:[dataDic valueForKey:@"cases"] forKey:@"content"];
            [dic setValue:@"case" forKey:@"img"];
            _infoFoldView4.dic = dic;
            
//            _infoFoldView4.sd_layout
//            .topSpaceToView(_infoFoldView3,10)
//            .leftEqualToView(_infoFoldView3)
//            .rightEqualToView(_infoFoldView3)
//            .heightIs(500);
            
            self.startLoading = NO;
        }else{
            self.isNetRequestError  = YES;
        }
    }else{
        self.isNetRequestError = YES;
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
