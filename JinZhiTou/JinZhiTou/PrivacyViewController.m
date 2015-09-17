//
//  PrivacyViewController.m
//  JinZhiTou
//
//  Created by air on 15/9/2.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "PrivacyViewController.h"
#import "GlobalDefine.h"
#import "TDUtil.h"
#import "NavView.h"
#import "HttpUtils.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
@interface PrivacyViewController ()<ASIHTTPRequestDelegate>
{
    UILabel* label;
    HttpUtils* httpUtil;
    LoadingView* loadingView;
    UIScrollView* scrollView;
}
@property(retain,nonatomic)NavView* navView;
@end

@implementation PrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@""];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.title forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.view addSubview:self.navView];

    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    scrollView.backgroundColor = BackColor;
    [self.view addSubview:scrollView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH(self.view)-20, 150)];
    label.numberOfLines = 0;
    label.backgroundColor  =WriteColor;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [scrollView addSubview:label];
    
    [scrollView setContentSize:CGSizeMake(WIDTH(scrollView), POS_Y(label)+100)];
    
    httpUtil = [[HttpUtils alloc]init];
    loadingView = [LoadingUtil shareinstance:self.view];
    [LoadingUtil show:loadingView];
    [self loadData];
}

-(void)setServerUrl:(NSString *)serverUrl
{
    self->_serverUrl = serverUrl;
}

-(void)loadData
{
    [httpUtil getDataFromAPIWithOps:self.serverUrl postParam:nil type:0 delegate:self sel:@selector(requestData:)];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)requestData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
                NSString* data = [dic valueForKey:@"data"];
            
                NSMutableAttributedString* attributedString2 = [[NSMutableAttributedString alloc] initWithString:data];
                NSMutableParagraphStyle* paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle2 setLineSpacing:8];
                [attributedString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, [data length])];
                [label setAttributedText:attributedString2];
                [label sizeToFit];
            
            [scrollView setContentSize:CGSizeMake(WIDTH(scrollView), POS_Y(label)+100)];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
        }
        [LoadingUtil close:loadingView];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
