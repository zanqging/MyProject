//
//  UserCollecteTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/8/8.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserCollecteTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation UserCollecteTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self)-10)];
        view.backgroundColor = WriteColor;
        
        [self addSubview:view];
        
        self.imgview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 100, 100)];
        [view addSubview:self.imgview];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgview)+10, Y(self.imgview), 190, 25)];
        self.titleLabel.font  =SYSTEMFONT(16);
        self.titleLabel.textColor = ColorTheme;
        [view addSubview:self.titleLabel];
        
        self.desclabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.titleLabel), WIDTH(self.titleLabel), 21)];
        self.desclabel.font = SYSTEMFONT(14);
        [view addSubview:self.desclabel];

        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.desclabel), WIDTH(self.titleLabel), 21)];
        self.typeLabel.font = SYSTEMFONT(14);
        [view addSubview:self.typeLabel];

       self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.typeLabel)+5, WIDTH(self.titleLabel), 21)];
        self.timeLabel.font = SYSTEMFONT(14);
        [view addSubview:self.timeLabel];
        
        
        [self layoutNeed:POS_Y(self.timeLabel)+20];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)layoutNeed:(float)height
{
    
    float w,h;
    w=WIDTH(self)/3;
    h=height;
    
    UIImageView* imgaeView;
    for (int i =0; i<2; i++) {
        
        w+=w*i;
        imgaeView=[[UIImageView alloc]initWithFrame:CGRectMake(w, h, 1, 40)];
        imgaeView.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [self addSubview:imgaeView];
        
        if (i==0) {
            self.colletcteLabel =[[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgaeView)-40, Y(imgaeView)+5, 30, 30)];
            self.colletcteLabel.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:self.colletcteLabel];
            
            self.collecteImage = [[UIImageView alloc]initWithFrame:CGRectMake(X(self.colletcteLabel)-30, Y(self.colletcteLabel)+3, 20, 20)];
            [self.collecteImage setImage:IMAGENAMED(@"shoucang")];
            [self addSubview:self.collecteImage];
            
            
            self.priseImage = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(imgaeView)+20, Y(self.colletcteLabel)+3, 20, 20)];
            [self.priseImage setImage:IMAGENAMED(@"dianzan")];
            [self addSubview:self.priseImage];
            
            self.priseLabel =[[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.priseImage)+5, Y(self.priseImage)-3, 70, 30)];
            self.priseLabel.textAlignment = NSTextAlignmentLeft;
            self.priseLabel.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:self.priseLabel];
        }else{
            
            self.voteImage = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(imgaeView)+20, Y(self.colletcteLabel)+3, 20, 20)];
            [self.voteImage setImage:IMAGENAMED(@"toupiao")];
            [self addSubview:self.voteImage];
            
            
            self.votelabel =[[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.voteImage)+5, Y(self.voteImage)-3, 70, 30)];
            self.votelabel.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:self.votelabel];
            
            [view setFrame:CGRectMake(0, 0, WIDTH(self), POS_Y(self.votelabel)+20)];
        }
       
    }
}

@end
