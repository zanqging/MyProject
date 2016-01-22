//
//  LoadingView.m
//  JinZhiTou
//
//  Created by air on 15/8/12.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "LoadingView.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation LoadingView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-50, HEIGHT(self)/2-50, 130, 130)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        
        [self loadImages];
        
        self.backgroundColor = WriteColor;
    }
    return self;
}

-(void)loadImages
{
    NSArray *magesArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"jz1"],
                           [UIImage imageNamed:@"jz2"],
                           [UIImage imageNamed:@"jz3"],
                           [UIImage imageNamed:@"jz4"],
                           [UIImage imageNamed:@"jz5"],
                           [UIImage imageNamed:@"jz6"],
                           [UIImage imageNamed:@"jz7"],
                           [UIImage imageNamed:@"jz8"],
                           [UIImage imageNamed:@"jz9"],
                           [UIImage imageNamed:@"jz10"],
                           [UIImage imageNamed:@"jz11"],nil];
    
    imageView.animationImages = magesArray;//将序列帧数组赋给UIImageView的animationImages属性
    imageView.animationDuration = 3.0;//设置动画时间
    imageView.animationRepeatCount = 0;//设置动画次数 0 表示无限
}
-(void)startAnimation
{
    [imageView startAnimating];
}

-(void)stopAnitmation
{
    [imageView stopAnimating];
}

-(void)setIsTransparent:(BOOL)isTransparent
{
    self->_isTransparent = isTransparent;
    if (self.isTransparent) {
        self.backgroundColor = ClearColor;
    }else{
        self.backgroundColor = WriteColor;
    }
}

-(void)setIsError:(BOOL)isError
{
    self->_isError = isError;
    if(self.isError){
        [self stopAnitmation];
        [imageView removeFromSuperview];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-75, 100, 150, 150)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        imageView.image = IMAGE(@"error", @"png");
        
        if (!labelMessage) {
            labelMessage = [[UILabel alloc]initWithFrame:CGRectMake(30, POS_Y(imageView)+20, WIDTH(self)-60,20)];
            labelMessage.font = SYSTEMFONT(16);
            labelMessage.textAlignment = NSTextAlignmentCenter;

            refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)/2-60, POS_Y(labelMessage), 120, 40)];
            refreshButton.layer.borderWidth =1;
            refreshButton.layer.cornerRadius =5;
            refreshButton.layer.borderColor = AppColorTheme.CGColor;
            [refreshButton setTitle:@"立即重载" forState:UIControlStateNormal];
            [refreshButton setTitleColor:AppColorTheme forState:UIControlStateNormal];
             [refreshButton setTitleColor:WriteColor forState:UIControlStateSelected];
            [refreshButton setImage:IMAGENAMED(@"shuaxin") forState:UIControlStateNormal];
            [refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview:labelMessage];
        [self addSubview:refreshButton];
        
    }else{
        [imageView removeFromSuperview];
        [labelMessage removeFromSuperview];
        [refreshButton removeFromSuperview];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-50, HEIGHT(self)/2-50, 100, 100)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        [self loadImages];
        [self startAnimation];
    }
}

-(void)refresh
{
    if ([self.delegate respondsToSelector:@selector(refresh)]) {
        [self.delegate refresh];
    }
}
-(void)setContent:(NSString *)content
{
    self->_content = content;
    if (self.content) {
        [TDUtil setLabelMutableText:labelMessage content:content lineSpacing:3 headIndent:0];
        //重新设置按钮位置
        [refreshButton setFrame:CGRectMake(WIDTH(self)/2-50, POS_Y(labelMessage), 100, 40)];
    }
}

@end
