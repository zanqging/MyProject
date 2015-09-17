//
//  LoadingView.m
//  JinZhiTou
//
//  Created by air on 15/8/12.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "LoadingView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation LoadingView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-60, HEIGHT(self)/2-100, 120, 120)];
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
                           [UIImage imageNamed:@"loading1"],
                           [UIImage imageNamed:@"loading2"],
                           [UIImage imageNamed:@"loading3"],
                           [UIImage imageNamed:@"loading4"],
                           [UIImage imageNamed:@"loading5"],
                           [UIImage imageNamed:@"loading6"],
                           [UIImage imageNamed:@"loading7"],
                           [UIImage imageNamed:@"loading8"],
                           [UIImage imageNamed:@"loading9"],
                           [UIImage imageNamed:@"loading10"],
                           [UIImage imageNamed:@"loading11"],nil];
    
    imageView.animationImages = magesArray;//将序列帧数组赋给UIImageView的animationImages属性
    imageView.animationDuration = 1.5;//设置动画时间
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
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-60, 100, 120, 120)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        imageView.image = IMAGENAMED(@"chucuo");
        
        if (!labelMessage) {
            labelMessage = [[UILabel alloc]initWithFrame:CGRectMake(30, POS_Y(imageView)+10, WIDTH(self)-60, 70)];
            labelMessage.font = SYSTEMFONT(16);
            labelMessage.textAlignment = NSTextAlignmentCenter;

            
            refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)/2-50, POS_Y(labelMessage), 100, 30)];
            refreshButton.layer.borderWidth =1;
            refreshButton.layer.cornerRadius =15;
            refreshButton.layer.borderColor = ColorTheme.CGColor;
            [refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
            [refreshButton setTitleColor:ColorTheme forState:UIControlStateNormal];
            [refreshButton setImage:IMAGENAMED(@"shuaxin") forState:UIControlStateNormal];
            [refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:labelMessage];
        [self addSubview:refreshButton];
        
    }else{
        [imageView removeFromSuperview];
        [labelMessage removeFromSuperview];
        [refreshButton removeFromSuperview];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-60, 100, 120, 120)];
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
        labelMessage.text = content;
    }
}

@end
