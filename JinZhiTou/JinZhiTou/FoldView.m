//
//  FoldView.m
//  JinZhiTou
//
//  Created by air on 15/9/24.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "FoldView.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation FoldView

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor =WriteColor;
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
        [self addSubview:self.imageView];
        
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imageView)+5, Y(self.imageView)+5, WIDTH(self)/4, 20)];
        [self.labelTitle setText:@"公司名称"];
        [self addSubview:self.labelTitle];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.imageView)-15, 10, 1, HEIGHT(self))];
        imgView.backgroundColor = ColorCompanyTheme;
        [self addSubview:imgView];
        
        self.labelContent = [[UILabel alloc]initWithFrame:CGRectMake(X(self.labelTitle), POS_Y(self.labelTitle), WIDTH(self)-POS_X(imgView)-60, HEIGHT(self)-40)];
        self.labelContent.numberOfLines=4;
        self.labelContent.font  =SYSTEMFONT(14);
        self.labelContent.textColor = FONT_COLOR_GRAY;
        self.labelContent.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.labelContent];
        
        self.expandImgView  = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-50,frame.size.height-15, 10, 10)];
        self.expandImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.expandImgView.image  = IMAGENAMED(@"zhankai");
        [self addSubview:self.expandImgView];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(expand:)]];
        
        self.nextViews = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)expand:(id)sender
{
    self.isExpand = !self.isExpand;
}

-(void)setIsLimit:(BOOL)isLimit
{
    self->_isLimit = isLimit;
    if (isLimit) {
        self.expandImgView.alpha = 0;
    }else{
        self.expandImgView.alpha = 1;
    }
}

-(void)setIsExpand:(BOOL)isExpand
{
    self->_isExpand = isExpand;
    
    float angle;
    if (self.isExpand) {
        angle = M_PI;
        self.labelContent.numberOfLines=0;
    }else{
        self.labelContent.numberOfLines=4;
        angle = M_PI*2;
    }
    
    self.content = self.content;
    
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    self.expandImgView.transform = transform;
}

-(void)setContent:(NSString *)content
{
    self->_content = content;
    if (self.content) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        
        [paragraphStyle setLineSpacing:5.f];//调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        
        self.labelContent.attributedText = attributedString;//ios 6
        [self.labelContent sizeToFit];
        NSInteger lines = [TDUtil convertToInt:content]/16;
        if (lines<=4) {
            [self.expandImgView setAlpha:0];
            [self setFrame:CGRectMake(X(self), Y(self), WIDTH(self), 90)];
            
            CGRect frame = self.labelContent.frame;
            frame.size.height = HEIGHT(self)-10;
            [self.labelContent setFrame:frame];
        }else{
            [self setFrame:CGRectMake(X(self), Y(self), WIDTH(self), POS_Y(self.labelContent)+20)];
        }
        [self.expandImgView setFrame:CGRectMake(WIDTH(self)-30,POS_Y(self.labelContent)+5, 10, 10)];
        
       
        
        float pos_y = 0;
        float height = HEIGHT(self);
        if (self.isStart) {
            pos_y = POS_Y(self.imageView);
        }
        
        
        if (self.isEnd) {
            height = POS_Y(self.imageView);
        }
        
        [imgView setFrame:CGRectMake(X(self.imageView)+15, pos_y, 1,height)];
        
        UIView* v;
        CGRect frame;
        for (int i=0; i<self.nextViews.count; i++) {
            if (!v) {
                v = self.nextViews[i];
                frame =v.frame;
                frame.origin.y = POS_Y(self);
                [v setFrame:frame];
            }else{
                frame =v.frame;
                v = self.nextViews[i];
                [v setFrame:CGRectMake(X(v), frame.origin.y+frame.size.height, WIDTH(v), HEIGHT(v))];
            }
            
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateRoadShowLayout" object:nil];
        
    }
}

@end
