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
        [self addSubview:headerImgView];
        
        //名称
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(headerImgView)+10, Y(headerImgView), 70, 21)];
        nameLabel.font = SYSTEMFONT(14);
        nameLabel.textColor = FONT_COLOR_GRAY;
        [self addSubview:nameLabel];
        
        companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(nameLabel)+5, Y(nameLabel), 200, HEIGHT(nameLabel))];
        companyLabel.textColor = FONT_COLOR_GRAY;
        companyLabel.font = FONT(@"Arial", 14);
        [self addSubview:companyLabel];
        
        
        industoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel), POS_Y(nameLabel)+5, WIDTH(nameLabel)+WIDTH(companyLabel), HEIGHT(nameLabel))];
        industoryLabel.font = FONT(@"Arial", 14);
        industoryLabel.textColor = FONT_COLOR_GRAY;
        [self addSubview:industoryLabel];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDic:(NSDictionary *)dic
{
    self->_dic =dic;
    if (self.dic) {
        nameLabel.text = [dic valueForKey:@"name"];
        [headerImgView sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"photo"]] placeholderImage:IMAGENAMED(@"coremember")];
    }
}

@end
