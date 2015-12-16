//
//  UserInfoConfig.m
//  JinZhiTou
//
//  Created by air on 15/11/7.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "UserInfoConfigView.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
@implementation UserInfoConfigView
-(id)initWithFrame:(CGRect)frame
{
    if (self  = [super initWithFrame:frame]) {
        view =[[UIView alloc]initWithFrame:frame];
        view.alpha = 0.7;
        view.backgroundColor = BlackColor;
        view.userInteractionEnabled  =YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removewFromSuperView:)]];
        
        [self addSubview:view];
        
        view = [[UIView alloc]initWithFrame:CGRectMake(10, HEIGHT(self)/4, WIDTH(self)-20, HEIGHT(self)/2)];
        view.backgroundColor  =WriteColor;
        [self addSubview:view];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), 30)];
        label.textAlignment  =NSTextAlignmentCenter;
        label.text = @"成为金指投认证投资人";
        [view addSubview:label];
        
        
        UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)-50, 5, 20, 20)];
        [btnAction setTitleColor:ColorTheme2 forState:UIControlStateNormal];
        [btnAction setImage:IMAGENAMED(@"close_credit") forState:UIControlStateNormal];
        [btnAction addTarget:self action:@selector(removewFromSuperView:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnAction];
        
        
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds  =YES;
        
        //分割线
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(label), WIDTH(self), 1)];
        lineView.backgroundColor =BackColor;
        [view addSubview:lineView];
    
        self.personalView = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(label), WIDTH(self), (HEIGHT(view)-HEIGHT(label))/2)];
        self.personalView.tag=1000;
        
        //图片
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, HEIGHT(self.personalView)-20)];
        imgView.image = IMAGENAMED(@"person");
        imgView.backgroundColor  =BackColor;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.personalView addSubview:imgView];
        
        //标题
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10, HEIGHT(self.personalView)/2-20, WIDTH(self.personalView)-120, 20)];;
        label.font = SYSTEMFONT(18);
        [TDUtil setLabelMutableText:label content:@"我是个人投资人" lineSpacing:0 headIndent:0];
        [self.personalView addSubview:label];
        
        //标题
        label = [[UILabel alloc]initWithFrame:CGRectMake(X(label), POS_Y(label)+5, WIDTH(label), 20)];
        label.text = @"金指投个人投资人";
        label.font = SYSTEMFONT(12);
        label.textAlignment = NSTextAlignmentCenter;
        [self.personalView addSubview:label];
        
        //触摸事件
        self.personalView.userInteractionEnabled  =YES;
        [self.personalView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)]];
        [view addSubview:self.personalView];
        
        
        self.instituteView = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(self.personalView), WIDTH(self), HEIGHT(self.personalView))];
        self.instituteView.tag = 1001;
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, HEIGHT(self.personalView)-20)];
        imgView.image = IMAGENAMED(@"commiunte");
        imgView.backgroundColor  =BackColor;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.instituteView addSubview:imgView];
        
        //标题
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10, HEIGHT(self.instituteView)/2-20, WIDTH(self.instituteView)-120, 20)];;
        label.font = SYSTEMFONT(18);
        [TDUtil setLabelMutableText:label content:@"我是机构投资人" lineSpacing:0 headIndent:0];
        [self.instituteView addSubview:label];
        
        //标题
        label = [[UILabel alloc]initWithFrame:CGRectMake(X(label), POS_Y(label)+5, WIDTH(label), 20)];
        label.text = @"金指投机构投资人";
        label.font = SYSTEMFONT(12);
        label.textAlignment = NSTextAlignmentCenter;
        [self.instituteView addSubview:label];
        
        
        self.instituteView.userInteractionEnabled  =YES;
        [self.instituteView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)]];
        
        [view addSubview:self.instituteView];
        
        //分割线
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(self.personalView), WIDTH(self.personalView), 1)];
        lineView.backgroundColor =BackColor;
        [view addSubview:lineView];
        
    }
    return self;
}

-(void)tapAction:(UITapGestureRecognizer*)recognizer
{
    NSInteger tag = recognizer.view.tag;
    if ([_delegate respondsToSelector:@selector(userInfoConfigView:target:selectedIndex:data:)]) {
        [_delegate userInfoConfigView:self target:self.viewController  selectedIndex:(int)(tag-1000) data:nil];
        [self removeFromSuperview];
    }
}

-(void)removewFromSuperView:(id)sender
{
    [self removeFromSuperview];
}
@end
