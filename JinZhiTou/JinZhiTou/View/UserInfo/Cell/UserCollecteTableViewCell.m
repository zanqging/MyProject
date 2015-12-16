//
//  UserCollecteTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/8/8.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserCollecteTableViewCell.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation UserCollecteTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor  =BackColor;
        view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, WIDTH(self)-20, HEIGHT(self)-10)];
        view.backgroundColor = WriteColor;
        [self addSubview:view];
        
        self.imgview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
        [view addSubview:self.imgview];
        
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgview)+10, Y(self.imgview), 210, 25)];
        self.titleLabel.font  =SYSTEMFONT(16);
        self.titleLabel.textColor = ColorTheme;
        [view addSubview:self.titleLabel];
        
        self.desclabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgview)+10, POS_Y(self.titleLabel)+5, 210, 25)];
        self.desclabel.numberOfLines=3;
        self.desclabel.font  =SYSTEMFONT(14);
        self.desclabel.textColor = ColorTheme;
        self.desclabel.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:self.desclabel];
        
        [self performSelector:@selector(layout:) withObject:nil afterDelay:0.1];
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


-(void)setStart:(NSString *)start
{
    self->_start =start;
    if (self.start) {
        UILabel* label = [view viewWithTag:10001];
        if (!label) {
            label = [[UILabel alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.titleLabel)+5, 20, 21)];
            label.tag=10001;
            label.font = SYSTEMFONT(14);
            label.textColor = FONT_COLOR_GRAY;
            [view addSubview:label];
            [TDUtil setLabelMutableText:label content:@"众筹开始时间:" lineSpacing:0 headIndent:0];
        }
        
        
       UILabel* labelValue = [view viewWithTag:10002];
        if (!labelValue) {
            labelValue = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), 20, HEIGHT(label))];
            labelValue.font = SYSTEMFONT(14);
            labelValue.tag=10002;
            [view addSubview:labelValue];
        }
        [TDUtil setLabelMutableText:labelValue content:self.start lineSpacing:0 headIndent:0];
    }
}

-(void)setEnd:(NSString *)end
{
    self->_end  =end;
    if (self.end) {
        UILabel* label = [view viewWithTag:10003];
        if (!label) {
            label = [[UILabel alloc]initWithFrame:CGRectMake(X(self.titleLabel), POS_Y(self.titleLabel)+25, 20, 21)];
            label.tag=10003;
            label.font = SYSTEMFONT(14);
            label.textColor = FONT_COLOR_GRAY;
            [view addSubview:label];
            [TDUtil setLabelMutableText:label content:@"众筹结束时间:" lineSpacing:0 headIndent:0];
        }
        
        UILabel* labelValue = [view viewWithTag:10004];
        if (!labelValue) {
            labelValue = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), 20, HEIGHT(label))];
            labelValue.tag=10004;
            labelValue.font = SYSTEMFONT(14);
            [view addSubview:labelValue];
        }
        
        [TDUtil setLabelMutableText:labelValue content:self.end lineSpacing:0 headIndent:0];
    }
}
@end
