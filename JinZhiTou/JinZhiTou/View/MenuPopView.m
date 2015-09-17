//
//  MenuView.m
//  JinZhiTou
//
//  Created by air on 15/8/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "MenuPopView.h"
#import "GlobalDefine.h"
#import "UConstants.h"
@implementation MenuPopView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WriteColor;
    }
    return self;
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    NSInteger count =self.dataArray.count;
    
    float h = HEIGHT(self)/count;
    UIButton * btnAction;
    NSDictionary* dic;
    for (int i = 0; i<count; i++) {
        dic =self.dataArray[i];
        btnAction = [[UIButton alloc]initWithFrame:CGRectMake(5, h*i, WIDTH(self)-10, h)];
        [btnAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btnAction.tag = 1000+i;
        [btnAction setTitle:[dic valueForKey:@"title"] forState:UIControlStateNormal];
        [btnAction setTitleColor:BACKGROUND_LIGHT_GRAY_COLOR forState:UIControlStateNormal];
        [btnAction setImage:IMAGENAMED([dic valueForKey:@"img"]) forState:UIControlStateNormal];
        [self addSubview:btnAction];
        
        UIImageView* lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(btnAction), WIDTH(self), 1)];
        lineImgView.backgroundColor = BackColor;
        [self addSubview:lineImgView];
    }
}

-(void)btnAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(button:data:)]) {
        NSInteger tag = ((UIButton*)sender).tag;
        NSDictionary* dic = self.dataArray[tag-1000];
        [_delegate button:sender data:dic];
    }
}
@end
