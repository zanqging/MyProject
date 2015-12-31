//
//  FinalContentTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/7/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinalContentTableViewCell.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation FinalContentTableViewCell

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        view = [[UIView alloc]initWithFrame:CGRectMake(10, 5, frame.size.width-20,frame.size.height-5)];
        view.backgroundColor= WriteColor;
        //项目图片
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 130, HEIGHT(view)-10)];
        self.imgView.layer.masksToBounds = YES;
        self.imgView.image = IMAGENAMED(@"loading");
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:self.imgView];
        [self addSubview:view];
        //名称
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+10, Y(self.imgView)+10, 150, 21)];
        self.titleLabel.font = SYSTEMFONT(16);
        self.titleLabel.textColor = FONT_COLOR_BLACK;
        [view addSubview:self.titleLabel];
        
        UILabel* label  = [[UILabel alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.titleLabel)+5, 50, 25)];
        label.tag =1001;
        label.font = SYSTEMFONT(14);
        label.textColor  = FONT_COLOR_GRAY;
        [TDUtil setLabelMutableText:label content:@"行业领域:" lineSpacing:0 headIndent:0];
        [view addSubview:label];
        
        
        label  = [[UILabel alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(label)+10, 50, 25)];
        label.tag =1002;
        label.font = SYSTEMFONT(14);
        label.textColor  = FONT_COLOR_GRAY;
        [TDUtil setLabelMutableText:label content:@"路演时间:" lineSpacing:0 headIndent:0];
        [view addSubview:label];
    

//        UIButton* btnAction = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)-100, HEIGHT(view)/2-40, 70, 30)];
//        [btnAction setTitle:@"我要投资" forState:UIControlStateNormal];
//        [btnAction.titleLabel setFont:SYSTEMFONT(14)];
//        [btnAction.layer setCornerRadius:5];
//        [btnAction.layer setBorderWidth:1];
//        [btnAction.layer setBorderColor:ColorTheme.CGColor];
//        [btnAction setTitleColor:ColorTheme forState:UIControlStateNormal];
//        [view addSubview:btnAction];
        
        
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

-(void)setTypeDescription:(NSString *)typeDescription
{
    self->_typeDescription=typeDescription;
    if (self.typeDescription) {
        UILabel* label = (UILabel*)[view viewWithTag:1001];
        UILabel* valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), 50, HEIGHT(label))];
        valueLabel.font  = SYSTEMFONT(14);
        valueLabel.textColor = AppColorTheme;
        [TDUtil setLabelMutableText:valueLabel content:self.typeDescription lineSpacing:0 headIndent:0];
        [view addSubview:valueLabel];
    }
}

-(void)setRoadShowTime:(NSString *)roadShowTime
{
    self->_roadShowTime  =roadShowTime;
    if (self.roadShowTime) {
        UILabel* label = (UILabel*)[view viewWithTag:1002];
        UILabel* valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), 50, HEIGHT(label))];
        valueLabel.textColor = AppColorTheme;
        valueLabel.font  = SYSTEMFONT(14);
        [TDUtil setLabelMutableText:valueLabel content:self.roadShowTime lineSpacing:0 headIndent:0];
        [view addSubview:valueLabel];
    }
}
@end
