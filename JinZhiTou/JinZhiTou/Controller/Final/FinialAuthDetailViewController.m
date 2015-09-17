//
//  FinialAuthDetailViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialAuthDetailViewController.h"
#import "NavView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@interface FinialAuthDetailViewController ()<UIScrollViewDelegate>
{
    NavView* navView;
    UIScrollView* scrollView;
}
@end

@implementation FinialAuthDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:@"认证情况"];
    navView.titleLable.textColor=WriteColor;
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"首页" forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:navView];
    
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(scrollView)-20, 200)];
    view.backgroundColor = WriteColor;
    view.layer.cornerRadius =5;
    [scrollView addSubview:view];
    
    
    //姓名
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, WIDTH(scrollView)*1/3, 21)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"姓名";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入姓名
    UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollView)*2/3-20, 21)];
    textField.placeholder = @"请输入您的真实姓名";
    textField.font  =SYSTEMFONT(16);
    [view addSubview:textField];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label)+10, WIDTH(label), 21)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"公司";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(textField), 21)];
    textField.placeholder = @"请输入您的公司名称";
    textField.font  =SYSTEMFONT(16);
    [view addSubview:textField];
    
    //投资领域
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label)+10, WIDTH(scrollView)*1/3, 21)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"投资领域";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入公司信息
    textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollView)*2/3-20, 21)];
    textField.placeholder = @"请输入您所感兴趣的领域";
    textField.font  =SYSTEMFONT(16);
    [view addSubview:textField];
    
    //基金规模
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label)+10, WIDTH(scrollView)*1/3, 21)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"基金规模";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入公司信息
    textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollView)*2/3-20, 21)];
    textField.placeholder = @"请选择您的基金规模";
    textField.font  =SYSTEMFONT(16);
    [view addSubview:textField];
    
    UIImageView* imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, POS_Y(view), WIDTH(scrollView)/2-15, 150)];
    imageView.image = IMAGENAMED(@"loading");
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    
    imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(scrollView)/2+5, POS_Y(view), WIDTH(scrollView)/2-15, 150)];
    imageView.image = IMAGENAMED(@"loading");
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
