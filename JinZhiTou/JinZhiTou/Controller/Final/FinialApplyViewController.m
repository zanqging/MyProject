//
//  FinialApplyViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialApplyViewController.h"
#import "TDUtil.h"
#import "NavView.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "FinialKind.h"
#import "DialogUtil.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "AutoShowView.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "FinialSuccessViewController.h"
@interface FinialApplyViewController ()<UIScrollViewDelegate,UITextFieldDelegate,ASIHTTPRequestDelegate>
{
    int currentSelect;
    
    NavView* navView;
    HttpUtils* httpUtils;
    LoadingView* loadingView;
    AutoShowView* autoView;
    
    BOOL isChooseID;
    BOOL isShowInfoView;
    
    NSInteger currentTag;
    NSDictionary* currentDic;
    UIScrollView* scrollView;
    
}

@end

@implementation FinialApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:@"投资"];
    navView.titleLable.textColor=WriteColor;
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"项目详情" forState:UIControlStateNormal];
    [navView.leftButton setTitle:self.titleStr forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:navView];
    
    [self addView];
    
    //网络初始化
    httpUtils = [[HttpUtils alloc]init];
    //数据初始化
    currentSelect=1;
    currentTag=20002;
    
    
    //加载数据
    
    [self loadData];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoDetailView:) name:@"autoSelect" object:nil];
}
-(void)addView
{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    scrollView.tag =40001;
    scrollView.delegate=self;
    scrollView.bounces = NO;
    scrollView.backgroundColor=BackColor;
    scrollView.contentSize = CGSizeMake(WIDTH(scrollView), HEIGHT(scrollView)+100);
    [self.view addSubview:scrollView];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doAction:)];
    //自然投资人
    FinialKind* finialKindView = [[FinialKind alloc]initWithFrame:CGRectMake(30, 10, WIDTH(self.view)/2-35, 40)];
    finialKindView.tag = 20001;
    finialKindView.isSelected = YES;
    finialKindView.backgroundColor = ColorTheme;
    finialKindView.label.textColor = WriteColor;
    [finialKindView addGestureRecognizer:recognizer];
    [finialKindView setImageWithNmame:@"Lead investor-white" setText:@"我要领投"];
    [scrollView addSubview:finialKindView];
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doAction:)];
    //机构投资人
    finialKindView = [[FinialKind alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2+5, 10, WIDTH(self.view)/2-35, 40)];
    finialKindView.tag = 20002;
    finialKindView.isSelected = NO;
    finialKindView.label.textColor = ColorTheme;
    [finialKindView addGestureRecognizer:recognizer];
    [finialKindView setImageWithNmame:@"With investment" setText:@"我要跟投"];
    [scrollView addSubview:finialKindView];
    
    //填写信息
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(10, POS_Y(finialKindView)+10, WIDTH(self.view)-20, 50)];
    view.tag = 30001;
    view.backgroundColor  =WriteColor;
    [scrollView addSubview:view];
    
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH(view), 50)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"点击选择您的投资人身份";
    lable.tag =500001;
    lable.font  =SYSTEMFONT(16);
    lable.userInteractionEnabled = YES;
    lable.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
    [lable addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectID:)]];
    [view addSubview:lable];
    
    
    view = [[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(view)+1, WIDTH(view), 50)];
    view.tag=30002;
    view.userInteractionEnabled =YES;
    view.backgroundColor  =WriteColor;
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(lable), WIDTH(view), 1)];
    imgView.backgroundColor = BackColor;
    [view addSubview:imgView];
    
    //投资额度
    lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH(scrollView)*1/4, 30)];
    lable.text = @"投资额度";
    lable.font = SYSTEMFONT(16);
    lable.textAlignment = NSTextAlignmentRight;
    lable.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
    [view addSubview:lable];
    
    //输入投资额度
    UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(lable)+10, Y(lable), 180, 30)];
    textField.tag =500001;
    textField.delegate = self;
    textField.font  =SYSTEMFONT(12);
    textField.userInteractionEnabled = YES;
    textField.enabled  =YES;
    textField.returnKeyType = UIReturnKeyDone;
    textField.placeholder = @"请输入您的投资额度:单位：万元(必填)";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:textField];
    
    [scrollView addSubview:view];
    
    
    UIButton* btnAction =[UIButton buttonWithType:UIButtonTypeRoundedRect ];
    btnAction.tag =30004;
    btnAction.layer.cornerRadius = 5;
    btnAction.backgroundColor = ColorTheme;
    [btnAction setTitle:@"提交资料" forState:UIControlStateNormal];
    [btnAction setTitleColor:WriteColor forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(finialSubmmit:) forControlEvents:UIControlEventTouchUpInside];
    [btnAction setFrame:CGRectMake(30, POS_Y(view)+50, WIDTH(self.view)-60, 40)];
    [scrollView addSubview:btnAction];
}

