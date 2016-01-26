//
//  RoadShowHomeTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/11/4.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "RoadShowHomeTableViewCell.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "UIImageView+WebCache.h"
@implementation RoadShowHomeTableViewCell

- (void)awakeFromNib {
    self.backgroundColor  = BackColor;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self performSelector:@selector(layerOut:) withObject:nil afterDelay:0];
        [self layerOut:nil];
    }
    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         self.backgroundColor = BackColor;
        [self layerOut:nil];
    }
    return self;
}

-(void)layerOut:(id)sender
{
    //内容视图
    contentView  =[[UIView alloc]initWithFrame:CGRectMake(10, 5, WIDTH(self.contentView)-20, HEIGHT(self.contentView)-5)];
    contentView.backgroundColor  = WriteColor;
    [self.contentView addSubview:contentView];
    
    //图片
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 130, HEIGHT(contentView)-10)];
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.layer.masksToBounds = YES;
    [contentView addSubview:imgView];
    if (self.imageName) {
        if (self.imageName) {
            NSURL* url = [NSURL URLWithString:self.imageName];
            [imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading")];
        }
    }
    
    //标题
    labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+5, Y(imgView)+5, WIDTH(contentView)-150, 25)];
    labelTitle.font = SYSTEMFONT(15);
    labelTitle.textColor = AppColorTheme;
    [contentView addSubview:labelTitle];
    
    UIImageView * lineView = [[UIImageView alloc]initWithFrame:CGRectMake(X(labelTitle), POS_Y(labelTitle), WIDTH(labelTitle), 1)];
    lineView.backgroundColor = BackColor;
    [contentView addSubview:lineView];
    
    UIImageView* iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(labelTitle), POS_Y(labelTitle)+5, 15, 15)];
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.image = IMAGENAMED(@"financed1");
    [contentView addSubview:iconImgView];
    
    //融资进度
    UILabel* labelProess = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(iconImgView)+5, POS_Y(labelTitle)+5, 50, 20)];
    labelProess.font =SYSTEMFONT(12);
    labelProess.textColor = FONT_COLOR_GRAY;
    [contentView addSubview:labelProess];
    
    [TDUtil setLabelMutableText:labelProess content:@"已筹金额:" lineSpacing:0 headIndent:0];
    
    labelContent = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(labelProess), Y(labelProess), 50, HEIGHT(labelProess))];
    labelContent.font =SYSTEMFONT(12);
    labelContent.textColor = FONT_COLOR_GRAY;
    [contentView addSubview:labelContent];

    iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(labelTitle), POS_Y(labelProess)+5, 15, 15)];
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.image = IMAGENAMED(@"time1");
    [contentView addSubview:iconImgView];
    
    labelProess = [[UILabel alloc]initWithFrame:CGRectMake(X(labelProess), POS_Y(labelProess)+5, 70, 20)];
    labelProess.font =SYSTEMFONT(12);
    labelProess.textColor = FONT_COLOR_GRAY;
    [TDUtil setLabelMutableText:labelProess content:@"众筹时间:" lineSpacing:0 headIndent:0];
    [contentView addSubview:labelProess];

    labelDateTime = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(labelProess), Y(labelProess), 150, HEIGHT(labelProess))];
    labelDateTime.font =SYSTEMFONT(12);
    labelDateTime.textColor = FONT_COLOR_GRAY;
    [contentView addSubview:labelDateTime];
    
    iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(labelTitle), POS_Y(labelProess)+5, 15, 15)];
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.image = IMAGENAMED(@"industory");
    [contentView addSubview:iconImgView];
    
    labelProess = [[UILabel alloc]initWithFrame:CGRectMake(X(labelProess), POS_Y(labelProess)+5, 70, 20)];
    labelProess.font =SYSTEMFONT(12);
    labelProess.textColor = FONT_COLOR_GRAY;
    [TDUtil setLabelMutableText:labelProess content:@"所属行业:" lineSpacing:0 headIndent:0];
    [contentView addSubview:labelProess];
    
    labelIndustory = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(labelProess), Y(labelProess), 150, HEIGHT(labelProess))];
    labelIndustory.font =SYSTEMFONT(12);
    labelIndustory.textColor = FONT_COLOR_GRAY;
    [contentView addSubview:labelIndustory];
    
    
    [contentView setFrame:CGRectMake(10, 5, WIDTH(self.contentView)-20, POS_Y(labelIndustory)+15)];
    [imgView setFrame:CGRectMake(5, 5, 130, HEIGHT(contentView)-10)];
}

-(void)setHasFinance:(NSString *)hasFinance
{
    self->_hasFinance = hasFinance;
    labelContent.text  = [NSString stringWithFormat:@"%@万",self.hasFinance];
}

-(void)setCompanyName:(NSString *)companyName
{
    if ([TDUtil isValidString:companyName]) {
        self->_companyName = companyName;
        labelTitle.text = self.companyName;
    }
}
-(void)setImageName:(NSString *)imageName
{
    if ([TDUtil isValidString:imageName]) {
        self->_imageName = imageName;
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.imageName] placeholderImage:IMAGENAMED(@"loading")];
    }
}
-(void)setDateTime:(NSString *)dateTime
{
    if (dateTime && ![dateTime isEqualToString:@""]) {
        self->_dateTime  =dateTime;
        labelDateTime.text = self.dateTime;
    }
}

-(void)setIndustory:(NSString *)industory
{
    self->_industory = industory;
    if (industory) {
        labelIndustory.text = self.industory;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
