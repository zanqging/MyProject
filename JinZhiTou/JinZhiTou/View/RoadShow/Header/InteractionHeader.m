//
//  InteractionHeader.m
//  JinZhiTou
//
//  Created by air on 15/7/29.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "InteractionHeader.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation InteractionHeader

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, WIDTH(self), 30)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.text = @"互动专栏(3)";
        [self addSubview:self.titleLabel];
        
        //绘制虚线
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(self.titleLabel)+10, WIDTH(self), 20)];
        [self addSubview:imageView1];
        
        
        UIGraphicsBeginImageContext(imageView1.frame.size);   //开始画线
        [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
        
        
        CGFloat lengths[] = {10,5};
        CGContextRef line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, ColorTheme.CGColor);
        
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0.0, 20.0);    //开始画线
        CGContextAddLineToPoint(line, 310.0, 20.0);
        CGContextStrokePath(line);
        
        imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.backgroundColor = WriteColor;
        
    }
    return self;
}
@end
