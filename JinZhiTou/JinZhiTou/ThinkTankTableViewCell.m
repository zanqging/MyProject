//
//  ThinkTankTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/9/22.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ThinkTankTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation ThinkTankTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20,frame.size.height-10)];
        view.backgroundColor= WriteColor;
        //项目图片
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100,HEIGHT(view))];
        self.imgView.image = IMAGENAMED(@"loading");
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
        self.imgView.layer.cornerRadius = 3;
        self.imgView.layer.masksToBounds = YES;
        [view addSubview:self.imgView];
        [self addSubview:view];
        //名称
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+15, 30, 130, 21)];
        self.titleLabel.font = SYSTEMFONT(18);
        self.titleLabel.textColor = FONT_COLOR_RED;
        [view addSubview:self.titleLabel];
        
        //描述
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+15, POS_Y(self.titleLabel)+5, WIDTH(self)/2, 21)];
        self.contentLabel.font = SYSTEMFONT(14);
        self.contentLabel.textColor = FONT_COLOR_BLACK;
        [view addSubview:self.contentLabel];
        
        //描述
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+15, POS_Y(self.contentLabel)+5, WIDTH(self.contentLabel)+10, 21)];
        self.typeLabel.numberOfLines = 3;
        self.typeLabel.font = SYSTEMFONT(13);
        self.typeLabel.textColor = FONT_COLOR_GRAY;
        self.typeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:self.typeLabel];
        //
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

-(void)setContent:(NSString *)content
{
    self->_content=content;
    if (self.content) {
        self.contentLabel.text=self.content;
    }
}

-(void)setTypeDescription:(NSString *)typeDescription
{
    self->_typeDescription=typeDescription;
    if (self.typeDescription) {
        self.typeLabel.text=self.typeDescription;
    }
}

@end
