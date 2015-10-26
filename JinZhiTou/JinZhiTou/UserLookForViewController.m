//
//  UserLookForViewController.m
//  Cycle
//
//  Created by air on 15/10/14.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "UserLookForViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TDUtil.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "LoadingView.h"
#import "LoadingUtil.h"
#import "GlobalDefine.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "UIImageView+WebCache.h"
#import "NSString+SBJSON.h"
@interface UserLookForViewController ()
{
    HttpUtils* httpUtils;
    LoadingView* loadingView;
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
    imageView.tag=20001;
    [self.contentView addSubview:imageView];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, 10, WIDTH(self.contentView)-POS_X(imageView)-50, 30)];
    label.tag=10001;
    [self.contentView addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, POS_Y(label),WIDTH(label)-100, 20)];
    label.tag=10002;
    label.numberOfLines = 2;
    label.font = SYSTEMFONT(13);
    label.textColor =FONT_COLOR_GRAY;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, POS_Y(label),WIDTH(label), 20)];
    label.tag=10003;
    label.font = SYSTEMFONT(13);
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor =FONT_COLOR_GRAY;
    [self.contentView addSubview:label];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, POS_Y(label),WIDTH(label), 20)];
    label.tag=10004;
    label.font = SYSTEMFONT(12);
    label.textColor =FONT_COLOR_GRAY;
    [self.contentView addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self.contentView)-60, POS_Y(label)-50,40, 50)];
    label.tag=10005;
    label.font = SYSTEMFONT(20);
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor =ColorTheme;
    [self.contentView addSubview:label];
    
    [scrollView addSubview:self.contentView];
    loadingView = [LoadingUtil shareinstance:self.view];
    [LoadingUtil show:loadingView];
    [self loadData];
}

-(void)loadData
{
    if (!httpUtils) {
        httpUtils = [[HttpUtils alloc]init];
    }
    NSString* serverUrl = [USERINFO stringByAppendingFormat:@"%@/",self.userId];
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestFinished:)];
    
}

-(void)setDic:(NSDictionary *)dic
{
    self->_dic = dic;
    if (self.dic) {
        UIImageView* imgView =(UIImageView*)[self.contentView viewWithTag:20001];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[self.dic valueForKey:@"user_img"]]];
        
        UILabel* label = (UILabel*)[self.contentView viewWithTag:10001];
        label.text = [self.dic valueForKey:@"real_name"];
        
        label = (UILabel*)[self.contentView viewWithTag:10002];
        label.text = [[self.dic valueForKey:@"position_type"] objectAtIndex:0];
        
        label = (UILabel*)[self.contentView viewWithTag:10003];
        label.text = [self.dic valueForKey:@"province"];
        
        label = (UILabel*)[self.contentView viewWithTag:10004];
        label.text = [self.dic valueForKey:@"city"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 ) {
            self.dic = [jsonDic valueForKey:@"data"];
            [LoadingUtil close:loadingView];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
}

@end
