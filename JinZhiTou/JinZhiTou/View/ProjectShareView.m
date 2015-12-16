//
//  ProjectShareView.m
//  JinZhiTou
//
//  Created by air on 15/9/17.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ProjectShareView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation ProjectShareView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        frame.origin.y = 0;
        UIView* v = [[UIView alloc]initWithFrame:frame];
        v.backgroundColor=BlackColor;
        v.alpha = 0.5;
        [self addSubview:v];
        
        self.favouiteImgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-80, HEIGHT(self)/2-10, 20, 20)];
        self.favouiteImgView.contentMode  =UIViewContentModeScaleAspectFill;
        self.favouiteImgView.image = IMAGENAMED(@"dianzan_selected");
        self.favouiteImgView.userInteractionEnabled = YES;
        [self addSubview:self.favouiteImgView];
        
        self.shareImgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.favouiteImgView)+20, Y(self.favouiteImgView), WIDTH(self.favouiteImgView), HEIGHT(self.favouiteImgView))];
        self.shareImgView.contentMode  =UIViewContentModeScaleAspectFill;
        self.shareImgView.image = IMAGENAMED(@"share_normal");
        self.shareImgView.userInteractionEnabled = YES;
        [self addSubview:self.shareImgView];
    }
    return self;
}

@end
