//
//  UserLookForViewController.m
//  Cycle
//
//  Created by air on 15/10/14.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "UserLookForViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UConstants.h"
#import "GlobalDefine.h"
#import "HttpUtils.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "NSString+SBJSON.h"
@interface UserLookForViewController ()
{
    HttpUtils* httpUtils;
    UIScrollView* scrollView;
}
@end

@implementation UserLookForViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = ColorTheme;
    self.title = @"用户详情";
    
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"全文详情"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.title forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), self.view.frame.size.width, self.view.frame.size.height-64)];
    scrollView.backgroundColor  =WriteColor;
    [self.view addSubview:scrollView];
    
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 150)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.contentView.layer.borderWidth =1;
    self.contentView.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
    
    //头像
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    imageView.image = [UIImage imageNamed:@"头像"];
    [self.contentView addSubview:imageView];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, 10, WIDTH(self.contentView)-POS_X(imageView)-50, 30)];
    label.text = @"杨顺才";
    [self.contentView addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, POS_Y(label),WIDTH(label)-100, 50)];
    label.text = @"聚英国际咨询集团郑州二顾问中心总经理";
    label.font = SYSTEMFONT(13);
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor =FONT_COLOR_GRAY;
    [self.contentView addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, POS_Y(label),WIDTH(label), 20)];
    label.text = @"教育培训｜咨询";
    label.font = SYSTEMFONT(13);
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor =FONT_COLOR_GRAY;
    [self.contentView addSubview:label];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, POS_Y(label),WIDTH(label), 20)];
    label.text = @"地址：河南郑州";
    label.font = SYSTEMFONT(12);
    label.textColor =FONT_COLOR_GRAY;
    [self.contentView addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self.contentView)-60, POS_Y(label)-50,40, 50)];
    label.text = @"聚英国际";
    label.font = SYSTEMFONT(20);
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor =ColorTheme;
    [self.contentView addSubview:label];
    
    [scrollView addSubview:self.contentView];
}

-(void)loadData
{
    if (!httpUtils) {
        httpUtils = [[HttpUtils alloc]init];
    }
    [httpUtils getDataFromAPIWithOps:USERINFO postParam:[NSDictionary dictionaryWithObject:[self.dic valueForKey:@"id"] forKey:@"id"] type:0 delegate:self sel:@selector(requestFinished:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
