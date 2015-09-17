//
//  SearchTableViewHeader.m
//  ;
//
//  Created by air on 15/8/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "SearchTableViewHeader.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation SearchTableViewHeader
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDTH(self)-40, HEIGHT(self))];
        label.backgroundColor = ClearColor;
        label.font = SYSTEMFONT(14);
        label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [self addSubview:label];
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT(self), WIDTH(self), 1)];
        imgView.backgroundColor = BackColor;
        [self addSubview:imgView];
        
        self.backgroundColor = BackColor;
    }
    return self;
}


-(void)setTitle:(NSString *)title
{
    self->_title = title;
    label.text = self.title;
}
@end
