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
}
@end
@implementation RoadShowBottom

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //分割线
        UIImageView* imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), 1)];
        imgView.backgroundColor = RGBACOLOR(216, 216, 216, 1);
        [self addSubview:imgView];
        
        UITapGestureRecognizer *  recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contact:)];
        UILabel* lbl = [[UILabel alloc]initWithFrame:CGRectMake(0,10, WIDTH(self)/2, HEIGHT(self)-30)];
        lbl.text = @"联系我们";
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled = YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contact:)];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/4-10, POS_Y(lbl), 20, 20)];
        imageView.image = IMAGENAMED(@"tel");
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:recognizer];
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        
        
        self.btnFunction = [[UIButton alloc]initWithFrame:CGRectMake(POS_X(lbl), Y(lbl), WIDTH(lbl), HEIGHT(lbl))];
        self.btnFunction.layer.cornerRadius = 5;
        [self.btnFunction setTitle:@"来现场" forState:UIControlStateNormal];
        [self.btnFunction.titleLabel setFont:SYSTEMFONT(14)];
        [self.btnFunction setTitleColor:BlackColor forState:UIControlStateNormal];
        [self addSubview:self.btnFunction];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)*3/4-10, POS_Y(lbl), 20, 20)];
        imageView.image = IMAGENAMED(@"tel");
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:recognizer];
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        
        
        self.backgroundColor = WriteColor;
        
    }
    return self;
}


-(void)contact:(id)sender
{
    if (!httpUtils) {
        httpUtils  =[[HttpUtils alloc]init];
    }
    [httpUtils getDataFromAPIWithOps:CUSTOMSERVICE postParam:nil type:0 delegate:self sel:@selector(requestCustomService:)];
}
-(void)setType:(int)type
{
    self->_type = type;
    if (self.type == 1) {
        [self.btnFunction setTitle:@"来现场" forState:UIControlStateNormal];
    }else if(self.type==2){
        [self.btnFunction setTitle:@"我要投资" forState:UIControlStateNormal];
    }else{
        self.btnFunction.enabled = NO;
        [self.btnFunction setTitle:@"融资完毕" forState:UIControlStateNormal];
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
