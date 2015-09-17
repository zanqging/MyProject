
//
//  RoadShowFooter.m
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RoadShowFooter.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation RoadShowFooter
{
    UITextView* textView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 30)];
        imageView.image = IMAGENAMED(@"news");
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        
        UILabel * lbl = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, Y(imageView), WIDTH(self)-POS_X(imageView), 30)];
        lbl.textAlignment = NSTextAlignmentLeft;
        lbl.font = SYSTEMFONT(16);
        lbl.text = @"公司重大新闻";
        [self addSubview:lbl];
        
        //绘制虚线
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, POS_Y(lbl)-10, WIDTH(self)-40, 20)];
        [self addSubview:imageView1];
        
        
        UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
        [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
        
        
        CGFloat lengths[] = {10,5};
        CGContextRef line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, BACKGROUND_LIGHT_GRAY_COLOR.CGColor);
        
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0.0, 20.0);    //开始画线
        CGContextAddLineToPoint(line, 310.0, 20.0);
        CGContextStrokePath(line);
        
        imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(imageView1)+20, WIDTH(self), 25)];
        self.titleLabel.font  =SYSTEMFONT(18);
        self.titleLabel.textAlignment  = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.dateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(self.titleLabel), WIDTH(self), 25)];
        self.dateTimeLabel.font  =SYSTEMFONT(14);
        self.dateTimeLabel.textAlignment  = NSTextAlignmentCenter;
        [self addSubview:self.dateTimeLabel];
        
        textView = [[UITextView alloc]initWithFrame:CGRectMake(10, POS_Y(self.dateTimeLabel)+10, WIDTH(self)-20, HEIGHT(self)-100)];
        textView.editable = NO;
        textView.font = SYSTEMFONT(14);
        [self addSubview:textView];
        
        self.backgroundColor = WriteColor;
    }
    return self;
}

-(void)setContent:(NSString *)content
{
    if (content.class !=NSNull.class) {
         textView.text = content;
    }
}
@end
