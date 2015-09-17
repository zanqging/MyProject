//
//  FinalKindTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/7/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinalKindTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"

@implementation FinalKindTableViewCell
{
    UIImageView* imgView;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIsSelected:(BOOL)isSelected
{
    self->_isSelected=isSelected;
    if (isSelected) {
        self.lblFunName.textColor=ColorTheme;
       // self.imageView.backgroundColor=ColorTheme;
        if (!imgView) {
            CGRect frame = self.frame;
            frame.size.height = 60;
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-1, WIDTH(self), 1)];
            [self addSubview:imgView];
        }
        imgView.backgroundColor = ColorTheme;
    }else{
        self.lblFunName.textColor=BlackColor;
       // self.imageView.backgroundColor=ClearColor;
        imgView.backgroundColor = ClearColor;
    }
    
}

@end
