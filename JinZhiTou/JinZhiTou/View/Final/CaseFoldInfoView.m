//
//  InfoFoldView.m
//  JinZhiTou
//
//  Created by air on 16/1/13.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import "CaseFoldInfoView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "CompanyCaseItemView.h"
#import <QuartzCore/QuartzCore.h>
@implementation CaseFoldInfoView
-(id)init
{
    if (self = [super init]) {
        self.backgroundColor = WriteColor;
        //圆角
        self.layer.cornerRadius = 2;
        //边线
        self.layer.borderColor = LightGrayColor.CGColor;
        //宽度
        self.layer.borderWidth = 1;
        
        _label = [UILabel new];
        _lineView = [UIView new];
        
        [self addSubview:_label];
        [self addSubview:_lineView];
        
        //初始化控件
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        
        _lineView.backgroundColor = BackColor;
        
        _label.text  = @"投资案例";
        _label.font = SYSTEMFONT(18);
        _label.textColor  =ColorCompanyTheme;
        
        _label.sd_layout
        .leftSpaceToView(self,20)
        .topSpaceToView(self,10)
        .heightIs(20);
        
        _lineView.sd_layout
        .leftEqualToView(_label)
        .topSpaceToView(_label,0)
        .rightSpaceToView(self,20)
        .heightIs(1);
        
        [_label setSingleLineAutoResizeWithMaxWidth:200];
        
        
        _scrollView.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(_lineView,0)
        .heightIs(90);
    }
    
    return self;
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray) {
        self->_dataArray = dataArray;
        
        CompanyCaseItemView* itemView;
        for (int i = 0; i<dataArray.count; i++) {
            itemView = [[CompanyCaseItemView alloc]initWithFrame:CGRectMake(0, 0, 120, 90) ];
            [_scrollView addSubview:itemView];
            itemView.dic  =self.dataArray[i];
        }
        
        [self layoutSubviews];
        
    }
}
@end
