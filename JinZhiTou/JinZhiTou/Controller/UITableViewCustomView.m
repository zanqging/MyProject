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
        view = [self viewWithTag:100001];
        if (!view) {
            view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
            view.tag=100001;
            emptyImgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-50, HEIGHT(view)/2-120, 100, 100)];
            emptyImgView.image = IMAGE(@"empty", @"png");
            emptyImgView.contentMode = UIViewContentModeScaleAspectFill;
            [view addSubview:emptyImgView];
            
            label =[[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(emptyImgView)+40, WIDTH(view), 30)];
            [view addSubview:label];
            label.text = @"暂无数据";
            label.textAlignment =NSTextAlignmentCenter;
            label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
            [self addSubview:view];
        }
        
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        view.alpha = 1;
    }else{
        view = [self viewWithTag:100001];
        if (view) {
            view.alpha=0;
        }
        self.separatorStyle =UITableViewCellSelectionStyleNone;
        
    }
}

-(void)setEmptyImgFileName:(NSString *)emptyImgFileName
{
    self->_emptyImgFileName = emptyImgFileName;
    if ([TDUtil isValidString:self.emptyImgFileName]) {
        emptyImgView.image  = IMAGE(self.emptyImgFileName, @"png");
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