-(void)infoDetailView:(NSDictionary*)dic
{
    NSDictionary* item =[[dic valueForKey:@"userInfo"] valueForKey:@"item"];
    if (item) {
        isChooseID=YES;
    }
    currentDic = item;
    
    UILabel* label =(UILabel*)[scrollView viewWithTag:500001];
    label.text = [item valueForKey:@"company"];
    label.textColor = ColorCompanyTheme;
    
    NSString* url =[INVESTINFO stringByAppendingFormat:@"%@/",[item valueForKey:@"id"]];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestIDInfoDetail:)];
}

-(void)IDInfoDetail:(NSDictionary*)dic
{
    if (dic && !isShowInfoView) {
        UIView* seelectView = [scrollView viewWithTag:30001];
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(10, POS_Y(seelectView)+10, WIDTH(self.view)-20, 180)];
        view.tag = 30001;
        view.backgroundColor = WriteColor;
        
        //开始动画
        UIView* infoView = [scrollView viewWithTag:30002];
        UIView* btnActionView = [scrollView viewWithTag:30004];
        
        CGRect frame =seelectView.frame;
        CGRect btnFrame = btnActionView.frame;
        
        frame.origin.y=POS_Y(view)+10;
        btnFrame.origin.y = frame.origin.y+ btnFrame.size.height + 50;
        [infoView removeFromSuperview];
        [scrollView addSubview:infoView];
        [UIView animateWithDuration:0.5 animations:^(void){
            [infoView setFrame:frame];
            [btnActionView setFrame:btnFrame];
        }];
        
        //职位
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20,WIDTH(scrollView)*1/4, 30)];
        label.textColor = ColorFontNormal;
        label.font = SYSTEMFONT(16);
        label.tag =10001;
        label.textAlignment = NSTextAlignmentRight;
        [view addSubview:label];
        
        //输入职位
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(view)-POS_X(label)-20, 30)];
        label.font  =SYSTEMFONT(16);
        label.tag =10002;
        label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [view addSubview:label];
        
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label)+10, WIDTH(scrollView)*1/4, 30)];
        label.tag =10003;
        label.font = SYSTEMFONT(16);
        label.textColor = ColorFontNormal;
        label.textAlignment = NSTextAlignmentRight;
        [view addSubview:label];
        
        //输入职位
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(view)-POS_X(label)-20, 30)];
        label.font  =SYSTEMFONT(16);
        label.tag =10004;
        label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [view addSubview:label];
    
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label)+10, WIDTH(scrollView)*1/4, 30)];
        label.tag =10005;
        label.font = SYSTEMFONT(16);
        label.textColor = ColorFontNormal;
        label.textAlignment = NSTextAlignmentRight;
        [view addSubview:label];
        
        
        //输入职位
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label),150, 30)];
        label.tag =10006;
        label.font  =SYSTEMFONT(16);
        label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [view addSubview:label];
        
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label)+10, WIDTH(scrollView)*1/4, 30)];
        label.tag =10007;
        label.font = SYSTEMFONT(16);
        label.textColor = ColorFontNormal;
        label.textAlignment = NSTextAlignmentRight;
        [view addSubview:label];
        
        //输入职位
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(view)-POS_X(label)-20, 30)];
        label.font  =SYSTEMFONT(16);
        label.tag =10008;
        label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [view addSubview:label];
        [scrollView addSubview:view];
        
        isShowInfoView = YES;
    }
    if([[dic valueForKey:@"investor_type"] intValue] == 0){
        
        
        UILabel* label =(UILabel*) [scrollView viewWithTag:10001];
        label.text = @"真实姓名";
        
        label =(UILabel*) [scrollView viewWithTag:10002];
        label.text = [dic valueForKey:@"real_name"];
        
        
        label =(UILabel*) [scrollView viewWithTag:10003];
        label.text =@"手机号码";
        
        label =(UILabel*) [scrollView viewWithTag:10004];
        label.text = [dic valueForKey:@"telephone"];
        
        
        label =(UILabel*) [scrollView viewWithTag:10005];
        label.text = @"公司名称";
        
        
        label =(UILabel*) [scrollView viewWithTag:10006];
        label.text = [dic valueForKey:@"company"];
        
        label =(UILabel*) [scrollView viewWithTag:10007];
        label.text = @"注册地址";
        
        
        NSString* str =  [[dic valueForKey:@"province"] stringByAppendingString: [dic valueForKey:@"city"]];
        label =(UILabel*) [scrollView viewWithTag:10008];
        label.text =str;
        
    }else{
        UILabel* label =(UILabel*) [scrollView viewWithTag:10001];
        label.text = @"用户类型";
        
        label =(UILabel*) [scrollView viewWithTag:10002];
        label.text = [[dic valueForKey:@"investor_type"] intValue]==0?@"自然投资者":@"机构投资者";
        
        
        label =(UILabel*) [scrollView viewWithTag:10003];
        label.text =@"公司名称";
        
        label =(UILabel*) [scrollView viewWithTag:10004];
        label.text = [dic valueForKey:@"company"];
        
        
        label =(UILabel*) [scrollView viewWithTag:10005];
        label.text = @"投资领域";
        
        
        NSString* str=@"";
        NSMutableArray* arr =[dic valueForKey:@"industry"];
        for (int i=0; i<arr.count; i++) {
            str = [str stringByAppendingFormat:@" %@",arr[i]];
        }
        label =(UILabel*) [scrollView viewWithTag:10006];
        label.text = str;
        
        label =(UILabel*) [scrollView viewWithTag:10007];
        label.text = @"基金规模";
        
        label =(UILabel*) [scrollView viewWithTag:10008];
        label.text = [dic valueForKey:@"fund_size_range"];
       
    }
    
}

