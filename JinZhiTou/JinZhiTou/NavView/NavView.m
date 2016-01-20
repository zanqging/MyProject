//
//  NavView.m
//  WeiNI
//
//  Created by air on 15/1/24.
//  Copyright (c) 2015年 weini. All rights reserved.
//

#import "NavView.h"
#import "TDUtil.h"
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
        self.backgroundColor=ColorTheme;
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, HEIGHT(self))];
        [self addSubview:self.backView];
        //返回箭头
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, (frame.size.height-25)/2, 10, 25)];
        self.imageView.image=[UIImage imageNamed:@"ic_back"];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        self.imageView.userInteractionEnabled=YES;
        [self.backView addSubview:self.imageView];
        
        //左边日历
        leftButton = [[UIButton alloc]initWithFrame:leftButtonRect];
        [leftButton setImage:[UIImage imageNamed:@"ic_toolbar_calendar"]forState:UIControlStateNormal];
        leftButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [leftButton.titleLabel setFont:SYSTEMFONT(16)];
        [self addSubview:leftButton];
        
        //标题
        titleLable=[[UILabel alloc]initWithFrame:titleLableRect];
        titleLable.textColor=WriteColor;
        titleLable.userInteractionEnabled=YES;
        titleLable.textAlignment=NSTextAlignmentCenter;
        titleLable.font=SYSTEMBOLDFONT(18);
        [self addSubview:titleLable];
        
        //右边个人中心
        rightButton = [[UIButton alloc]initWithFrame:rightButtonRect];
        [rightButton.titleLabel setFont:SYSTEMFONT(18)];
        [rightButton setImage:[UIImage imageNamed:@"ic_toolbar_profile"]forState:UIControlStateNormal];
        [self addSubview:rightButton];
        
        
        //左边－触摸感应区域
        self.leftTouchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self)/2, HEIGHT(self))];
        self.leftTouchView.userInteractionEnabled  =YES;
        [self addSubview:self.leftTouchView];
        //右边 - 触摸感应区域
        self.rightTouchView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH(self)/2, 0, WIDTH(self.leftTouchView), HEIGHT(self.leftTouchView))];
        self.rightTouchView.userInteractionEnabled  =YES;
        [self addSubview:self.rightTouchView];
    
        

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

-(void)setIsHasNewMessage:(BOOL)isHasNewMessage
{
    self->_isHasNewMessage = isHasNewMessage;
    UIImageView* v = (UIImageView*)[self viewWithTag:40001];
    if (self.isHasNewMessage) {
        if (!v) {
            UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.imageView)+25, Y(leftButton)+18, 7, 7)];
            imgView.tag =40001;
            imgView.backgroundColor = WriteColor;
            imgView.layer.cornerRadius = 3.5;
            imgView.layer.masksToBounds = YES;
            [self addSubview:imgView];
        }
    }else{
        if (v) {
            [v removeFromSuperview];
        }
    }
}

-(void)setMenuArray:(NSMutableArray *)menuArray
{
    self->_menuArray = menuArray;
    if (self.menuArray && self.menuArray.count>0) {
        [self.titleLable removeFromSuperview];
        UILabel* label;
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, HEIGHT(self))];
        [TDUtil setLabelMutableText:label content:self.menuArray[0] lineSpacing:0 headIndent:0];
        
        float width = WIDTH(label)+20;
        int index = -1;
        int tapIndex = -1;
        for (int i = 0; i<self.menuArray.count; i++) {
            label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)/2+width*index+tapIndex*5, HEIGHT(self)/4, width, HEIGHT(self)/2)];
            label.textColor = WriteColor;
            if (self.currentSelectedIndex ==i) {
                label.font = SYSTEMBOLDFONT(18);
                label.layer.cornerRadius=2;
                label.layer.borderColor = WriteColor.CGColor;
                label.layer.borderWidth=1;
            }else{
                label.font  =SYSTEMFONT(16);
                label.layer.cornerRadius=0;
                label.layer.borderColor = ClearColor.CGColor;
                label.layer.borderWidth=0;
            }
            label.tag = i+1000;
            label.text = self.menuArray[i];
//            [TDUtil setLabelMutableText:label content:self.menuArray[i] lineSpacing:0 headIndent:0];
            label.userInteractionEnabled  = YES;
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)]];
            label.textAlignment  =NSTextAlignmentCenter;
            [self addSubview:label];
            
            index =0;
            tapIndex = 1;
        }
    }
}

-(void)tapAction:(UITapGestureRecognizer*)sender
{
    for (int i = 0; i<self.menuArray.count; i++) {
        UILabel* label = [self viewWithTag:i+1000];
        label.font  = SYSTEMFONT(16);
        label.layer.cornerRadius=0;
        label.layer.borderColor = ClearColor.CGColor;
        label.layer.borderWidth=0;
    }
    
    UILabel* label = (UILabel*)sender.view;
    label.font  = SYSTEMBOLDFONT(18);
    label.layer.cornerRadius=2;
    label.layer.borderColor = WriteColor.CGColor;
    label.layer.borderWidth=1;
    
    if ([_delegate respondsToSelector:@selector(navView:tapIndex:)]) {
        [_delegate navView:self tapIndex:(int)(label.tag-1000)];
    }
}

//- (void)DrawGradientColor:(CGContextRef)context
//                     rect:(CGRect)clipRect
//                    point:(CGPoint) startPoint
//                    point:(CGPoint) endPoint
//                  options:(CGGradientDrawingOptions) options
//               startColor:(UIColor*)startColor
//                 endColor:(UIColor*)endColor
//{
//    UIColor* colors [2] = {startColor,endColor};
//    CGColorSpaceRef rgb =CGColorSpaceCreateDeviceRGB();
//    CGFloat colorComponents[8];
//    
//    for (int i = 0; i < 2; i++) {
//        UIColor *color = colors[i];
//        CGColorRef temcolorRef = color.CGColor;
//        
//        const CGFloat *components = CGColorGetComponents(temcolorRef);
//        for (int j = 0; j < 4; j++) {
//            colorComponents[i *4 + j] = components[j];
//        }
//    }
//    
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colorComponents,NULL, 2);
//    
//    CGColorSpaceRelease(rgb);
//    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, options);
//    CGGradientRelease(gradient);
//}

@end
