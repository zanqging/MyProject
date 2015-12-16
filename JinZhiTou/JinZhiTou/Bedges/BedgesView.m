//
//  BedgesView.m
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "BedgesView.h"
#import "UConstants.h"
#import <math.h>
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation BedgesView
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        CGRect rect = self.bounds;
        imageView = [[UIImageView alloc]initWithFrame:rect];
        imageView.backgroundColor =[UIColor redColor];
        imageView.layer.cornerRadius = HEIGHT(self)/2;
        [self addSubview:imageView];
        
        label = [[UILabel alloc]initWithFrame:self.bounds];
        label.textColor  =WriteColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    return self;
}

-(void)setNumber:(NSString *)number
{
    self->_number = number;
    if ([self.number integerValue]>100) {
        self->_number = @"new";
    }
    
    label.text = self.number;
}
//-(void)drawRect:(CGRect)rect
//{
//    //取得画布
//    UIColor* readColor = [UIColor redColor];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context,readColor.CGColor);
//    //填充园
//    CGContextAddArc(context, WIDTH(self)/2, HEIGHT(self)/2, WIDTH(self)/2, 0, 2*M_PI, 0);
//    CGContextDrawPath(context, kCGPathFill);
//    
//   
//    
//    
//
//    UIFont* font = SYSTEMFONT(14);
//    if ([self.number integerValue]>100) {
//        self.number = @"new";
//        rect = CGRectInset(rect, 1, 4);
//        font = SYSTEMFONT(11);
//    }else{
//        rect = CGRectInset(rect, 1, 4);
//    }
//    //绘制文字
//    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:WriteColor};
//    [self.number drawInRect:rect withAttributes:attributes];
//}

@end
