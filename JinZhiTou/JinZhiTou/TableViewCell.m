//
//  TableViewCell.m
//  WeiNI
//
//  Created by air on 15/2/26.
//  Copyright (c) 2015年 weini. All rights reserved.
//

#import "TableViewCell.h"
#import "GlobalDefine.h"
@implementation TableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setIsSelected:(BOOL)isSelected
{
    self->_isSelected=isSelected;
    UIColor* defaultColor=self.backgroundColor;
    if (isSelected) {
        self.backgroundColor=CELL_SELECTED_COLOR;
        [UIView animateWithDuration:0.2f animations:^{
            self.backgroundColor=defaultColor;
        }];
    }
}


@end
