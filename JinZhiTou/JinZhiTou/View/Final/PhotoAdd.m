//
//  PhotoAdd.m
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "PhotoAdd.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation PhotoAdd
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upload:)];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
        imageView.tag = 10001;
        imageView.backgroundColor = WriteColor;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upload:)];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/4, 10, WIDTH(self)/2-20, WIDTH(self)/4+20)];
        imageView.tag = 10002;
        imageView.backgroundColor = ClearColor;
        imageView.image = IMAGENAMED(@"shangchuan");
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upload:)];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT(self)*3/4, WIDTH(self), HEIGHT(self)/4)];
        label.tag  = 10003;
        label.font = SYSTEMFONT(16);
        label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:recognizer];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        deleteView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-20, 0, 10, 30)];
        deleteView.contentMode = UIViewContentModeScaleAspectFill;
        deleteView.image  = IMAGENAMED(@"mingpshanchu");
        deleteView.alpha = 0;
        [self addSubview:deleteView];
        
        self.layer.cornerRadius =2;
        self.layer.masksToBounds =YES;
    }
    return self;
}

-(void)upload:(id)sender
{
    UIImageView* view =(UIImageView*)[self viewWithTag:10001];
    view.backgroundColor = BACKGROUND_GRAY_COLOR;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"takePhoto" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.tag],@"index", nil]];
}

-(void)setTitle:(NSString *)title

{
    self->_title = title;
    if (title) {
        UILabel* label = (UILabel*)[self viewWithTag:10003];
        if (label) {
            label.text = self.title;
        }
    }
}

-(void)setPlaceImage:(UIImage *)placeImage
{
    self->_placeImage = placeImage;
    UIImageView* imageView=(UIImageView*)[self viewWithTag:10002];
    if (imageView) {
        imageView.image = self.placeImage;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        CGSize size = self.placeImage.size;
        [imageView setFrame:CGRectMake(WIDTH(self)/2-size.width/2, 10, size.width, size.height)];
    }
}

-(void)setImage:(UIImage *)image
{
    self->_image = image;
    UIImageView* imageView=(UIImageView*)[self viewWithTag:10001];
    if (imageView) {
        imageView.image = self.image;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView=(UIImageView*)[self viewWithTag:10002];
        imageView.alpha = 0;
        
        imageView=(UIImageView*)[self viewWithTag:10003];
        imageView.alpha = 0;
        
        deleteView.alpha = 1;
    }
}
@end
