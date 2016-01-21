//
//  RoadShowBottom.m
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RoadShowBottom.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
@interface RoadShowBottom()<ASIHTTPRequestDelegate>
{
    HttpUtils* httpUtils;
    UIView * leftTouchView;
    UIView * rightTouchView;
    
    UIImageView* leftImageView;
    UIImageView* rightImageView;
}
@end
@implementation RoadShowBottom

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置默认背景
        self.backgroundColor = BackColor;
        //左触发视图
        leftTouchView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, WIDTH(self)/2-12.5, HEIGHT(self)-10)];
        //右触发视图
        rightTouchView = [[UIView alloc]initWithFrame:CGRectMake(POS_X(leftTouchView)+2.5, Y(leftTouchView), WIDTH(leftTouchView), HEIGHT(leftTouchView))];
        
        
        [self addSubview:leftTouchView];
        [self addSubview:rightTouchView];
        
        //分割线
        UIImageView* imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), 1)];
        imgView.backgroundColor = RGBACOLOR(216, 216, 216, 1);
        [self addSubview:imgView];
        
        UILabel* lbl = [[UILabel alloc]initWithFrame:CGRectMake(0,0, WIDTH(leftTouchView), HEIGHT(leftTouchView)-25)];
        lbl.tag = 1000;
        lbl.text = @"联系我们";
        lbl.font = SYSTEMFONT(16);
        lbl.textColor = WriteColor;
        lbl.userInteractionEnabled = YES;
        lbl.textAlignment = NSTextAlignmentCenter;
        [leftTouchView addSubview:lbl];
        
        leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(leftTouchView)/2-10, POS_Y(lbl), 20, 20)];
        leftImageView.image = IMAGENAMED(@"contact");
        leftImageView.layer.cornerRadius = 10;
        leftImageView.layer.masksToBounds = YES;
        [leftTouchView addSubview:leftImageView];
        
        
        self.btnFunction = [[UIButton alloc]initWithFrame:CGRectMake(0,0, WIDTH(lbl), HEIGHT(lbl))];
        self.btnFunction.layer.cornerRadius = 5;
        [self.btnFunction setTitle:@"来现场" forState:UIControlStateNormal];
        [self.btnFunction.titleLabel setFont:SYSTEMFONT(16)];
        [self.btnFunction setTitleColor:WriteColor forState:UIControlStateNormal];
        [rightTouchView addSubview:self.btnFunction];
        
        rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(leftTouchView)/2-10, POS_Y(self.btnFunction), 20, 20)];
        rightImageView.image = IMAGENAMED(@"rongzi");
        rightImageView.userInteractionEnabled = YES;
        rightImageView.layer.cornerRadius = 10;
        rightImageView.layer.masksToBounds = YES;
        [rightTouchView addSubview:rightImageView];
        
        
        UITapGestureRecognizer *  recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contact:)];
        leftTouchView.userInteractionEnabled = YES;
        [leftTouchView addGestureRecognizer:recognizer];
        
    }
    return self;
}


-(void)contact:(id)sender
{
    UIColor * color = leftTouchView.backgroundColor;
    leftTouchView.backgroundColor = BackColor;
    [UIView animateWithDuration:0.5 animations:^{
        leftTouchView.backgroundColor = color;
    }];
    if (!httpUtils) {
        httpUtils  =[[HttpUtils alloc]init];
    }
    [httpUtils getDataFromAPIWithOps:CUSTOMSERVICE postParam:nil type:0 delegate:self sel:@selector(requestCustomService:)];
}
-(void)setType:(int)type
{
    self->_type = type;
    NSDictionary * dic;
    if (self.type == 1) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:AppColorTheme,@"leftBackColor",AppColorTheme,@"rightBackColor",IMAGENAMED(@"contact"),@"leftImage",IMAGENAMED(@"goroadshow"),@"rightImage",nil];
        [self.btnFunction setTitle:@"来现场" forState:UIControlStateNormal];
    }else if(self.type==2){
        dic = [NSDictionary dictionaryWithObjectsAndKeys:AppColorTheme,@"leftBackColor",AppColorTheme,@"rightBackColor",IMAGENAMED(@"contact"),@"leftImage",IMAGENAMED(@"rongzi"),@"rightImage",nil];
        [self.btnFunction setTitle:@"我要投资" forState:UIControlStateNormal];
    }else{
        self.btnFunction.enabled = NO;
        dic = [NSDictionary dictionaryWithObjectsAndKeys:AppColorTheme,@"leftBackColor",ColorTheme,@"rightBackColor",IMAGENAMED(@"contact"),@"leftImage",IMAGENAMED(@"rongzi"),@"rightImage",nil];
        [self.btnFunction setTitle:@"融资完毕" forState:UIControlStateNormal];
    }
    self.dic = dic;
}

-(void)setDic:(NSDictionary *)dic
{
    self->_dic = dic;
    if (self.dic) {
        UIColor * leftBackColor = [self.dic valueForKey:@"leftBackColor"];
        UIColor * rightBackColor = [self.dic valueForKey:@"rightBackColor"];
        
        UIImage * leftImage = [self.dic valueForKey:@"leftImage"];
        UIImage * rightImage = [self.dic valueForKey:@"rightImage"];
        
        
        leftTouchView.backgroundColor = leftBackColor;
        rightTouchView.backgroundColor = rightBackColor;
        
        if (!leftImage) {
            
        }else{
            leftImageView.image = leftImage;
        }
        
        if (!rightImage) {
            
        }else{
            rightImageView.image = rightImage;
        }
    }
}

-(void)setIsShowSingle:(BOOL)isShowSingle
{
    self->_isShowSingle = isShowSingle;
    if (isShowSingle) {
        //移除rightTouchView
        [rightTouchView removeFromSuperview];
        
        [leftTouchView setFrame:CGRectMake(X(leftTouchView), Y(leftTouchView), WIDTH(self)-20, HEIGHT(leftTouchView))];
        
        UIView * lbl = [leftTouchView viewWithTag:1000];
        [lbl setFrame:CGRectMake(X(lbl), Y(lbl), WIDTH(leftTouchView)-2*X(lbl), HEIGHT(lbl))];
        [leftImageView setFrame:CGRectMake(WIDTH(leftTouchView)/2-10, Y(leftImageView), WIDTH(leftImageView), HEIGHT(leftImageView))];
    }
}

#pragma ASIHttpRequeste
-(void)requestCustomService:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSMutableArray* array =[jsonDic valueForKey:@"data"];
            NSDictionary* dic  = [array objectAtIndex:0];
            
            //获取第一个电话号码
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[dic valueForKey:@"value"]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self addSubview:callWebview];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{

}

@end
