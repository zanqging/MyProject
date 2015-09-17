//
//  FinialProctoTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialProctoTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation FinialProctoTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imgView];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10, 10, WIDTH(self)-POS_X(imgView)-70, 50)];
        label.numberOfLines = 0 ;
        label.font = SYSTEMFONT(16);
        label.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        
        [self addSubview:label];
    }
    return self;
}

-(void)setImageWithName:(NSString *)name setText:(NSString *)text
{
    if (name) {
        imgView.image = IMAGENAMED(name);
    }
    
    if (text) {
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:5];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [text length])];
        [label setAttributedText:attributedString1];
        [label sizeToFit];
    }
}


-(void)setIsSelected:(BOOL)isSelected
{
    self->_isSelected = isSelected;
    if (self.isSelected) {
        self.backgroundColor = CELL_SELECTED_COLOR;
    }else{
        self.backgroundColor = WriteColor;
    }
    
}
@end
