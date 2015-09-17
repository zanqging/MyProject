//
//  UploadingView.m
//  JinZhiTou
//
//  Created by air on 15/8/15.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UploadingView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation UploadingView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WriteColor;
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-20, 40, 40, 40)];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imgView];
        
        [self loadImages];
        
        
        progressView = [[THProgressView alloc] initWithFrame:CGRectMake(30, HEIGHT(self)/2, WIDTH(self)-60, 20)];
        progressView.borderTintColor = BackColor;
        progressView.progressTintColor = ColorTheme;
        [self addSubview:progressView];
        
        self.progressViews = @[ progressView ];
        
        
        self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(progressView)+10, WIDTH(self), 30)];
        self.progressLabel.textColor = ColorTheme;
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.progressLabel];
        
       
    }
    return self;
}

-(void)loadImages
{
    NSArray *magesArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"person1.png"],
                           [UIImage imageNamed:@"person2.png"],
                           [UIImage imageNamed:@"person3.png"],
                           [UIImage imageNamed:@"person4.png"],
                           [UIImage imageNamed:@"person5.png"],
                           [UIImage imageNamed:@"person6.png"],
                           [UIImage imageNamed:@"person7.png"],
                           [UIImage imageNamed:@"person8.png"]
                           ,nil];
    
    self.imgView.animationImages = magesArray;//将序列帧数组赋给UIImageView的animationImages属性
    self.imgView.animationDuration = 1;//设置动画时间
    self.imgView.animationRepeatCount = 0;//设置动画次数 0 表示无限
}
-(void)startAnimation
{
    [self.imgView startAnimating];
}

-(void)stopAnitmation
{
    [self.imgView stopAnimating];
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

-(void)setProgress:(float)progress
{
    
    [self performSelectorOnMainThread:@selector(setProgressData:) withObject:[NSString stringWithFormat:@"%f",progress] waitUntilDone:YES];
}

-(void)setProgressData:(NSString*)data{
    float progress = [data floatValue];
    if (progress > 1.0f) {
        progress = 1;
    }
    
    //主线程更新绘制
    [progressView setProgress:progress animated:YES];
    NSString* str =[NSString stringWithFormat:@"uploading(%.f)",progress*100];
    str = [str stringByAppendingString:@"%"];
    self.progressLabel.text =str;
    
}
@end
