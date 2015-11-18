//
//  ThinkTankTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/9/22.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinalCompanyTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation FinalCompanyTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, frame.size.width-20,frame.size.height-5)];
        view.backgroundColor= WriteColor;
        //项目图片
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, WIDTH(view)-10 ,HEIGHT(view)*2/3)];
        self.imgView.image = IMAGENAMED(@"loading");
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        self.imgView.layer.cornerRadius = 3;
        self.imgView.layer.masksToBounds = YES;
        [view addSubview:self.imgView];
        [self addSubview:view];
        //名称
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.imgView), POS_Y(self.imgView)+5, WIDTH(self.imgView),30)];
        self.titleLabel.font = SYSTEMFONT(18);
        self.titleLabel.textColor = FONT_COLOR_RED;
        self.titleLabel.textAlignment  =NSTextAlignmentCenter;
        [view addSubview:self.titleLabel];
        
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

@end
