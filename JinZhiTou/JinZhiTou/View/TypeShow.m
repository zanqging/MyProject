//
//  TypeShow.m
//  JinZhiTou
//
//  Created by air on 15/9/7.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "TypeShow.h"
#import "GlobalDefine.h"
#import "UConstants.h"
#import <QuartzCore/QuartzCore.h>
@implementation TypeShow
-(id)initWithFrame:(CGRect)frame data:(NSMutableArray *)dataArray
{
    if (self = [super initWithFrame:(CGRect)frame]) {
        self.dataArray  =dataArray;
        frame.origin.x = 0;
        frame.origin.y = 0;
        scrollView = [[UIScrollView alloc]initWithFrame:frame];
        scrollView.backgroundColor  =WriteColor;
        scrollView.showsVerticalScrollIndicator  =NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        
        
        float w ;
        if (dataArray.count >= 4) {
            w = WIDTH(self)/4;
        }else{
             w = WIDTH(self)/dataArray.count;
        }
        UILabel* label;
        NSDictionary* dic;
        for (int  i = 0; i<dataArray.count; i++) {
            dic = dataArray[i];
            CGRect rect;
            if (i==0) {
                rect = CGRectMake(0, 0,w, HEIGHT(self));
            }else if(i==4){
                rect = CGRectMake(POS_X(label), 0,w, HEIGHT(self));
            }else{
                rect = CGRectMake(POS_X(label), 0,w, HEIGHT(self));
            }
            
            label= [[UILabel alloc]initWithFrame:rect];
            label.textAlignment  =NSTextAlignmentCenter;
            label.userInteractionEnabled  =YES;
            label.font  =SYSTEMFONT(14);
           
//            label.layer.cornerRadius = HEIGHT(self)/2-10;
            label.layer.masksToBounds = YES;
            
            label.text = [dic valueForKey:@"value"];
            label.tag =[[dic valueForKey:@"key"] integerValue];
            if( i == 0){
                label.textColor = AppColorTheme;
            }else{
                 label.textColor = BlackColor;
            }
            
            
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectIndex:)]];
            [scrollView addSubview:label];
            [scrollView setContentSize:CGSizeMake(POS_X(label), HEIGHT(self))];
        }
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT(scrollView)-3, WIDTH(label), 3)];
        imgView.tag=10001;
        imgView.backgroundColor=AppColorTheme;
        [scrollView addSubview:imgView];
    }
    return self;
}
-(void)selectIndex:(id)sender
{
    for (UIView* v in scrollView.subviews) {
        if ([v isKindOfClass:UILabel.class]) {
            UILabel* label  = (UILabel*)v;
            label.backgroundColor = ClearColor;
            label.textColor = FONT_COLOR_BLACK;
        }
    }
    
    UILabel* label = (UILabel*)[sender view];
    label.textColor = AppColorTheme;
    
    //滑块  动画
    UIImageView* imgView = [scrollView viewWithTag:10001];
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        [imgView setFrame:CGRectMake(X(label), Y(imgView), WIDTH(imgView), HEIGHT(imgView))];
    } completion:nil];
    if ([_delegate respondsToSelector:@selector(typeShow:selectedIndex:didSelectedString:)]) {
        [_delegate typeShow:self selectedIndex:label.tag didSelectedString:label.text];
    }
}
@end
