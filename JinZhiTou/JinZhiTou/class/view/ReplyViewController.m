//
//  ReplyViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/29.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ReplyViewController.h"
#import "HttpUtils.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "TDUtil.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
@interface ReplyViewController ()<UITextViewDelegate,ASIHTTPRequestDelegate,UITextViewDelegate>
{
    HttpUtils* httpUtils;
    LoadingView * loadingView;
    
    UIButton* btnAction;
    UITextView* textView;
}
@end

@implementation ReplyViewController

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
    [self.navView setTitle:@"撰写评论"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"投融资" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];

    UIView* view  = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    view.backgroundColor = BackColor;
    [self.view addSubview:view];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(self.view)-20, 150)];
    textView.backgroundColor  = WriteColor;
    textView.delegate =self;
    textView.font = SYSTEMFONT(16);
    textView.returnKeyType = UIReturnKeyDone;
    [view addSubview:textView];
    
    btnAction = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(textView)+20, WIDTH(self.view)-60, 35)];
    btnAction.backgroundColor = ColorTheme;
    btnAction.layer.cornerRadius = 5;
    [btnAction setTitle:@"发表" forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAction setTitleColor:WriteColor forState:UIControlStateNormal];
    [view addSubview:btnAction];
    
    httpUtils = [[HttpUtils alloc]init];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnAction:(id)sender
{
    NSString* url  =[TOPIC stringByAppendingFormat:@"%d/",self.project_id];
    [httpUtils getDataFromAPIWithOps:url postParam:[NSDictionary dictionaryWithObject:textView.text forKey:@"content"] type:0 delegate:self sel:@selector(requestSubmmit:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestSubmmit:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            loadingView.isError = NO;
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

-(void)textViewDidEndEditing:(UITextView *)textViewInstance
{
    [textViewInstance resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textViewInstance shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textViewInstance resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
