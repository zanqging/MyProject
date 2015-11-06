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
        view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20,frame.size.height-10)];
        view.backgroundColor= WriteColor;
        //项目图片
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
        self.imgView.image = IMAGENAMED(@"loading");
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.imgView.layer.masksToBounds = YES;
        [view addSubview:self.imgView];
        [self addSubview:view];
        //名称
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+5, Y(self.imgView)+20, 180, 21)];
        self.titleLabel.font = SYSTEMFONT(16);
        self.titleLabel.textColor = FONT_COLOR_RED;
        [view addSubview:self.titleLabel];
    
//        
//        UIButton* btnAction = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)-100, HEIGHT(view)/2-40, 70, 30)];
//        [btnAction setTitle:@"我要投资" forState:UIControlStateNormal];
//        [btnAction.titleLabel setFont:SYSTEMFONT(14)];
//        [btnAction.layer setCornerRadius:5];
//        [btnAction.layer setBorderWidth:1];
//        [btnAction.layer setBorderColor:ColorTheme.CGColor];
//        [btnAction setTitleColor:ColorTheme forState:UIControlStateNormal];
//        [view addSubview:btnAction];
        self.backgroundColor = BackColor;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        
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
        //描述
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+5, POS_Y(itemLabel)+5, WIDTH(itemLabel), 21)];
        self.typeLabel.font = SYSTEMFONT(14);
        self.typeLabel.textColor = FONT_COLOR_GRAY;
        [view addSubview:self.typeLabel];
        
        [TDUtil setLabelMutableText:self.typeLabel content:self.typeDescription lineSpacing:0 headIndent:0];
    }
}

-(void)setStart:(NSDictionary *)start
{
    self->_start = start;
    if (self.start) {
        //描述
        itemLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+5, POS_Y(self.titleLabel)+5, WIDTH(self.titleLabel), 21)];
        itemLabel.font = SYSTEMFONT(14);
        itemLabel.textColor =FONT_COLOR_BLACK;
        [view addSubview:itemLabel];
        
        [TDUtil setLabelMutableText:itemLabel content:[self.start valueForKey:@"name"] lineSpacing:0 headIndent:0];
        
        itemValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(itemLabel)+5, Y(itemLabel), WIDTH(self.titleLabel), 21)];
        itemValueLabel.font = SYSTEMFONT(14);
        itemValueLabel.textColor =ColorTheme;
        [view addSubview:itemValueLabel];
        
        [TDUtil setLabelMutableText:itemValueLabel content:[self.start valueForKey:@"datetime"] lineSpacing:0 headIndent:0];
    }
}
@end
