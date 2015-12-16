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
        [self performSelector:@selector(layerOut:) withObject:nil afterDelay:0.01];
    }
    return self;
}

-(void)layerOut:(id)sender
{
    //内容视图
    contentView  =[[UIView alloc]initWithFrame:CGRectMake(10, 0, WIDTH(self)-20, HEIGHT(self)-10)];
    contentView.backgroundColor  = WriteColor;
    [self addSubview:contentView];
    
    //图片
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, HEIGHT(contentView))];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.masksToBounds = YES;
    [contentView addSubview:imgView];
    if (self.imageName) {
        if (self.imageName) {
            NSURL* url = [NSURL URLWithString:self.imageName];
            [imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading")];
        }
    }
    
    //标题
    labelContent = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+5, Y(imgView)+10, WIDTH(contentView)-POS_X(imgView)-5, 25)];
    labelContent.font = SYSTEMFONT(16);
    [contentView addSubview:labelContent];
    
    if (self.companyName) {
        labelContent.text = self.companyName;
    }
    
    //融资进度
    UILabel* labelProess = [[UILabel alloc]initWithFrame:CGRectMake(X(labelContent), POS_Y(labelContent), 50, 20)];
    labelProess.font =SYSTEMFONT(14);
    [contentView addSubview:labelProess];
    if (self.proess) {
        [TDUtil setLabelMutableText:labelProess content:[self.proess valueForKey:@"key"] lineSpacing:0 headIndent:0];
    }
    
    
    labelProess = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(labelProess), Y(labelProess), 50, HEIGHT(labelProess))];
    labelProess.font =SYSTEMFONT(14);
    labelProess.textColor = ColorTheme;
    [contentView addSubview:labelProess];
    if(self.proess){
        [TDUtil setLabelMutableText:labelProess content:[self.proess valueForKey:@"value"] lineSpacing:0 headIndent:0];
    }
    
    labelProess = [[UILabel alloc]initWithFrame:CGRectMake(X(labelContent), POS_Y(labelProess)+5, 50, 20)];
    labelProess.font =SYSTEMFONT(14);
    [contentView addSubview:labelProess];
    
    if(self.time){
         [TDUtil setLabelMutableText:labelProess content:[self.time valueForKey:@"key"] lineSpacing:0 headIndent:0];
    }
   
    
    labelProess = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(labelProess), Y(labelProess), 50, HEIGHT(labelProess))];
    labelProess.font =SYSTEMFONT(14);
    labelProess.textColor = ColorTheme;
    [contentView addSubview:labelProess];
    
    if (self.time) {
        [TDUtil setLabelMutableText:labelProess content:[self.time valueForKey:@"value"] lineSpacing:0 headIndent:0];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
@end
