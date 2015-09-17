//
//  SlideView.m
//  WeiNI
//
//  Created by air on 15/3/5.
//  Copyright (c) 2015年 weini. All rights reserved.
//

#import "SlideViewStartPage.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation SlideViewStartPage
@synthesize btnStart;
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=WriteColor;
        CGRect rect=self.bounds;
        imageView=[[UIImageView alloc]initWithFrame:rect];
        UIImage* image=[UIImage imageNamed:@"Guide5"];
        imageView.image=image;
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        
        //即刻开启
        btnStart=[[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/4, frame.size.height-150, frame.size.width/2, 40)];
        btnStart.layer.borderWidth =1;
        btnStart.layer.cornerRadius = 20;
        btnStart.backgroundColor =ColorTheme;
        btnStart.layer.borderColor =ColorTheme.CGColor;
        [btnStart setTitle:@"即刻开启" forState:UIControlStateNormal];
        [btnStart.titleLabel setFont:[UIFont fontWithName:@"Arial" size:22]];
        [btnStart setImageEdgeInsets:UIEdgeInsetsMake(0,frame.size.width/3+30, 0, 0)];
        [btnStart setTitleColor:WriteColor forState:UIControlStateNormal];
        [self addSubview:btnStart];
        
    }
    return self;
}

@end