-(void)selectID:(id)sender
{
    autoView.isHidden = NO;
    autoView.layer.zPosition =1000;
    [autoView removeFromSuperview];
    [scrollView addSubview:autoView];
    autoView.backgroundColor  = BlackColor;
}

-(void)finialSubmmit:(id)sender
{

    
    if (!isChooseID) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请先选择投资人身份"];
    }else{
        NSString* url = [INVEST stringByAppendingFormat:@"%ld/",(long)self.projectId];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        
        UIView* view = [scrollView viewWithTag:30002];
        UITextField* textField = (UITextField*)[view viewWithTag:500001];
        
        NSString* mount =textField.text;
        mount = [mount stringByReplacingOccurrencesOfString:@"万元" withString:@""];
        [dic setValue:mount forKey:@"invest_amount"];
        [dic setValue:[currentDic valueForKey:@"id"] forKey:@"investor"];
        [dic setValue:[NSString stringWithFormat:@"%d",currentSelect] forKey:@"flag"];
        [httpUtils getDataFromAPIWithOps:url postParam:dic type:0 delegate:self sel:@selector(requestFinialSubmmmit:)];
        
        loadingView.isTransparent = YES;
        [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    }
}

-(void)loadData
{
    loadingView = [LoadingUtil shareinstance:self.view];
    loadingView.isTransparent = NO;
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    [httpUtils getDataFromAPIWithOps:MY_INVESTID postParam:nil type:0 delegate:self sel:@selector(requestInvestList:)];
}

-(void)doAction:(UITapGestureRecognizer*)recognizer
{
    
    FinialKind* finialKind = (FinialKind*)recognizer.view;
    if (finialKind) {
        currentTag =finialKind.tag;
    }
    
    if (currentSelect==0) {
        if (currentTag == 20001) {
            currentSelect=1;
            finialKind.backgroundColor = ColorTheme;
            finialKind.label.textColor =WriteColor;
            [finialKind setImageWithNmame:@"Lead investor-white" setText:@"我要领投"];
            FinialKind* view = (FinialKind*)[scrollView viewWithTag:20002];
            view.backgroundColor = WriteColor;
            view.label.textColor = ColorTheme2;
            [view setImageWithNmame:@"With investment" setText:@"我要跟投"];
        }
        
    }else{
        if (currentTag == 20002) {
            currentSelect=0;
            finialKind.backgroundColor = ColorTheme;
            finialKind.label.textColor =WriteColor;
            [finialKind setImageWithNmame:@"With investment-white" setText:@"我要跟投"];
            FinialKind* view = (FinialKind*)[scrollView viewWithTag:20001];
            view.backgroundColor = WriteColor;
            
            view.label.textColor = ColorCompanyTheme;
            [view setImageWithNmame:@"Lead investor" setText:@"我要领投"];
        }
    }
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString* textStr = textField.text;
    if (textStr && textStr.length>0) {
        textStr = [NSString stringWithFormat:@" %@万元",textStr];
        textField.text = textStr;
        
    }
    [textField resignFirstResponder];
}

-(void)resignKeyboard
{
    //收起键盘
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(id)sender
{
    
}

#pragma ASIHttpRequeste
-(void)requestInvestList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            autoView = [[AutoShowView alloc]initWithFrame:CGRectMake(10, 100, WIDTH(self.view)-20, 150)];
            autoView.dataArray =[jsonDic valueForKey:@"data"];
            autoView.tag = 100001;
            autoView.isHidden = YES;
            autoView.title=@"company";
            autoView.backgroundColor = GreenColor;
            [scrollView addSubview:autoView];
            
            [LoadingUtil closeLoadingView:loadingView];
        }
        
    }
}

-(void)requestIDInfoDetail:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            NSDictionary* data = [jsonDic valueForKey:@"data"];
            [self IDInfoDetail:data];
        }
    }
}

-(void)requestFinialSubmmmit:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            [LoadingUtil closeLoadingView:loadingView];
            [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"信息提交成功!"];
            
            
            FinialSuccessViewController* controller =[[FinialSuccessViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            [LoadingUtil closeLoadingView:loadingView];
            [[DialogUtil sharedInstance] showDlg:self.view textOnly:@"信息提交失败!"];
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
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
