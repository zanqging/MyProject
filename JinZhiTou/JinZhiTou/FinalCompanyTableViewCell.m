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
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(10, 5, frame.size.width-20,frame.size.height-5)];
        view.backgroundColor= WriteColor;
        //项目图片
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 120 ,HEIGHT(view)-10)];
        self.imgView.layer.cornerRadius = 3;
        self.imgView.layer.masksToBounds = YES;
        self.imgView.image = IMAGENAMED(@"loading");
        self.imgView.contentMode = UIViewContentModeScaleToFill;
        [view addSubview:self.imgView];
        [self.contentView addSubview:view];
        //名称
        CGFloat len =WIDTH(self)-153;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+5,10,len,20)];
        self.titleLabel.font = SYSTEMFONT(18);
        self.titleLabel.textColor = FONT_COLOR_BLACK;
        [view addSubview:self.titleLabel];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(X(self.titleLabel)-5, POS_Y(self.titleLabel)+5, WIDTH(self.titleLabel), 2)];
        lineView.backgroundColor = BackColor;
        [view addSubview:lineView];
        
        UIImageView * iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(lineView)+10, 10, 10)];
        iconImgView.image = IMAGENAMED(@"companyname");
        iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:iconImgView];
        
        self.subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(iconImgView)+2,POS_Y(lineView) + 5,len,20)];
        self.subTitleLabel.font = SYSTEMFONT(14);
        self.subTitleLabel.textColor = FONT_COLOR_BLACK;
        [view addSubview:self.subTitleLabel];
        
        iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.subTitleLabel)+10, 10, 10)];
        iconImgView.image = IMAGENAMED(@"location");
        iconImgView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:iconImgView];
        
        //内容
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(iconImgView)+2, POS_Y(self.subTitleLabel) + 5, len,20)];
        self.contentLabel.numberOfLines=4;
        self.contentLabel.font = SYSTEMFONT(14);
        self.contentLabel.textColor = FONT_COLOR_GRAY;
        self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [view addSubview:self.contentLabel];
        
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

@end
