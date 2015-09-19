//
//  RoadShowViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/23.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RoadShowViewController.h"
#import "TDUtil.h"
#import "NavView.h"
#import "HttpUtils.h"
#import "DialogUtil.h"
#import "LoadingUtil.h"
#import "DialogView.h"
#import "UConstants.h"
#import "LoadingView.h"
#import "GlobalDefine.h"
#import "WaterFLayout.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "CycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "BannerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RoadShowDetailViewController.h"
@interface RoadShowViewController ()<UIScrollViewDelegate,LoadingViewDelegate,WaterFDelegate>
{
    NavView* navView;
    HttpUtils* httpUtil;
    DialogView* dialogView;
    LoadingView* loadingView;

    
}
@property (nonatomic , retain) CycleScrollView *mainScorllView;
@property(retain,nonatomic)UIScrollView *scrollView;
@end

@implementation RoadShowViewController

- (void)viewDidLoad {
    //TabBarItem 设置
    UIImage* image=IMAGENAMED(@"btn-weiluyan 1");
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setSelectedImage:image];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorTheme,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor=ColorTheme;
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=0;
    [navView setTitle:@"金指投"];
    navView.titleLable.textColor=WriteColor;
    [navView.leftButton setImage:IMAGENAMED(@"top-caidan") forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(userInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
    
    self.viewsArray = [@[] mutableCopy];
    
    //添加瀑布流
    [self addWaterFollow];
    
    //加载Banner数据
    [self loadBanner];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RoadShowProject:) name:@"RoadShowProject" object:nil];
    
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInteractionEnabled:) name:@"userInteractionEnabled" object:nil];
    //提示框
    dialogView = [[DialogView alloc]initWithFrame:self.view.frame];
    
    
}

-(void)userInteractionEnabled:(NSDictionary*)dic
{
    BOOL isUserInteractionEnabled = [[[dic valueForKey:@"userInfo"] valueForKey:@"userInteractionEnabled"] boolValue];
    self.view.userInteractionEnabled = isUserInteractionEnabled;
}
-(void)loadBanner
{
    //网络初始化
    httpUtil = [[HttpUtils alloc]init];
    //初始化加载页面
    if (!loadingView) {
        loadingView = [LoadingUtil shareinstance:self.view];
    }
    loadingView.isError = NO;
    loadingView.delegate  = self;
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    [httpUtil getDataFromAPIWithOps:BANNER_LIST postParam:nil type:0 delegate:self sel:@selector(requestBannerList:)];
}

- (void)addWaterFollow
{
    
    WaterFLayout* flowLayout = [[WaterFLayout alloc]init];
    flowLayout.minimumColumnSpacing = 5;
    flowLayout.minimumInteritemSpacing=10;
    self.waterfall = [[WaterF alloc]initWithCollectionViewLayout:flowLayout];
    self.waterfall.sectionNum = 1;
    self.waterfall.delegate = self;
    self.waterfall.imagewidth = WIDTH(self.view)/2-10;
    self.waterfall.view.backgroundColor=[UIColor whiteColor];
    
    //重新布局
    [self.waterfall.collectionView setFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView)-kBottomBarHeight-20)];
    [self.view addSubview:self.waterfall.collectionView];
}



-(void)loadFinished
{
    [LoadingUtil closeLoadingView:loadingView];
}
-(void)RoadShowProject:(NSMutableDictionary*)dic
{
    NSMutableDictionary* dataDic = [[dic valueForKey:@"userInfo"] valueForKey:@"data"];
    RoadShowDetailViewController* controller=[[RoadShowDetailViewController alloc]init];
    controller.title = navView.title;
    controller.dic =dataDic;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)userInfoAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil];
}


#pragma ASIHttpRequester
//===========================================================网络请求=====================================
-(void)requestBannerList:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            loadingView.isError = NO;
//            [LoadingUtil close:loadingView];
            
            self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0,0, WIDTH(self.view), 150) animationDuration:2];
            self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
            
            NSMutableArray* array = [jsonDic valueForKey:@"data"];
            for (int  i =0; i<array.count; i++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 150)];
                imageView.backgroundColor = WriteColor;
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.layer.masksToBounds = YES;
                
                NSString* fileName=[NSString stringWithFormat:@"%d",i+1];
                imageView.image =IMAGE(fileName, @"jpg");
                [self.viewsArray addObject:imageView];
                
                NSURL* url =[NSURL URLWithString:[array[i] valueForKey:@"img"]];
                [imageView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.layer.masksToBounds = NO;
                }];
            }
            self.bannerArray = array;
            
            __block RoadShowViewController *instance = self;
            self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
                return instance.viewsArray[pageIndex];
            };
            self.mainScorllView.totalPagesCount = ^NSInteger(void){
                return instance.viewsArray.count;
            };
            
            __block RoadShowViewController* roadShow=self;
            self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
                //NSLog(@"点击了第%ld个",(long)pageIndex);
                BannerViewController* controller =[[BannerViewController alloc]init];
                NSString* urlStr =[roadShow.bannerArray[pageIndex] valueForKey:@"url"];
                controller.url =[NSURL URLWithString:urlStr];
                [roadShow.navigationController pushViewController:controller animated:YES];
            };
            self.waterfall.headerView=self.mainScorllView;
        }else{
            NSLog(@"请求失败!");
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{

    loadingView.isError = YES;
    loadingView.content =@"网络连接失败!";
}

-(void)refresh
{
    [self loadBanner];
    [self.waterfall refreshProject];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
