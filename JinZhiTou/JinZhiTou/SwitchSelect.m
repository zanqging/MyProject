//
//  SwitchSelect.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "SwitchSelect.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation SwitchSelect
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel* label= [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH(self), HEIGHT(self)-10)];
        label.tag =100001;
        label.font = SYSTEMFONT(14);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-5, POS_Y(label)-10, 10, 10)];
        imgView.tag  =100002;
        imgView.contentMode =UIViewContentModeScaleAspectFill;
        [self addSubview:imgView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame type:(int)type
{
    if (self = [super initWithFrame:frame]) {
        UILabel* label= [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH(self), HEIGHT(self)-10)];
        label.tag =100001;
        label.font = SYSTEMFONT(14);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(40, POS_Y(label)-10,WIDTH(label)-80, 2)];
        imgView.tag  =100002;
        imgView.contentMode =UIViewContentModeScaleAspectFill;
        [self addSubview:imgView];
        
        self.type = type;
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected
{
    self->_isSelected = isSelected;
    if (self.type==0) {
        if (isSelected) {
            UILabel* label = (UILabel*)[self viewWithTag:100001];
            label.textColor = ColorTheme;
            UIImageView* imgView = (UIImageView*)[self viewWithTag:100002];
            imgView.image = IMAGENAMED(@"shangsanjiao");
        }else{
            UILabel* label = (UILabel*)[self viewWithTag:100001];
            label.textColor = BlackColor;
            UIImageView* imgView = (UIImageView*)[self viewWithTag:100002];
            imgView.image = nil;
        }
    }else{
        if (isSelected) {
            UILabel* label = (UILabel*)[self viewWithTag:100001];
            label.textColor = ColorTheme;
            UIImageView* imgView = (UIImageView*)[self viewWithTag:100002];
            imgView.backgroundColor = ColorTheme;
        }else{
            UILabel* label = (UILabel*)[self viewWithTag:100001];
            label.textColor = BlackColor;
            UIImageView* imgView = (UIImageView*)[self viewWithTag:100002];
            imgView.backgroundColor = ClearColor;
        }
    }
    
}

-(void)setTitleName:(NSString *)titleName
{
    self->_titleName = titleName;
    UILabel* label = (UILabel*)[self viewWithTag:100001];
    if (titleName) {
        label.text = titleName;
    }
    
}

@end
