//
//  UITableViewCustomViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/14.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UITableViewCustomView.h"
#import "GlobalDefine.h"
#import "UConstants.h"
#import "TDUtil.h"
@interface UITableViewCustomView ()
{
    UIView* view;
    UILabel* label;
    UIImageView* emptyImgView;
}

@end

@implementation UITableViewCustomView


-(void)setIsNone:(BOOL)isNone
{
    self->_isNone = isNone;
    if (isNone) {
        if (!view) {
            view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
            emptyImgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-50, HEIGHT(view)/2-100, 100, 100)];
            emptyImgView.image = IMAGENAMED(@"tourongzi-konghezi");
            emptyImgView.contentMode = UIViewContentModeScaleAspectFill;
            [view addSubview:emptyImgView];
            
            label =[[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(emptyImgView)+10, WIDTH(view), 30)];
            [view addSubview:label];
            label.textAlignment =NSTextAlignmentCenter;
            label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
            [self addSubview:view];
        }
        
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        view.alpha = 1;
    }else{
        if (view) {
            view.alpha = 0;
        }
        self.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
        
    }
}

-(void)setEmptyImgFileName:(NSString *)emptyImgFileName
{
    self->_emptyImgFileName = emptyImgFileName;
    if ([TDUtil isValidString:self.emptyImgFileName]) {
        emptyImgView.image  = IMAGENAMED(self.emptyImgFileName);
    }
}

-(void)setContent:(NSString *)content
{
    self->_content = content;
    label.text = content;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
