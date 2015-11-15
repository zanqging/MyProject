//
//  UserCollecteTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/8/8.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "NewFinialTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation NewFinialTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = BackColor;
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), 150)];
        view.backgroundColor = WriteColor;
        
        [self addSubview:view];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,WIDTH(self)-100, 40)];
        self.titleLabel.numberOfLines  =2;
        self.titleLabel.font  =SYSTEMBOLDFONT(16);
        self.titleLabel.textColor = FONT_COLOR_BLACK;
        self.titleLabel.lineBreakMode  =NSLineBreakByWordWrapping;
        [view addSubview:self.titleLabel];
        
        self.desclabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.titleLabel), WIDTH(self.titleLabel)/2, 21)];
        self.desclabel.textColor = FONT_COLOR_RED;
        self.desclabel.font = SYSTEMFONT(12);
        [view addSubview:self.desclabel];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.desclabel), Y(self.desclabel), WIDTH(self.titleLabel)/2, 21)];
        self.timeLabel.textColor = FONT_COLOR_GRAY;
        self.timeLabel.font = SYSTEMFONT(12);
        [view addSubview:self.timeLabel];

        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.desclabel), WIDTH(self.titleLabel), 50)];
        self.typeLabel.numberOfLines  =3 ;
        self.typeLabel.textColor  =FONT_COLOR_GRAY;
        self.typeLabel.font = SYSTEMFONT(12);
        self.typeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [view addSubview:self.typeLabel];
        
        self.imgview = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-90, 0, 80, 80)];
        self.imgview.contentMode = UIViewContentModeScaleAspectFit;
        self.imgview.layer.masksToBounds  =YES;
        [view addSubview:self.imgview];
        
        
        [self layoutNeed:POS_Y(self.typeLabel)];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)layoutNeed:(float)height
{
    UIImageView* imgaeView;
    imgaeView = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.titleLabel), height, WIDTH(self)-2*X(self.titleLabel), 1)];
    imgaeView.backgroundColor  =BackColor;
    [self addSubview:imgaeView];
    
    float w,h;
    w=WIDTH(self)/3;
    h=height;
    
    self.colletcteLabel =[[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)-90, Y(imgaeView), 70, 30)];
    self.colletcteLabel.contentMode = UIViewContentModeScaleAspectFill;
    self.colletcteLabel.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
    [view addSubview:self.colletcteLabel];
    
    self.collecteImage = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.colletcteLabel)-25, Y(self.colletcteLabel)+5, 20, 20)];
    
    [self.collecteImage setImage:IMAGENAMED(@"shoucang")];
    [view addSubview:self.collecteImage];
    
    
    self.priseImage = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.collecteImage)+40, Y(self.collecteImage), 20, 20)];
    [self.priseImage setImage:IMAGENAMED(@"dianzan")];
    [view addSubview:self.priseImage];
    
    self.priseLabel =[[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.priseImage)+5, Y(self.colletcteLabel), 70, 30)];
    self.priseLabel.textAlignment = NSTextAlignmentLeft;
    self.priseLabel.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
    
    [view addSubview:self.priseLabel];
}

@end
