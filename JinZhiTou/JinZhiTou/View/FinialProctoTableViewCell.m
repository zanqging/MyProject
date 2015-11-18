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
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imgView];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10, 10, WIDTH(self)-POS_X(imgView)-60, 50)];
        label.numberOfLines = 0 ;
        label.font = SYSTEMFONT(14);
        label.textColor =FONT_COLOR_GRAY;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        
        [self addSubview:label];
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
        [TDUtil setLabelMutableText:label content:text lineSpacing:3 headIndent:0];
    }
    
}


-(void)setIsSelected:(BOOL)isSelected
{
    self->_isSelected = isSelected;
    if (self.isSelected) {
        self.backgroundColor = CELL_SELECTED_COLOR;
        label.textColor = ColorTheme2;
        imgView.image = IMAGENAMED(self.selectedImageName);
    }else{
        self.backgroundColor = WriteColor;
        label.textColor = FONT_COLOR_GRAY;
        imgView.image = IMAGENAMED(self.unSelectedImageName);
    }
    
}
@end
