//
//  UserInfoViewCellTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserInfoTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation UserInfoTableViewCell

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imgview = [[UIImageView alloc]initWithFrame:CGRectMake(30, frame.size.height/2-10, 20, 20)];
        self.imgview.contentMode  = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imgview];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgview)+15, Y(self.imgview), WIDTH(self)/2, 21)];
        self.titleLabel.font = SYSTEMFONT(14);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        
        self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.titleLabel)+5, 0, WIDTH(self)-POS_X(self.titleLabel)-30, HEIGHT(self))];
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.rightLabel];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setIsBedgesEnabled:(BOOL)isBedgesEnabled
{
    self->_isBedgesEnabled = isBedgesEnabled;
    if (self.isBedgesEnabled) {
        BedgesView* be = [[BedgesView alloc]initWithFrame:CGRectMake(self.frame.size.width-90, HEIGHT(self)/2-10, 20, 20)];
        be.tinColor = ColorTheme;
        [be setNeedsDisplay];
        [self addSubview:be];
    }
}

-(void)setImageWithName:(NSString *)name setTitle:(NSString *)title
{
    if (name) {
        self.imgview.image = IMAGENAMED(name);
    }
    
    if (title) {
        self.titleLabel.text = title;
    }
}
@end
