//
//  ThinkTankViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/16.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "PersonalFinanceViewController.h"
#import "FoldInfoView.h"
#import "NSString+SBJSON.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
@interface PersonalFinanceViewController ()<UIScrollViewDelegate,ASIHTTPRequestDelegate>
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

@implementation PersonalFinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"个人投资人详情"];
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
    
    //头像
    imgView = [[UIImageView alloc]init];
    imgView.layer.masksToBounds = YES;
    imgView.backgroundColor = BlackColor;
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [imgView sd_setImageWithURL:[self.dic valueForKey:@"photo"] placeholderImage:IMAGENAMED(@"coremember") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
        [imgView setContentMode:UIViewContentModeScaleToFill];
    }];
    
    [view addSubview:imgView];
    
    imgView.sd_layout
    .widthEqualToHeight(80)
    .spaceToSuperView(UIEdgeInsetsMake(HEIGHT(view)/2-40, WIDTH(self.view)/2-40, HEIGHT(view)/2-40, 0));
    imgView.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithDouble:0.5];

    _infoFoldView1 = [[FoldInfoView alloc] init];
    [scrollView addSubview:_infoFoldView1];
    
    
    _infoFoldView1.sd_layout
    .topSpaceToView(view,10)
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
    
    _infoFoldView3 = [[FoldInfoView alloc] init];
    [scrollView addSubview:_infoFoldView3];
    
    _infoFoldView3.sd_layout
    .topSpaceToView(_infoFoldView2,10)
    .leftEqualToView(_infoFoldView2)
    .rightEqualToView(_infoFoldView2)
    .heightIs(200);
    
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
    
    
    
    
//    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, POS_Y(view)-40, 90, 40)];
//    label.font = SYSTEMFONT(16);
//    label.text = [self.dic valueForKey:@"name"];
//    
//    [view addSubview:label];
//    
//    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)+5, Y(label), 150, 40)];
//    label.text = [self.dic valueForKey:@"company"];
//    label.textColor = ColorTheme;
//    label.font  = SYSTEMFONT(16);
//    [view addSubview:label];
//    
//    view = [[UIView alloc]initWithFrame:CGRectMake(X(view), POS_Y(view)+10, WIDTH(view), scrollView.contentSize.height)];
//    view.tag = 10002;
//    view.backgroundColor = WriteColor;
//    [scrollView addSubview:view];
//    
//    
//    imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, WIDTH(view)/2-70, 1)];
//    imgView.backgroundColor = ColorCompanyTheme;
//    imgView.tag =1001;
//    [view addSubview:imgView];
//    
//    
//    NSArray *views = @[];
//    
//    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [scrollView addSubview:obj];
//    }];
    
    [self loadThinkTankDetail];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)loadThinkTankDetail
{
    
    NSString* url = [AUTHDETAIL stringByAppendingFormat:@"%ld/",(long)[[self.dic valueForKey:@"id"] integerValue]];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestThinkTankDetail:)];
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
            [dic setValue:@"个人介绍" forKey:@"title"];
            [dic setValue:[dataDic valueForKey:@"profile"] forKey:@"content"];
            _infoFoldView1.dic = dic;
            
            dic = [NSMutableDictionary new];
            [dic setValue:@"寄语" forKey:@"title"];
            [dic setValue:[dataDic valueForKey:@"signature"] forKey:@"content"];
            _infoFoldView2.dic = dic;
            
            dic = [NSMutableDictionary new];
            [dic setValue:@"投资规划" forKey:@"title"];
            [dic setValue:[dataDic valueForKey:@"investplan"] forKey:@"content"];
            _infoFoldView3.dic = dic;
            
            dic = [NSMutableDictionary new];
            [dic setValue:@"投资案例" forKey:@"title"];
            [dic setValue:[dataDic valueForKey:@"investcase"] forKey:@"content"];
            _infoFoldView4.dic = dic;
            
//            _infoFoldView4.sd_layout
//            .topSpaceToView(_infoFoldView3,10)
//            .leftEqualToView(_infoFoldView3)
//            .rightEqualToView(_infoFoldView3)
//            .heightIs(500);
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
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
