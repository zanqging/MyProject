//
//  FinialPersonTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/8/1.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialPersonTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation FinialPersonTableViewCell


-(void)layoutPre
{
    
    if (!self.quiodImgView.image) {
        UIGraphicsBeginImageContext(self.quiodImgView.frame.size);   //开始画线
        [self.quiodImgView.image drawInRect:CGRectMake(0, 0, self.quiodImgView.frame.size.width, self.quiodImgView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
        
        
        CGFloat lengths[] = {10,5};
        CGContextRef line = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(line, ColorTheme.CGColor);
        
        CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
        CGContextMoveToPoint(line, 0.0, 20.0);    //开始画线
        CGContextAddLineToPoint(line, 310.0, 20.0);
        CGContextStrokePath(line);
        
        self.quiodImgView.image = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    self.personImgview.layer.cornerRadius = 25;
    self.personImgview.layer.masksToBounds = YES;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
