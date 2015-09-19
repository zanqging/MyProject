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
                rect = CGRectMake(0, 10,w, HEIGHT(self)-20);
            }else if(i==4){
                rect = CGRectMake(POS_X(label), 10,w, HEIGHT(self)-20);
            }else{
                rect = CGRectMake(POS_X(label), 10,w, HEIGHT(self)-20);
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
                label.backgroundColor  =ColorTheme;
                label.textColor = WriteColor;
            }else{
                 label.textColor = ColorCompanyTheme;
            }
            
            UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT(scrollView)-1, WIDTH(scrollView), 1)];
            imgView.backgroundColor=BACKGROUND_COLOR;
            [scrollView addSubview:imgView];
            
            [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectIndex:)]];
            [scrollView addSubview:label];
            [scrollView setContentSize:CGSizeMake(POS_X(label), HEIGHT(self))];
            
        }
    }
    return self;
}
-(void)selectIndex:(id)sender
{
    for (UIView* v in scrollView.subviews) {
        if ([v isKindOfClass:UILabel.class]) {
            UILabel* label  = (UILabel*)v;
            label.backgroundColor = ClearColor;
            label.textColor = ColorCompanyTheme;
        }
    }
    UILabel* label = (UILabel*)[sender view];
    label.textColor = WriteColor;
    label.backgroundColor  =ColorTheme;
    
    if ([_delegate respondsToSelector:@selector(typeShow:selectedIndex:didSelectedString:)]) {
        [_delegate typeShow:self selectedIndex:label.tag didSelectedString:label.text];
    }
}
@end
