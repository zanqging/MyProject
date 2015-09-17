//
//  LoadVideo.m
//  JinZhiTou
//
//  Created by air on 15/8/15.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "LoadVideo.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation LoadVideo
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = WriteColor;
        self.layer.borderColor = BackColor.CGColor;
        
    }
    return self;
}


-(void)setIsLoaded:(BOOL)isLoaded
{
    if (!isLoaded) {
        if (!self.thumailView) {
            //视频提示图
            self.thumailView = [[UIImageView alloc ]initWithFrame:CGRectMake(WIDTH(self)/2-25, 40, 50, 50)];
            self.thumailView.contentMode = UIViewContentModeScaleAspectFill;
            self.thumailView.image = IMAGENAMED(@"radio");
            
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(self.thumailView)+5, WIDTH(self), 25)];
            self.titleLabel.font = SYSTEMFONT(12);
            self.titleLabel.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.text = @"点击上传项目VCR";
            
            self.descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(self.titleLabel), WIDTH(self), 25)];
            self.descLabel.font = SYSTEMFONT(12);
            self.descLabel.textAlignment = NSTextAlignmentCenter;
            self.descLabel.text = @"(可简单介绍公司,项目,团队等,需1-2分钟视频)";
            self.descLabel.textColor = ColorTheme;
        }
        [self addSubview:self.thumailView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.descLabel];
    }else{
        [self.thumailView removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.descLabel removeFromSuperview];
    }
    
}

-(void)setUploadStart:(BOOL)uploadStart
{
    self->_uploadStart = uploadStart;
    if (uploadStart) {
        CGRect frame =self.frame;
        frame.origin.y = 0;
        frame.origin.x = 0;
        loadingView = [[UploadingView alloc]initWithFrame:frame];
        [loadingView startAnimation];
        [self addSubview:loadingView];
        
        self.isLoaded = YES;
    }else{
        [loadingView stopAnitmation];
        [loadingView removeFromSuperview];
    }
}

-(void)setIsComplete:(BOOL)isComplete
{
    self->_isComplete = isComplete;
    if (isComplete) {
        if (!self.deleteImgView) {
            self.deleteImgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-40, 0, 30, 50)];
            self.deleteImgView.image = IMAGENAMED(@"mingpshanchu");
            self.deleteImgView.userInteractionEnabled = YES;
            [self.deleteImgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteAction:)]];
            self.deleteImgView.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:self.deleteImgView];
        }
    }else{
        [self.deleteImgView removeFromSuperview];
    }
}

-(void)deleteAction:(id)sender
{
    [self.imgView setImage:nil];
    [self.deleteImgView setImage:nil];
    [self setIsLoaded:NO];
}
-(void)setImgage:(UIImage *)imgage
{
    if (imgage) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
        self->_imgage = imgage;
        self.imgView.image = self.imgage;
        [self addSubview:self.imgView];
    }
}

-(void)setProgress:(float)progress
{
    self->_progress = progress;
    loadingView.progress = self.progress;
}
@end
