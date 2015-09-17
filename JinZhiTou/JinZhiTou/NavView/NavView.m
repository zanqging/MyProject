//
//  NavView.m
//  WeiNI
//
//  Created by air on 15/1/24.
//  Copyright (c) 2015年 weini. All rights reserved.
//

#import "NavView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#define leftButtonRect CGRectMake(25,0,100,frame.size.height)
#define titleLableRect CGRectMake(60, 0, self.frame.size.width-120, frame.size.height)
#define rightButtonRect CGRectMake(self.frame.size.width-50,0,40,frame.size.height)
@implementation NavView
@synthesize leftButton,rightButton,titleLable;
-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //透明背景
        self.backgroundColor=[UIColor clearColor];
        
        //返回箭头
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, (frame.size.height-25)/2, 10, 25)];
        self.imageView.image=[UIImage imageNamed:@"ic_back"];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        self.imageView.userInteractionEnabled=YES;
        [self addSubview:self.imageView];
        
        //左边日历
        leftButton = [[UIButton alloc]initWithFrame:leftButtonRect];
        leftButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        leftButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
        [leftButton setImage:[UIImage imageNamed:@"ic_toolbar_calendar"]forState:UIControlStateNormal];
        [leftButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16.0f]];
        [self addSubview:leftButton];
        
        //标题
        titleLable=[[UILabel alloc]initWithFrame:titleLableRect];
        titleLable.textColor=WriteColor;
        titleLable.userInteractionEnabled=YES;
        titleLable.textAlignment=NSTextAlignmentCenter;
        titleLable.font=[UIFont fontWithName:@"Arial" size:18.0f];
        [self addSubview:titleLable];
        
        //右边个人中心
        rightButton = [[UIButton alloc]initWithFrame:rightButtonRect];
        [rightButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:18.0f]];
        [rightButton setImage:[UIImage imageNamed:@"ic_toolbar_profile"]forState:UIControlStateNormal];
        [self addSubview:rightButton];
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    self->_title=title;
    
    //按照字符长度
    NSInteger length=title.length;
    
    //长度
    if (length>12) {
        title=[title substringToIndex:10];
        length=10;
    }
    titleLable.text=title;
    
    CGRect frame=titleLable.frame;
    if(self.isLocation){
        frame.size.width=length*16;
    }else{
        frame.size.width=length*18;
    }
    
    frame.origin.x=(WIDTH(self)-frame.size.width)/2;
    
    frameCurrent=frame;
    titleLable.frame=frame;
    
    //[self setIsLocation:self.isLocation];
}

-(void)setNavAnimation:(NSString *)type offset:(CGPoint)offset
{
    float pageWidth=self.frame.size.width;
    int currentPage = floor((offset.x - pageWidth/2)/pageWidth)+1;
    //页面切换
    if (currentPage==0) {
        
        [rightButton setAlpha:0];
        [rightButton setImage:[UIImage imageNamed:@"ic_today"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"ic_toolbar_calendar"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5 animations:^{
            rightButton.alpha=1;
        }];
    }else if (currentPage==2){
        [UIView animateWithDuration:0.5 animations:^{
            rightButton.alpha=0;
        }];
        
        [leftButton setAlpha:0];
        [leftButton setImage:[UIImage imageNamed:@"ic_today"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5 animations:^{
            leftButton.alpha=1;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            leftButton.alpha=1;
            rightButton.alpha=1;
        }];
        
        [leftButton setAlpha:0];
        [rightButton setAlpha:0];
        [leftButton setImage:[UIImage imageNamed:@"ic_menu_record"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"ic_toolbar_profile"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5 animations:^{
            leftButton.alpha=1;
            rightButton.alpha=1;
        }];
    }
}

-(void)setIsLocation:(BOOL)isLocation
{
    self->_isLocation=isLocation;
    if (titleLable.text) {
        CGRect frame=frameCurrent;
        
        UIImageView* imageView=(UIImageView*)[self viewWithTag:10001];
        UIImageView* imageView2=(UIImageView*)[self viewWithTag:10002];
        if (isLocation) {
            if (frame.origin.x<0) {
                frame.origin.x=-frame.origin.x;
            }
            frame.origin.x-=5;
            frame.size.width=10;
            frame.size.height=14;
            frame.origin.y=(HEIGHT(self)-14)/2;
            
            if (!imageView) {
                imageView=[[UIImageView  alloc]init];
                imageView.tag=10001;
                imageView.image=IMAGENAMED(@"location");
            }
            
            imageView.frame=frame;
            [self addSubview:imageView];
            
            frame=self.titleLable.frame;
            
            frame.size.width=14;
            frame.size.height=14;
            frame.origin.y=HEIGHT(self)-15;
            frame.origin.x=(WIDTH(self)-10)/2;
            
            if (!imageView2) {
                imageView2=[[UIImageView alloc]init];
                imageView2.tag=10002;
                imageView2.image=IMAGENAMED(@"location_down");
            }
            
            imageView2.frame=frame;
            [self addSubview:imageView2];
        }else{
            [imageView removeFromSuperview];
            [imageView2 removeFromSuperview];
        }
    }
}
@end
