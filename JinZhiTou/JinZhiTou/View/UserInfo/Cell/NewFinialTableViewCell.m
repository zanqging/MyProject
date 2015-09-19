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
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 190, 25)];
        self.titleLabel.font  =SYSTEMFONT(14);
        self.titleLabel.textColor = BlackColor;
        [view addSubview:self.titleLabel];
        
        self.desclabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.titleLabel), WIDTH(self.titleLabel), 21)];
        self.desclabel.textColor = ColorTheme;
        self.desclabel.font = SYSTEMFONT(12);
        [view addSubview:self.desclabel];

        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.desclabel), WIDTH(self.titleLabel), 50)];
        self.typeLabel.numberOfLines  =0 ;
        self.typeLabel.textColor  =BACKGROUND_LIGHT_GRAY_COLOR;
        self.typeLabel.font = SYSTEMFONT(12);
        self.typeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:self.typeLabel];
        
        self.imgview = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-90, 10, 70, 70)];
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
    
    self.colletcteLabel =[[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self)-90, Y(imgaeView)+5, 70, 30)];
    self.colletcteLabel.contentMode = UIViewContentModeScaleAspectFill;
    self.colletcteLabel.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
    [view addSubview:self.colletcteLabel];
    
    self.collecteImage = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.colletcteLabel)-30, Y(self.colletcteLabel)+3, 20, 20)];
    
    [self.collecteImage setImage:IMAGENAMED(@"shoucang")];
    [view addSubview:self.collecteImage];
    
    
    self.priseImage = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.collecteImage)+40, Y(self.colletcteLabel)+3, 20, 20)];
    [self.priseImage setImage:IMAGENAMED(@"dianzan")];
    [view addSubview:self.priseImage];
    
    self.priseLabel =[[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.priseImage)+5, Y(self.priseImage)-3, 70, 30)];
    self.priseLabel.textAlignment = NSTextAlignmentLeft;
    self.priseLabel.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
    self.priseLabel.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:self.priseLabel];
}

@end
