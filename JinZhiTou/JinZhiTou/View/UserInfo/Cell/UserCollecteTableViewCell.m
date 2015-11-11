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
        self.backgroundColor  =BackColor;
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self)-10)];
        view.backgroundColor = WriteColor;
        [self addSubview:view];
        
        self.imgview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 70, 70)];
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
        
    }
    return self;
}
-(void)layout:(id)sender
{
    [view setFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self)-10)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
