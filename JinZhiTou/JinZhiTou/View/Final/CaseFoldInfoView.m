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
        _iconImgView = [UIImageView new];
        
        [self addSubview:_label];
        [self addSubview:_lineView];
        [self addSubview:_iconImgView];
        
        //初始化控件
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        
        _lineView.backgroundColor = BackColor;
        
        _label.text  = @"投资案例";
        _label.font = SYSTEMFONT(18);
        _label.textColor  =ColorCompanyTheme;
        
        _iconImgView.image = IMAGENAMED(@"case");
        
        _iconImgView.sd_layout
        .leftSpaceToView(self, 20)
        .topSpaceToView(self, 10)
        .heightEqualToWidth(15);
        
        _label.sd_layout
        .leftSpaceToView(_iconImgView,5)
        .topSpaceToView(self,10)
        .heightIs(20);
        
        _lineView.sd_layout
        .leftEqualToView(_iconImgView)
        .topSpaceToView(_label,0)
        .rightSpaceToView(self,20)
        .heightIs(1);
        
        [_label setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    
    return self;
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray) {
        self->_dataArray = dataArray;
        
        CompanyCaseItemView* itemView;
        float pos_x = 5;
        float width = (WIDTH(self)-10)/3;
        for (int i = 0; i<self.dataArray.count; i++) {
            itemView = [[CompanyCaseItemView alloc]initWithFrame:CGRectMake(pos_x, 0, width, 90) ];
            [_scrollView addSubview:itemView];
            itemView.dic  =self.dataArray[i];
            pos_x += width+5;
        }
        
        _scrollView.sd_layout
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .topSpaceToView(_lineView,0);
        
        [self setupAutoHeightWithBottomView:_scrollView bottomMargin:10];
        
        if (self.dataArray && self.dataArray.count > 0) {
            _scrollView.sd_layout
            .heightIs(90);
        }else{
            _scrollView.sd_layout
            .autoHeightRatio(0);
        }
        
        [_scrollView setupAutoContentSizeWithRightView:itemView rightMargin:10];
        
        [self layoutSubviews];   
    }
}

@end
