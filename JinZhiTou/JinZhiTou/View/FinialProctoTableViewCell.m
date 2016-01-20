//
//  FinialProctoTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialProctoTableViewCell.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation FinialProctoTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //1.初始化控件
        label = [[UILabel alloc]init];
        imgView = [[UIImageView alloc]init];
        
        //2.添加到父视图
        [self.contentView addSubview:label];
        [self.contentView addSubview:imgView];
        
        //3.设置属性
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        label.numberOfLines = 0 ;
        label.font = SYSTEMFONT(14);
        label.textColor =FONT_COLOR_GRAY;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        
        //4.设置自适应
        imgView.sd_layout
        .widthIs(20)
        .leftSpaceToView(self.contentView, 20)
        .topSpaceToView(self.contentView, 15);
        
        label.sd_layout
        .topSpaceToView(imgView, -20)
        .leftSpaceToView(imgView, 5)
        .rightSpaceToView(self.contentView, 20)
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:label bottomMargin:10];
    }
    return self;
}

-(void)setImageWithName:(NSString *)name setText:(NSString *)text
{
    if (name) {
        self.unSelectedImageName = name;
        self.selectedImageName = [self.unSelectedImageName substringToIndex:[self.unSelectedImageName length]-2];
        imgView.image = IMAGENAMED(name);
    }
    
    if (text) {
//        [TDUtil setLabelMutableText:label content:text lineSpacing:3 headIndent:0];
        label.text = text;
    }
    
}


-(void)setIsSelected:(BOOL)isSelected
{
    self->_isSelected = isSelected;
    if (self.isSelected) {
//        self.backgroundColor = CELL_SELECTED_COLOR;
        label.textColor = ColorTheme2;
        imgView.image = IMAGENAMED(self.selectedImageName);
    }else{
//        self.backgroundColor = WriteColor;
        label.textColor = FONT_COLOR_GRAY;
        imgView.image = IMAGENAMED(self.unSelectedImageName);
    }
    
}
@end
