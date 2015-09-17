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

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 70, 21)];
        self.titleLabel.font = SYSTEMFONT(14);
        [self addSubview:self.titleLabel];
        

        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.titleLabel)+10, 0, 2, frame.size.height-POS_Y(self.titleImgView))];
        imageView.backgroundColor = ColorCompanyTheme;
        [self addSubview:imageView];
        
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, 0, frame.size.width-POS_X(imageView)-20, HEIGHT(imageView)-20)];
        self.textView.font = SYSTEMFONT(14);
        self.textView.editable = NO;
        [self addSubview:self.textView];
        
        self.titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.titleLabel)-1, 10, 25, 25)];
        self.titleImgView.image = IMAGENAMED(@"company");
        self.titleImgView.layer.cornerRadius = 10;
        self.titleImgView.layer.masksToBounds = YES;
        [self addSubview:self.titleImgView];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
