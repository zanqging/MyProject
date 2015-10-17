//
//  CyclePriseTableViewCell.m
//  Cycle
//
//  Created by air on 15/10/15.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "CycleShareTableViewCell.h"
#import "GlobalDefine.h"
#import "UConstants.h"
@implementation CycleShareTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //头像
        headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        headerImgView.image = IMAGENAMED(@"5");
        [self addSubview:headerImgView];
        
        //名称
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(headerImgView)+10, Y(headerImgView), 70, 21)];
        nameLabel.text = @"赵郁骅 |";
        nameLabel.font = SYSTEMFONT(14);
        nameLabel.textColor = FONT_COLOR_GRAY;
        [self addSubview:nameLabel];
        
        companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(nameLabel)+5, Y(nameLabel), 200, HEIGHT(nameLabel))];
        companyLabel.textColor = FONT_COLOR_GRAY;
        companyLabel.font = FONT(@"Arial", 14);
        companyLabel.text =@"同程旅游产品中心高级经理";
        [self addSubview:companyLabel];
        
        
        industoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel), POS_Y(nameLabel)+5, WIDTH(nameLabel)+WIDTH(companyLabel), HEIGHT(nameLabel))];
        industoryLabel.font = FONT(@"Arial", 14);
        industoryLabel.textColor = FONT_COLOR_GRAY;
        industoryLabel.text  = @"互联网 ｜ 广东 15-10-14 19:15";
        [self addSubview:industoryLabel];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
