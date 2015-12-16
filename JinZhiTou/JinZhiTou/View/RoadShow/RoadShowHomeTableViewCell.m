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
        [self performSelector:@selector(layerOut:) withObject:nil afterDelay:0.01];
    }
    return self;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         self.backgroundColor = BackColor;
        [self performSelector:@selector(layerOut:) withObject:nil afterDelay:0.001];
    }
    return self;
}

-(void)layerOut:(id)sender
{
    //内容视图
    contentView  =[[UIView alloc]initWithFrame:CGRectMake(10, 0, WIDTH(self)-20, HEIGHT(self)-5)];
    contentView.backgroundColor  = WriteColor;
    [self addSubview:contentView];
    
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
    labelContent = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+5, Y(imgView)+15, WIDTH(contentView)-150, 25)];
    labelContent.font = SYSTEMFONT(16);
    [contentView addSubview:labelContent];
    
    if (self.companyName) {
        labelContent.text = self.companyName;
    }
    
    //融资进度
    UILabel* labelProess = [[UILabel alloc]initWithFrame:CGRectMake(X(labelContent), POS_Y(labelContent)+5, 50, 20)];
    labelProess.font =SYSTEMFONT(14);
    labelProess.text = @"已筹:";
    [contentView addSubview:labelProess];
    
    
    labelProess = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(labelProess), Y(labelProess), 50, HEIGHT(labelProess))];
    labelProess.font =SYSTEMFONT(14);
    labelProess.text =[NSString stringWithFormat:@"%@万",self.hasFinance];
    labelProess.textColor = ColorTheme2;
    [contentView addSubview:labelProess];

    
    
    labelProess = [[UILabel alloc]initWithFrame:CGRectMake(X(labelContent), POS_Y(labelProess)+5, 70, 20)];
    labelProess.text = @"众筹时间:";
    labelProess.font =SYSTEMFONT(14);
    [contentView addSubview:labelProess];

   
    
    labelProess = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(labelProess), Y(labelProess), 150, HEIGHT(labelProess))];
    labelProess.text = self.dateTime;
    labelProess.font =SYSTEMFONT(14);
    labelProess.textColor = ColorTheme2;
    [contentView addSubview:labelProess];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
@end
