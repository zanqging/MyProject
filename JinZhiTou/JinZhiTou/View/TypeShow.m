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
        frame.origin.x = 0;
        frame.origin.y = 0;
        scrollView = [[UIScrollView alloc]initWithFrame:frame];
        scrollView.backgroundColor  =WriteColor;
        scrollView.showsVerticalScrollIndicator  =NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        
        
        float w = WIDTH(self)/dataArray.count-10;
        NSDictionary* dic;
        for (int  i = 0; i<dataArray.count; i++) {
            dic = dataArray[i];
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(15+w*i, 10,w, HEIGHT(self)-20)];
            label.textAlignment  =NSTextAlignmentCenter;
            label.userInteractionEnabled  =YES;
           
//            label.layer.cornerRadius = HEIGHT(self)/2-10;
            label.layer.masksToBounds = YES;
            
            label.text = [dic valueForKey:@"name"];
            if([[dic valueForKey:@"isSelected"] isEqualToString:@"Yes"]){
                label.backgroundColor  =ColorTheme;
                label.textColor = WriteColor;
            }else{
                 label.textColor = ColorCompanyTheme;
            }
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
}
@end
