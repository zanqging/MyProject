//
//  TeamDetailViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "TeamDetailViewController.h"
#import "TDUtil.h"
#import "NavView.h"
#import "HttpUtils.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "UIImageView+WebCache.h"
@interface TeamDetailViewController ()<UIScrollViewDelegate,ASIHTTPRequestDelegate>
{
    NavView* navView;
    UITextView* textView;
    HttpUtils* httpUtils;
    LoadingView* loadingView;
    UIScrollView* scrollView;
}
@end

@implementation TeamDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:@"团队成员详情"];
    navView.titleLable.textColor=WriteColor;
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"核心团队" forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:navView];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), 250)];
    imageView.backgroundColor =WriteColor;
    imageView.tag = 1001;
    imageView.alpha=0.5;
    [self.view  addSubview:imageView];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    scrollView.delegate=self;
    scrollView.bounces = NO;
    scrollView.backgroundColor=ClearColor;
    scrollView.contentInset=UIEdgeInsetsMake(150, 0, 0, 0);
    [self.view addSubview:scrollView];
    
    UIImageView* v = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(scrollView), HEIGHT(self.view))];
    v.tag = 2001;
    v.backgroundColor = WriteColor;
    [scrollView addSubview:v];
    
    //头像
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)-90,-40, 70, 70)];
    imageView.image=IMAGENAMED(@"coremember");
    imageView.layer.cornerRadius=35;
    imageView.layer.masksToBounds=YES;
    imageView.tag = 1002;
    [scrollView addSubview:imageView];
    
    //名称
    UILabel* lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(imageView), WIDTH(scrollView), 30)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.tag = 6001;
    lbl.font = SYSTEMFONT(18);
    lbl.backgroundColor = WriteColor;
    [v addSubview:lbl];
    
    lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(lbl), WIDTH(scrollView), 30)];
    lbl.tag = 6002;
    lbl.font = SYSTEMFONT(16);
    lbl.backgroundColor = WriteColor;
    lbl.textAlignment = NSTextAlignmentCenter;
    [v addSubview:lbl];
    
//    UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(POS_X(lbl), Y(lbl), 70, 30)];
//    btnAction.layer.borderWidth = 1;
//    btnAction.layer.cornerRadius=5;
//    btnAction.layer.borderColor = ColorTheme.CGColor;
//    btnAction.titleLabel.font = SYSTEMFONT(14);
//    [btnAction addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
//    [btnAction setTitle:@"+ 加好友" forState:UIControlStateNormal];
//    [btnAction setTitleColor:ColorTheme forState:UIControlStateNormal];
//    [v addSubview:btnAction];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, POS_Y(lbl)+10, WIDTH(scrollView)-20, 350)];
    
    [v addSubview:textView];
    
    [scrollView setContentSize:CGSizeMake(WIDTH(self.view), HEIGHT(self.view)+70)];
    
    [self loadTeamPersonDetail];
    
}

-(void)loadTeamPersonDetail
{
    httpUtils = [[HttpUtils alloc]init];
    NSString* url = [TEAM_DETAIL stringByAppendingFormat:@"%ld/",(long)self.person_id];
    
    //加载视图
    loadingView = [LoadingUtil shareinstance:self.view];
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestPersonDetail:)];
}

-(void)doAction:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma ASIHttpRequester
//===========================================================网络请求=====================================
-(void)requestPersonDetail:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            NSDictionary* dic = [jsonDic valueForKey:@"data"];
            [self.dataDic setValue:[dic valueForKey:@"profile"] forKey:@"profile"];
            
            //头像背景
            UIImageView* imgView = (UIImageView*)[self.view viewWithTag:1001];
            [imgView sd_setImageWithURL:[self.dataDic valueForKey:@"img"] placeholderImage:IMAGENAMED(@"coremember")];
            
            imgView = (UIImageView*)[scrollView viewWithTag:1002];
            [imgView sd_setImageWithURL:[self.dataDic valueForKey:@"img"]];
            
            //姓名
            UIView* view = [scrollView viewWithTag:2001];
            UILabel* label = (UILabel*)[view viewWithTag:6001];
            label.text = [self.dataDic valueForKey:@"name"];
            
            //职位
            label = (UILabel*)[view viewWithTag:6002];
            label.text = [self.dataDic valueForKey:@"title"];
            
            //内容
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 10;// 字体的行间距
            
            NSDictionary *attributes = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:15],
                                         NSParagraphStyleAttributeName:paragraphStyle
                                         };
            textView.attributedText = [[NSAttributedString alloc] initWithString:[dic valueForKey:@"profile"] attributes:attributes];
            
            [LoadingUtil closeLoadingView:loadingView];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
    loadingView.isError = YES;
    loadingView.content =@"网络连接失败!";
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
