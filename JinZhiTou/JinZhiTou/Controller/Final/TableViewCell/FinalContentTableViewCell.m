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
        self.imgView.contentMode = UIViewContentModeScaleToFill;
        [view addSubview:self.imgView];
        [self addSubview:view];
        //名称
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+5, Y(self.imgView), 150, 21)];
        self.titleLabel.font = SYSTEMFONT(18);
        self.titleLabel.textColor = AppColorTheme;
        [view addSubview:self.titleLabel];
        UIImageView * lineView = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.titleLabel), WIDTH(self.titleLabel), 1)];
        lineView.backgroundColor = BackColor;
        [view addSubview:lineView];
        
        UIImageView* iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(lineView)+5, 15, 15)];
        iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        iconImgView.image = IMAGENAMED(@"name");
        [view addSubview:iconImgView];
        
        UILabel* label  = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(iconImgView)+2, POS_Y(lineView)+2.5, WIDTH(self.titleLabel)-15, 20)];
        label.tag =1001;
        label.font = SYSTEMFONT(12);
        label.textColor  = FONT_COLOR_GRAY;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [view addSubview:label];
        
        iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(label)+3, 15, 15)];
        iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        iconImgView.image = IMAGENAMED(@"address");
        [view addSubview:iconImgView];
        
        label  = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(iconImgView)+2, POS_Y(label)+3, 50, 20)];
        label.tag =1002;
        label.font = SYSTEMFONT(12);
        label.textColor  = FONT_COLOR_GRAY;
        [view addSubview:label];
        
        iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(label), 15, 15)];
        iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        iconImgView.image = IMAGENAMED(@"time1");
        [view addSubview:iconImgView];
        
        label  = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(iconImgView)+2, POS_Y(label), 50, 20)];
        label.tag =1003;
        label.font = SYSTEMFONT(12);
        label.textColor  = FONT_COLOR_GRAY;
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

-(void)setAddress:(NSString *)address
{
    self->_address = address;
    if (self.address) {
        UILabel* label = (UILabel*)[view viewWithTag:1002];
        label.font  = SYSTEMFONT(12);
        [TDUtil setLabelMutableText:label content:self.address lineSpacing:0 headIndent:0];
    }
}

-(void)setTypeDescription:(NSString *)typeDescription
{
    self->_typeDescription=typeDescription;
    if (self.typeDescription) {
        UILabel* label = (UILabel*)[view viewWithTag:1001];
        label.font  = SYSTEMFONT(12);
        label.text = self.typeDescription;
//        [TDUtil setLabelMutableText:label content:self.typeDescription lineSpacing:0 headIndent:0];
    }
}

-(void)setRoadShowTime:(NSString *)roadShowTime
{
    self->_roadShowTime  =roadShowTime;
    if (self.roadShowTime) {
        UILabel* label = (UILabel*)[view viewWithTag:1003];
        label.font  = SYSTEMFONT(12);
        
        NSString * content = [NSString stringWithFormat:@"路演时间: %@",self.roadShowTime];
        [TDUtil setLabelMutableText:label content:content lineSpacing:0 headIndent:0];
    }
}
@end
