//
//  FinalContentTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/7/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinalingTableViewCell.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation FinalingTableViewCell

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        view = [[UIView alloc]initWithFrame:CGRectMake(10, 5, frame.size.width-20,frame.size.height-5)];
        view.backgroundColor= WriteColor;
        //项目图片
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 130, HEIGHT(view)-10)];
        self.imgView.image = IMAGENAMED(@"loading");
        self.imgView.contentMode = UIViewContentModeScaleToFill;
        [view addSubview:self.imgView];
        [self addSubview:view];
        //名称
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+5, Y(self.imgView)+5, 150, 21)];
        self.titleLabel.font = SYSTEMFONT(18);
        self.titleLabel.textColor = AppColorTheme;
        [view addSubview:self.titleLabel];
        
        UIImageView * lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.titleLabel), WIDTH(self.titleLabel), 1)];
        lineImgView.backgroundColor = BackColor;
        [view addSubview:lineImgView];
        
        UIImageView* iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.titleLabel)+5, 15, 15)];
        iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        iconImgView.image = IMAGENAMED(@"progress");
        [view addSubview:iconImgView];
        
        UILabel* label  = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(iconImgView)+2, POS_Y(self.titleLabel)+5, 50, 25)];
        label.tag =1001;
        label.font = SYSTEMFONT(12);
        label.textColor  = FONT_COLOR_GRAY;
        [TDUtil setLabelMutableText:label content:@"进度:" lineSpacing:0 headIndent:0];
        [view addSubview:label];
        
        
        iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(iconImgView), POS_Y(label)+5, 15, 15)];
        iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        iconImgView.image = IMAGENAMED(@"industory");
        [view addSubview:iconImgView];
        
        label  = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(iconImgView)+2, POS_Y(label)+5, 50, 25)];
        label.tag =1002;
        label.font = SYSTEMFONT(12);
        label.textColor  = FONT_COLOR_GRAY;
        [TDUtil setLabelMutableText:label content:@"行业:" lineSpacing:0 headIndent:0];
        [view addSubview:label];
        
        iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(iconImgView), POS_Y(label)+5, 15, 15)];
        iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        iconImgView.image = IMAGENAMED(@"financed");
        [view addSubview:iconImgView];
        
        label  = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(iconImgView)+2, POS_Y(label)+5, 50, 25)];
        label.tag =1003;
        label.font = SYSTEMFONT(12);
        label.textColor  = FONT_COLOR_GRAY;
        [TDUtil setLabelMutableText:label content:@"已筹:" lineSpacing:0 headIndent:0];
        [view addSubview:label];
        
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = BackColor;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setTitle:(NSString *)title
{
    self->_title=title;
    if (self.title) {
         self.titleLabel.text=self.title;
    }
   
}

-(void)setProgress:(NSString *)progress
{
    self->_progress=progress;
    if (self.progress) {
        UILabel* label = (UILabel*)[view viewWithTag:1001];
        UILabel* valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), 50, HEIGHT(label))];
        valueLabel.font  = SYSTEMFONT(12);
        valueLabel.textColor = FONT_COLOR_GRAY;
        [TDUtil setLabelMutableText:valueLabel content:self.progress lineSpacing:0 headIndent:0];
        [view addSubview:valueLabel];
    }
}

-(void)setAssist:(NSString *)assist
{
    self->_assist  =assist;
    if (self.assist) {
        UILabel* label = (UILabel*)[view viewWithTag:1002];
        UILabel* valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), 50, HEIGHT(label))];
        valueLabel.textColor = FONT_COLOR_GRAY;
        valueLabel.font  = SYSTEMFONT(12);
        [TDUtil setLabelMutableText:valueLabel content:self.assist lineSpacing:0 headIndent:0];
        [view addSubview:valueLabel];
    }
}

-(void)setHasFinanceAccount:(NSString *)hasFinanceAccount
{
    self->_hasFinanceAccount = [NSString stringWithFormat:@"%@万",hasFinanceAccount];
    if (self.hasFinanceAccount) {
        UILabel* label = (UILabel*)[view viewWithTag:1003];
        UILabel* valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), 50, HEIGHT(label))];
        valueLabel.textColor = FONT_COLOR_GRAY;
        valueLabel.font  = SYSTEMFONT(12);
        [TDUtil setLabelMutableText:valueLabel content:self.hasFinanceAccount lineSpacing:0 headIndent:0];
        [view addSubview:valueLabel];
    }
}
@end
