//
//  UserBasicInfoTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/8/7.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserBasicInfoTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation UserBasicInfoTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, HEIGHT(self)-10)];
        self.titleLabel.textColor =BlackColor;
        self.titleLabel.font = SYSTEMFONT(16);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.titleLabel)+5, Y(self.titleLabel), 160, HEIGHT(self.titleLabel))];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.font = SYSTEMFONT(14);
        self.rightLabel.textColor  =FONT_COLOR_GRAY;
        [self addSubview:self.rightLabel];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)setViewCellTitle:(NSString *)title setTitle:(NSString *)subTitle
{
    
    if (title) {
        self.titleLabel.text = title;
    }
}

-(void)setIsShowImg:(BOOL)isShowImg
{
    self->_isShowImg = isShowImg;
    if (self.isShowImg) {
        [self.rightLabel removeFromSuperview];
        self.titleLabel.frame = CGRectMake(20,  10, 100, HEIGHT(self.contentView));
        self.rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-90, 5, 50, 50)];
        self.rightImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.rightImgView.layer.cornerRadius = 25;
        self.rightImgView.layer.masksToBounds = YES;
        [self addSubview:self.rightImgView];
    }
}
@end
