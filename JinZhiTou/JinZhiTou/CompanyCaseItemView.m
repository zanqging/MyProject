//
//  CompanyCaseItemView.m
//  JinZhiTou
//
//  Created by air on 16/1/13.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import "CompanyCaseItemView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation CompanyCaseItemView
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/4-5, 7, WIDTH(self)/2+10, WIDTH(self)/2+10)];
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT(self)-20, WIDTH(self),20)];
        
        [self addSubview:_imgView];
        [self addSubview:_label];
        
        _label.font = SYSTEMFONT(12);
        _label.textAlignment = NSTextAlignmentCenter;
        
        _imgView.layer.cornerRadius = WIDTH(self)/4+5;
        _imgView.layer.masksToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleToFill;
        
    }
    return self;
}

-(void)setDic:(NSDictionary *)dic
{
    if (dic) {
        self->_dic = dic;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"logo"]] placeholderImage:IMAGENAMED(@"loading")];
        _label.text = [dic valueForKey:@"company"];
        
        [self layoutSubviews];
    }
}
@end
