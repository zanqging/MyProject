//
//  FinialKind.m
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialKind.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation FinialKind
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imgView =[[UIImageView alloc]initWithFrame:CGRectMake(20, HEIGHT(self)/2-7.5, 15, 15)];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self  addSubview:self.imgView];
        
        //标签
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+5, 0, WIDTH(self)-POS_X(self.imgView)-10, HEIGHT(self))];
        self.label.font =SYSTEMFONT(16);
        self.label.textColor = ColorTheme;
        [self addSubview:self.label];
        
        self.layer.cornerRadius =5;
        self.backgroundColor =WriteColor;
    }
    return self;
}

-(void)setImageWithNmame:(NSString *)name setText:(NSString *)text
{
    if (name) {
        self.imgView.image = IMAGENAMED(name);
    }
    
    if (text) {
        self.label.text = text;
    }
}
@end
