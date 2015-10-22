//
//  CycleHeader.m
//  JinZhiTou
//
//  Created by air on 15/10/22.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "CycleHeader.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation CycleHeader
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = WriteColor;
        
        self.headerBackView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-40)];
        self.headerBackView.image =[TDUtil loadContent:STATIC_USER_BACKGROUND_PIC];
        self.headerBackView.layer.masksToBounds  =YES;
        self.headerBackView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.headerBackView];
        
        self.headerView  =[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)-90, HEIGHT(self)-70, 70, 70)];
        self.headerView.image  =[TDUtil loadContent:STATIC_USER_HEADER_PIC];
        self.headerView.layer.borderColor = WriteColor.CGColor;
        self.headerView.layer.borderWidth = 2;
        self.headerView.contentMode  =UIViewContentModeScaleToFill;
        [self addSubview:self.headerView];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y(self.headerView)+10, WIDTH(self)-100, 21)];
        self.nameLabel.textColor  = WriteColor;
        self.nameLabel.text = @"陈生珠";
        self.nameLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.nameLabel];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
