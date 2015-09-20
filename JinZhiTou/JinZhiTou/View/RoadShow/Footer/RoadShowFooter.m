
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
    UILabel* textView;
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
        
        textView = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(self.dateTimeLabel)+10, WIDTH(self)-20, HEIGHT(self)-100)];
        textView.font = SYSTEMFONT(14);
        textView.numberOfLines = 0;
        textView.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:textView];
        
        self.backgroundColor = WriteColor;
    }
    return self;
}

-(void)setContent:(NSString *)content
{
    if (content.class !=NSNull.class) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
    
        [paragraphStyle setLineSpacing:10.f];//调整行间距
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        [paragraphStyle setHeadIndent:-50];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
        textView.attributedText = attributedString;//ios 6
        
        [textView sizeToFit];
        
        [self setFrame:CGRectMake(0, 0, WIDTH(self), POS_Y(textView)+50)];
        
        NSLog(@"%@",NSStringFromCGRect(self.frame));
    
    }
}
@end
