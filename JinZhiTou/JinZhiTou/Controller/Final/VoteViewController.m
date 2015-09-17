//
//  VoteViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/30.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "VoteViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
@interface VoteViewController ()<ASIHTTPRequestDelegate>
{
    HttpUtils* httpUtils;
}

@end

@implementation VoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor=ColorTheme;
    //网络初始化
    httpUtils  = [[HttpUtils alloc]init];
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"投票"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"投融资" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    self.btnVote.layer.cornerRadius = 5;
    self.btnVote.backgroundColor =ColorTheme;
    
    self.descpLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.imageView.image = IMAGENAMED(@"loading");
    
    UIImageView* bootomImgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.descpLabel), HEIGHT(self.view)-230, 200, 170)];
    bootomImgView.image = IMAGENAMED(@"money");
    bootomImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:bootomImgView];
    
    UIImageView* voteImgView =[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2-15, HEIGHT(self.view)-90, 130, 30)];
    
    voteImgView.image = IMAGENAMED(@"botton");
    voteImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:voteImgView];
}

- (IBAction)doVoteAction:(id)sender {
    
    NSString* url = [VOTE stringByAppendingFormat:@"%ld/",(long)self.projectId];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestVote:)];
    self.btnVote.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
    [self.btnVote setTitle:@"您已投票" forState:UIControlStateNormal];
}


-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma ASIHttpRequest
-(void)requestVote:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSInteger status = [[jsonDic valueForKey:@"status"] integerValue];
        if (status == 0 || status == -1) {
            
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
