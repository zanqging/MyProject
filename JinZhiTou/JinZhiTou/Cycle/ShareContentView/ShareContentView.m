//
//  ShareContentView.m
//  JinZhiTou
//
//  Created by air on 16/1/8.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import "ShareContentView.h"
@implementation ShareContentView
-(id)init
{
    if (self = [super init]) {
        self.backgroundColor = BackColor;
        [self setup];
    }
    return self;
}

-(void)setup
{
    imgView = [UIImageView new];
    labelContent = [UILabel new];
    labelContent.numberOfLines =2;
    labelContent.font = SYSTEMFONT(14);
    labelContent.textColor = FONT_COLOR_BLACK;
    labelContent.lineBreakMode = NSLineBreakByTruncatingTail;
    labelContent.text=@"新三板，新三板，新三板，新三板，新三板，新三板，新三板，新三板，新三板，新三板，";
    //添加视图
    [self addSubview:imgView];
    [self addSubview:labelContent];
    
    //自动布局
    imgView.sd_layout
    .leftSpaceToView(self,5)
    .topSpaceToView(self,5)
    .heightIs(40)
    .widthEqualToHeight();
    
    
    labelContent.sd_layout
    .rightSpaceToView(self,5)
    .leftSpaceToView(imgView,5)
    .topSpaceToView(self,5)
    .heightIs(40);
//    .bottomSpaceToView(imgView,10);
    
    [self setupAutoHeightWithBottomView:imgView bottomMargin:5];
}

-(void)setDic:(NSDictionary *)dic
{
    if (dic) {
        self->_dic  =dic;
        [imgView sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"img"]] placeholderImage:IMAGENAMED(@"loading")];
        labelContent.text =[dic valueForKey:@"title"];
    }
}
@end
