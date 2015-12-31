//
//  ThinkTankViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/16.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ThinkTankViewController.h"
#import "TDUtil.h"
#import "NavView.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "UIImageView+WebCache.h"
#import "ASIFormDataRequest.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ThinkTankViewController ()<UIScrollViewDelegate,ASIHTTPRequestDelegate>
{
    NavView* navView;
    HttpUtils* httpUtils;
    NSDictionary* dataDic;
    LoadingView* loadingView;
    UIScrollView* scrollView;
}
@property (nonatomic,strong) MPMoviePlayerViewController * moviePlayer;//视频播放控制器
@end

@implementation ThinkTankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:@"智囊团详情"];
    navView.titleLable.textColor=WriteColor;
    
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"智囊团" forState:UIControlStateNormal];
    [navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:navView];
    
    scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    scrollView.backgroundColor  = BackColor;
    [self.view addSubview:scrollView];
    
    //头部
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(scrollView), 200)];
    view.tag = 10001;
    view.backgroundColor  = WriteColor;
    view.userInteractionEnabled = YES;
    [scrollView addSubview:view];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(scrollView)-20, 150)];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [imgView sd_setImageWithURL:[self.dic valueForKey:@"photo"] placeholderImage:IMAGENAMED(@"coremember") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
        //[imgView setContentMode:UIViewContentModeScaleAspectFill];
    }];
    
    [view addSubview:imgView];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, POS_Y(view)-40, 90, 40)];
    label.font = SYSTEMFONT(16);
    label.text = [self.dic valueForKey:@"name"];
    
    [view addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)+5, Y(label), 150, 40)];
    label.text = [self.dic valueForKey:@"company"];
    label.textColor = ColorTheme;
    label.font  = SYSTEMFONT(16);
    [view addSubview:label];
    
   
    
    
    view = [[UIView alloc]initWithFrame:CGRectMake(X(view), POS_Y(view)+10, WIDTH(view), scrollView.contentSize.height)];
    view.tag = 10002;
    view.backgroundColor = WriteColor;
    [scrollView addSubview:view];
    
    
    imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, WIDTH(view)/2-70, 1)];
    imgView.backgroundColor = ColorCompanyTheme;
    imgView.tag =1001;
    [view addSubview:imgView];
    
    [self loadThinkTankDetail];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)loadThinkTankDetail
{
    loadingView = [LoadingUtil shareinstance:self.view];
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    
    NSString* url = [THINK_DETAIL stringByAppendingFormat:@"%ld/",(long)[[self.dic valueForKey:@"id"] integerValue]];
    httpUtils = [[HttpUtils alloc]init];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestThinkTankDetail:)];
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
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
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
            UIView* view = [scrollView viewWithTag:10002];
            UIImageView* imgView=(UIImageView*)[scrollView viewWithTag:1001];
            
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+20, Y(imgView)-10, 100, 40)];
            label.textColor = ColorCompanyTheme;
            [TDUtil setLabelMutableText:label content:@"个人履历" lineSpacing:0 headIndent:0];
            label.font  = SYSTEMFONT(16);
            [view addSubview:label];
            
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), 20, 20)];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image =IMAGENAMED(@"gerenlvli");
            [view addSubview:imgView];
            
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(imgView)+10, WIDTH(view)-20, 150)];
            label.tag =10002;
            label.font  = SYSTEMFONT(16);
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            [view addSubview:label];
            NSString* contentStr= [dataDic valueForKey:@"experience"];
            NSMutableAttributedString * attributedString1;
            NSMutableParagraphStyle * paragraphStyle1;
            if ([TDUtil isValidString:contentStr]) {
                attributedString1= [[NSMutableAttributedString alloc] initWithString:contentStr];
                paragraphStyle1= [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle1 setLineSpacing:8];
                [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [contentStr length])];
                [label setAttributedText:attributedString1];
                [label sizeToFit];
            }
            
            
            imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(label)+20, WIDTH(view)/2-70, 1)];
            imgView.backgroundColor = ColorCompanyTheme;
            [view addSubview:imgView];
            
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+20, Y(imgView)-10, 100, 40)];
            label.textColor = ColorCompanyTheme;
            [TDUtil setLabelMutableText:label content:@"擅长领域" lineSpacing:0 headIndent:0];
            label.font  = SYSTEMFONT(16);
            [view addSubview:label];
            
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), 20, 20)];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image =IMAGENAMED(@"anli");
            [view addSubview:imgView];
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(imgView)+10, WIDTH(view)-20, 150)];
            label.tag =10003;
            label.font  = SYSTEMFONT(16);
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            [view addSubview:label];
            
            NSString* content= [dataDic valueForKey:@"domain"];
            NSMutableAttributedString* attributedString2 = [[NSMutableAttributedString alloc] initWithString:content];
            NSMutableParagraphStyle* paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle2 setLineSpacing:8];
            [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [content length])];
            [label setAttributedText:attributedString2];
            [label sizeToFit];
            
            
            
            
            imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(label)+10, WIDTH(view)/2-70, 1)];
            imgView.backgroundColor = ColorCompanyTheme;
            [view addSubview:imgView];
            
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+20, Y(imgView)-10, 100, 40)];
            label.textColor = ColorCompanyTheme;
            [TDUtil setLabelMutableText:label content:@"成功案例" lineSpacing:0 headIndent:0];
            label.font  = SYSTEMFONT(16);
            [view addSubview:label];
            
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), 20, 20)];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            imgView.image =IMAGENAMED(@"lingyu");
            [view addSubview:imgView];
            
            label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(imgView)+10, WIDTH(view)-20, 150)];
            label.tag =10004;
            label.font  = SYSTEMFONT(16);
            [view addSubview:label];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            
            label = (UILabel*)[view viewWithTag:10004];
            contentStr= [dataDic valueForKey:@"cases"];
            [paragraphStyle1 setLineSpacing:8];
            paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            attributedString1 = [[NSMutableAttributedString alloc] initWithString:contentStr];
            [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [contentStr length])];
            [label setAttributedText:attributedString1];
            [label sizeToFit];
            
            [view setFrame:CGRectMake(X(view), Y(view), WIDTH(view), POS_Y(label)+20)];
           
            scrollView.contentSize = CGSizeMake(WIDTH(scrollView), POS_Y(view)+100);
             [LoadingUtil closeLoadingView:loadingView];
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
