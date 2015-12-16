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
        self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, WIDTH(self)/4, 20)];
        [self.labelTitle setText:@"公司名称"];
        [self addSubview:self.labelTitle];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.labelTitle)+10, 0, 1, HEIGHT(self))];
        imgView.backgroundColor = ColorCompanyTheme;
        [self addSubview:imgView];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(imgView)-15, 20, 30, 30)];
        [self addSubview:self.imageView];
        
        self.labelContent = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+25, 10, WIDTH(self)-POS_X(imgView)-30, HEIGHT(self)-40)];
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
            [self setFrame:CGRectMake(X(self), Y(self), WIDTH(self), 70)];
            
            CGRect frame = self.labelContent.frame;
            frame.size.height = HEIGHT(self)-10;
            [self.labelContent setFrame:frame];
        }else{
            [self setFrame:CGRectMake(X(self), Y(self), WIDTH(self), POS_Y(self.labelContent)+30)];
        }
        [self.expandImgView setFrame:CGRectMake(WIDTH(self)-50,HEIGHT(self)-15, 10, 10)];
        
       
        
        [imgView setFrame:CGRectMake(POS_X(self.labelTitle)+10, 0, 1, HEIGHT(self))];
        
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
