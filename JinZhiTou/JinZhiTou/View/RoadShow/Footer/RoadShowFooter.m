
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
    UILabel* timeLabel;
    UILabel* titleLabel;
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
        lbl.font = SYSTEMFONT(17);
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
        
        //标题
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(imageView1)+10, WIDTH(self)-20, 40)];
        titleLabel.numberOfLines=2;
        titleLabel.font = SYSTEMBOLDFONT(17);
        titleLabel.textColor = FONT_COLOR_BLACK;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:titleLabel];
        //时间
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(titleLabel), POS_Y(titleLabel), WIDTH(titleLabel), 20)];
        timeLabel.numberOfLines=2;
        timeLabel.font = SYSTEMBOLDFONT(15);
        timeLabel.textColor = FONT_COLOR_GRAY;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:timeLabel];
        textView = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(timeLabel)+5, WIDTH(self)-20, HEIGHT(self)-100)];
        textView.font = SYSTEMFONT(16);
        textView.textColor = FONT_COLOR_GRAY;
        textView.numberOfLines = 4;
        textView.textAlignment  =NSTextAlignmentCenter;
        textView.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:textView];
        
        self.expandImgView  = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-50,POS_Y(textView)+10, 10, 10)];
        self.expandImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.expandImgView.image  = IMAGENAMED(@"zhankai");
        [self addSubview:self.expandImgView];

        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(expand)]];
        self.backgroundColor = WriteColor;
    }
    return self;
}

-(void)expand
{
    self.isExpand = !self.isExpand;
}

-(void)setIsExpand:(BOOL)isExpand
{
    self->_isExpand = isExpand;
    
    float angle;
    if (self.isExpand) {
        angle = M_PI;
        textView.numberOfLines=0;
    }else{
        textView.numberOfLines=4;
        angle = M_PI*2;
    }
    NSString* con = self.content;
    if (con && ![con isEqualToString:@""]) {
       self.content = con;
    }
    
    
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    self.expandImgView.transform = transform;
}

-(void)setContent:(NSString *)content
{
    if (content.class !=NSNull.class) {
        
        self->_content =content;
        if (self.content) {
            NSArray *array = [content componentsSeparatedByString:@"\n"]; //从字符A中分隔成2个元素的数组
            NSLog(@"array:%@",array[0]); //结果是adfsfsfs和dfsdf
            
            
            if (array && array.count>0) {
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                
                //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
                [paragraphStyle setLineSpacing:5.f];//调整行间距
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:array[0]];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [array[0] length])];
                
                if (array && array[0]) {
                    titleLabel.text = array[0];
                }
                
                
                [timeLabel setFrame:CGRectMake(X(titleLabel), POS_Y(titleLabel)+5, WIDTH(titleLabel), 20)];
                if (array.count>1 && array[1]) {
                    timeLabel.text = array[1];
                }
                
                
                [textView setFrame:CGRectMake(10, POS_Y(timeLabel)+5, WIDTH(self)-20, HEIGHT(self)-100)];
                
                if (array && array[0]) {
                content = [content stringByReplacingOccurrencesOfString:array[0] withString:@""];
                }
                if (array && array.count>1) {
                content = [content stringByReplacingOccurrencesOfString:array[1] withString:@""];
                }
                
                [paragraphStyle setAlignment:NSTextAlignmentLeft];
                attributedString = [[NSMutableAttributedString alloc] initWithString:content];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
                textView.attributedText = attributedString;//ios 6
                [textView sizeToFit];

                [textView setFrame:CGRectMake(10, Y(timeLabel), WIDTH(self)-20, HEIGHT(textView))];
                
                [self setFrame:CGRectMake(X(self), Y(self), WIDTH(self), POS_Y(textView)+70)];
                
                [self.expandImgView setFrame:CGRectMake(WIDTH(self)-50,POS_Y(textView)+10, 10, 10)];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"updateRoadShowLayout" object:nil];
                
            }
        }
        
        
       
    }
}
@end
