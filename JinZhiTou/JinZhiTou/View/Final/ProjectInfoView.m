//
//  ProjectInfoView.m
//  JinZhiTou
//
//  Created by air on 15/7/25.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ProjectInfoView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation ProjectInfoView
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        //图片
        UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, WIDTH(self)/3, HEIGHT(self)/2)];
        imageView.backgroundColor=ColorTheme;
        [self addSubview:imageView];
        
        //名称
//        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+5, Y(imageView), WIDTH(self)-POS_X(imageView), HEIGHT(self)/2)];
    }
    return self;
}
@end
