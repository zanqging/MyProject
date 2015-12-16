//
//  RoadShowTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RoadShowTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation RoadShowTableViewCell

-(void)lauyoutResetLayout:(CGRect)frame
{
    if (!self.titleLabel) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 21)];
        self.titleLabel.font = SYSTEMFONT(14);
        [self.contentView addSubview:self.titleLabel];
        
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.titleLabel)+10, 0, 1, frame.size.height)];
        self.imgView.backgroundColor = ColorCompanyTheme;
        [self.contentView addSubview:self.imgView];
        
        
        self.textView = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+20, 10, frame.size.width-POS_X(self.imgView)-35,frame.size.height-10)];
        self.textView.font = SYSTEMFONT(14);
        self.textView.numberOfLines=4;
        self.textView.lineBreakMode  =NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.textView];
        
        self.titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.titleLabel)-1, 10, 25, 25)];
        self.titleImgView.layer.cornerRadius = 10;
        self.titleImgView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.titleImgView];
        
        
        
        self.expandImgView  = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-50,frame.size.height-15, 10, 10)];
        self.expandImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.expandImgView.image  = IMAGENAMED(@"zhankai");
        [self.contentView addSubview:self.expandImgView];

    }else{
        [self.imgView setFrame:CGRectMake(POS_X(self.titleLabel)+10, 0, 1, frame.size.height)];
        
        [self.textView setFrame:CGRectMake(POS_X(self.imgView)+20, 10, frame.size.width-POS_X(self.imgView)-35,frame.size.height-10)];
        [self.expandImgView setFrame:CGRectMake(WIDTH(self)-50,frame.size.height-15, 10, 10)];
        if (self.isExpand) {
            self.textView.numberOfLines=4;
            self.isExpand = NO;
        }else{
            self.textView.numberOfLines=0;
            self.isExpand = YES;
        }
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContent:(NSString *)content
{
    self->_content = content;
    if (self.content) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        
        [paragraphStyle setLineSpacing:1.f];//调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        
        self.textView.attributedText = attributedString;//ios 6
        [self.textView sizeToFit];
        
    }
    
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
    }else{
        angle = M_PI*2;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    self.expandImgView.transform = transform;
}
@end
