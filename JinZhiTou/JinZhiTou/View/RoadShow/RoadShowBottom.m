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
        UIImageView* imgView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), 1)];
        imgView.backgroundColor = RGBACOLOR(216, 216, 216, 1);
        [self addSubview:imgView];
        
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contact:)];
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, HEIGHT(self)/2-10, 20, 20)];
        imageView.image = IMAGENAMED(@"tel");
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:recognizer];
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contact:)];
        UILabel* lbl = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+5, 10, 70, HEIGHT(self)-20)];
        lbl.text = @"联系我们";
        lbl.font = SYSTEMFONT(14);
        lbl.userInteractionEnabled = YES;
        [lbl addGestureRecognizer:recognizer];
        lbl.textAlignment = NSTextAlignmentLeft;
        [self addSubview:lbl];
        
        self.btnFunction = [[UIButton alloc]initWithFrame:CGRectMake(POS_X(lbl), 10, 190, 30)];
        self.btnFunction.layer.cornerRadius = 5;
        [self.btnFunction setTitle:@"来现场" forState:UIControlStateNormal];
        self.btnFunction.backgroundColor = ColorTheme;
        [self addSubview:self.btnFunction];
        
        self.backgroundColor = WriteColor;
        
    }
    return self;
}


-(void)contact:(id)sender
{
    httpUtils = [[HttpUtils alloc]init];
    [httpUtils getDataFromAPIWithOps:CONTACT_US postParam:nil type:0 delegate:self sel:@selector(requestContact:)];
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
        [self.btnFunction setBackgroundColor:BACKGROUND_COLOR];
        [self.btnFunction setTitleColor:WriteColor forState:UIControlStateNormal];
        [self.btnFunction setTitle:@"融资已结束" forState:UIControlStateNormal];
    }
}


#pragma ASIHttpRequeste
-(void)requestContact:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            NSDictionary* dic =[jsonDic valueForKey:@"data"];
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[dic valueForKey:@"telephone"]];
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
