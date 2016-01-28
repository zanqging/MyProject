//
//  ThinkTankTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/9/22.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinalPersonTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation FinalPersonTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(10, 5, frame.size.width-20,frame.size.height-5)];
        view.backgroundColor= WriteColor;
        //项目图片
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 130,HEIGHT(view)-10)];
        self.imgView.image = IMAGENAMED(@"loading");
        self.imgView.contentMode = UIViewContentModeScaleToFill;
//        self.imgView.layer.cornerRadius = 3;
        self.imgView.layer.masksToBounds = YES;
        [view addSubview:self.imgView];
        [self addSubview:view];
        //名称
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+15, Y(self.imgView)+15, 130, 21)];
        self.titleLabel.font = SYSTEMFONT(12);
        self.titleLabel.textColor = FONT_COLOR_BLACK;
        [view addSubview:self.titleLabel];
        
        //描述
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+15, POS_Y(self.titleLabel), WIDTH(self)/2-10, 21)];
        self.contentLabel.font = SYSTEMFONT(12);
        self.contentLabel.textColor = FONT_COLOR_BLACK;
        [view addSubview:self.contentLabel];
        
        //描述
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+15, POS_Y(self.contentLabel), WIDTH(self.contentLabel)+10, 21)];
        self.typeLabel.numberOfLines = 3;
        self.typeLabel.font = SYSTEMFONT(12);
        self.typeLabel.textColor = FONT_COLOR_BLACK;
        self.typeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [view addSubview:self.typeLabel];
        //
        
        [view setFrame:CGRectMake(10, 5, frame.size.width-20,frame.size.height-5)];
        [self.imgView setFrame:CGRectMake(5, 5, 130,HEIGHT(view)-10)];
        
        self.backgroundColor = BackColor;
        
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+5, 5, WIDTH(view) - 145, HEIGHT(view)-10)];
        view1.backgroundColor = ClearColor;
        view1.layer.cornerRadius = 2;
        view1.layer.borderColor = BackColor.CGColor;
        view1.layer.borderWidth = 1;
        
        [view addSubview:view1];
        
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
        self.titleLabel.text=[NSString stringWithFormat:@"NAME:%@",self.title];
    }
    
}

-(void)setContent:(NSString *)content
{
    self->_content=content;
    if (self.content) {
        self.contentLabel.text=[NSString stringWithFormat:@"COMPANY:%@",self.content];
    }
}

-(void)setTypeDescription:(NSString *)typeDescription
{
    self->_typeDescription=typeDescription;
    if (self.typeDescription) {
        self.typeLabel.text=[NSString stringWithFormat:@"DUTIES:%@",self.typeDescription];
    }
}

@end
