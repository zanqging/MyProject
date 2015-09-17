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
@implementation BedgesView
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor =ClearColor;
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    //取得画布
    UIColor* readColor = [UIColor redColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,readColor.CGColor);
    //填充园
    CGContextAddArc(context, WIDTH(self)/2, HEIGHT(self)/2, WIDTH(self)/2, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFill);
    
    //绘制文字
    UIFont* font = SYSTEMFONT(14);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle,NSForegroundColorAttributeName:WriteColor};

    rect = CGRectInset(rect, 1, 1);
    [@"10" drawInRect:rect withAttributes:attributes];
}

@end
