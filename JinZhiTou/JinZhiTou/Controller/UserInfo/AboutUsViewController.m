//
//  AboutUsViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/8.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "AboutUsViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
@interface AboutUsViewController ()<ASIHTTPRequestDelegate>
{
    HttpUtils * httpUtils;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"关于我们"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    view.backgroundColor  =BackColor;
    [self.view addSubview:view];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake( WIDTH(view)/2-50, 50, 100, 150)];
    imageView.image =IMAGENAMED(@"About-logo");
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imageView];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,POS_Y(imageView)+20, WIDTH(imageView), 1)];
    imageView.backgroundColor = BackColor;
    [view addSubview:imageView];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(imageView)-10, WIDTH(view), 30)];
    label.text = @"V2.0.0";
    label.font  =SYSTEMFONT(16);
    label.textColor  = BACKGROUND_LIGHT_GRAY_COLOR;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,POS_Y(label)+20, WIDTH(imageView), 1)];
    imageView.backgroundColor = BackColor;
    [view addSubview:imageView];
    
    UIView* bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(self.view)-200, WIDTH(view), 50)];
    bottomView.backgroundColor  =WriteColor;
    [view addSubview:bottomView];
    
//    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(update:)];
//    label = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, WIDTH(view)-60, 50)];
//    label.userInteractionEnabled  = YES;
//    [label addGestureRecognizer:recognizer];
//    label.text =@"版本更新";
//    label.font  =SYSTEMFONT(16);
//    label.textAlignment = NSTextAlignmentLeft;
//    label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
//    [bottomView addSubview:label];
//    
//    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,POS_Y(label), WIDTH(view), 1)];
//    imageView.backgroundColor = BackColor;
//    [bottomView addSubview:imageView];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAppStore:)];
    label = [[UILabel alloc]initWithFrame:CGRectMake(40,0, WIDTH(view)-60, 50)];
    label.userInteractionEnabled= YES;
    [label addGestureRecognizer:recognizer];
    label.text =@"去评分";
    label.font  =SYSTEMFONT(16);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
    [bottomView addSubview:label];
    
    httpUtils = [[HttpUtils alloc]init];
    
}

-(void)update:(id)sender
{
    [httpUtils getDataFromAPIWithOps:UPDATE postParam:[NSDictionary dictionaryWithObject:@"1" forKey:@"flag"] type:0 delegate:self sel:@selector(requestUpdate:)];
}

-(void)goAppStore:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ITUNES_URL]];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)requestUpdate:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] ==-1) {
            
        }
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    
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
