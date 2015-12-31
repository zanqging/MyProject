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
    labelTitle.textColor = FONT_COLOR_BLACK;
    [contentView addSubview:labelTitle];
    
    //融资进度
    UILabel* labelProess = [[UILabel alloc]initWithFrame:CGRectMake(X(labelTitle), POS_Y(labelTitle)+5, 50, 20)];
    labelProess.font =SYSTEMFONT(14);
    labelProess.text = @"已筹:";
    labelProess.textColor = FONT_COLOR_GRAY;
    [contentView addSubview:labelProess];
    
    
    labelContent = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(labelProess), Y(labelProess), 50, HEIGHT(labelProess))];
    labelContent.font =SYSTEMFONT(14);
    labelContent.textColor = ColorTheme2;
    [contentView addSubview:labelContent];

    
    
    labelProess = [[UILabel alloc]initWithFrame:CGRectMake(X(labelProess), POS_Y(labelProess)+5, 70, 20)];
    labelProess.text = @"众筹时间:";
    labelProess.font =SYSTEMFONT(14);
    labelProess.textColor = FONT_COLOR_GRAY;
    [contentView addSubview:labelProess];

   
    
    labelDateTime = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(labelProess), Y(labelProess), 150, HEIGHT(labelProess))];
    labelDateTime.font =SYSTEMFONT(14);
    labelDateTime.textColor = ColorTheme2;
    [contentView addSubview:labelDateTime];
    
    [contentView setFrame:CGRectMake(10, 5, WIDTH(self.contentView)-20, POS_Y(labelDateTime)+15)];
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
        
        [imgView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:self.imageName] andPlaceholderImage:IMAGENAMED(@"loading") options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSLog(@"开始下载:%ld",expectedSize/receivedSize);
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        }];
    }
}
-(void)setDateTime:(NSString *)dateTime
{
    if (dateTime && ![dateTime isEqualToString:@""]) {
        self->_dateTime  =dateTime;
        labelDateTime.text = self.dateTime;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
