//
//  HomePageViewController.m
//  WeiNI
//
//  Created by csz on 14/12/3.
//  Copyright (c) 2014年 weini. All rights reserved.
//
#import "StartPageViewController.h"
#import "TDUtil.h"
#import "BoxModel.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
#import "AuthViewController.h"
#define  pageCount 5   //分页控制器控制两个视图页面
@interface StartPageViewController ()<UIScrollViewDelegate>

@end
@implementation StartPageViewController
@synthesize wnPageControl=wn_PageControl;
@synthesize wnScrollView=wn_ScrollView;


- (void)viewDidLoad {
    [super viewDidLoad];
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self.navigationController.navigationBar setHidden:YES];
    //获取屏幕高度和宽度
    int width=self.view.frame.size.width;
    self.view.backgroundColor=PEISONG_COLOR;
    //显示状态栏
    self.automaticallyAdjustsScrollViewInsets=NO;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //开始布局
    CGRect scrollViewRect = self.view.bounds;
    //创建ScrollView
    wn_ScrollView=[[UIScrollView alloc]initWithFrame:scrollViewRect];
    wn_ScrollView.pagingEnabled=YES;
    wn_ScrollView.contentSize = CGSizeMake(scrollViewRect.size.width * pageCount, scrollViewRect.size.height);
    wn_ScrollView.showsHorizontalScrollIndicator = NO;
    wn_ScrollView.showsVerticalScrollIndicator = NO;
    wn_ScrollView.delegate = self;
    wn_ScrollView.bounces=NO;
    //添加ScrollView到当前视图
    [self.view addSubview:wn_ScrollView];
    
    //厨师
    int h = [TDUtil ConvertSingl:1334 l2:750 l3:1136];
    //创建分页控件
    wn_PageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, h-100, width, 30)];
    wn_PageControl.numberOfPages = pageCount;   //设置分页控件总页面视图数量
    wn_PageControl.currentPage = 0;   //设置分页控件当前页面
    [wn_PageControl setAlpha:1];
    [wn_PageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    //添加分页控件到当前视图
    [self.view  addSubview:wn_PageControl];
    
    
    //创建视图
    [self createPages];
    
}


#pragma mark 图片切换
-(void)loadScrollViewWithPage:(UIView*)page
{
    NSInteger count = [[wn_ScrollView subviews] count];
    
    CGRect bounds = wn_ScrollView.bounds;
    bounds.origin.x = bounds.size.width * count;
    bounds.origin.y = 0;
    bounds.size.height = page.frame.size.height;
    page.frame = bounds;
    [wn_ScrollView addSubview:page];
}
//创建视图
-(void)createPages
{
    NSMutableArray* mutableArray=[[NSMutableArray alloc]init];
    //检测用户是否第一次打开app
//    DataStore*dataStore=[[DataStore alloc]init];
    BoxModel* model;
    CGRect frame=self.view.frame;
    mutableArray=[[NSMutableArray alloc]init];
    model=[[BoxModel alloc]init];
    [model setDesc1:@"Guide1"];

    
    slidView1=[[SlideView alloc]initWithFrame:frame];
    slidView1.imageView.image=[UIImage imageNamed:model.desc1];
    
    [wn_ScrollView addSubview:slidView1];
    
    frame.origin.x+=frame.size.width/2;
    model=[[BoxModel alloc]init];
    [model setDesc1:@"Guide2"];
    slidView2=[[SlideView alloc]initWithFrame:frame];
    slidView2.imageView.image=[UIImage imageNamed:model.desc1];
    [wn_ScrollView addSubview:slidView2];
    
    frame.origin.x+=frame.size.width/2;
    model=[[BoxModel alloc]init];
    [model setDesc1:@"Guide3"];
    slidView3=[[SlideView alloc]initWithFrame:frame];
    slidView3.imageView.image=[UIImage imageNamed:model.desc1];
    [wn_ScrollView addSubview:slidView3];
    
    frame.origin.x+=frame.size.width/2;
    model=[[BoxModel alloc]init];
    [model setDesc1:@"Guide4"];
    slidView3=[[SlideView alloc]initWithFrame:frame];
    slidView3.imageView.image=[UIImage imageNamed:model.desc1];
    [wn_ScrollView addSubview:slidView3];
    
    frame.origin.x+=frame.size.width*5/2;
    startPage=[[SlideViewStartPage alloc]initWithFrame:frame];
     [startPage.btnStart addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [wn_ScrollView addSubview:startPage];
}

-(void)action:(id)sender
{
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    [data setValue:@"true" forKey:@"isStart"];
    AuthViewController* controller=[[AuthViewController alloc]init];
    [self.navigationController pushViewController:controller animated:NO];
    [self removeFromParentViewController];
}
//切换视图
-(void)changePage:(id)sender
{
    int currentPage=(int) wn_PageControl.currentPage;
    if (currentPage==0) {
        
    }else if(currentPage==2){
        
        
    }else if (currentPage==1){
        
    }
    
    CGRect frame = wn_ScrollView.frame;
    frame.origin.x = frame.size.width * currentPage;
    frame.origin.y = 0;
    [wn_ScrollView scrollRectToVisible:frame animated:YES];
}

#pragma UIScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    wn_PageControl.currentPage=currentPage;
    if (currentPage==0) {
        
    }else if(currentPage==2){
        
    }else if (currentPage==1){
        
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //    float scroolViewStartX=scrollView.contentOffset.x;
}
//*********************************************************视图重绘*****************************************************//
-(void) viewDidAppear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@",  @"启动引导", nil];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    NSString* cName = [NSString stringWithFormat:@"%@",@"启动引导", nil];
}
//*********************************************************视图重绘结束*****************************************************//
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
