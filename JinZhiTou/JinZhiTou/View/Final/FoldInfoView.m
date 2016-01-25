//
//  InfoFoldView.m
//  JinZhiTou
//
//  Created by air on 16/1/13.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import "FoldInfoView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation FoldInfoView
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
        
        //初始化控件
        _imgView = [UIImageView new];
        _titleLabel = [UILabel new];
        _lineView = [UIView new];
        _contentLabel = [UILabel new];
        
        [self addSubview:_imgView];
        [self addSubview:_titleLabel];
        [self addSubview:_lineView];
        [self addSubview:_contentLabel];
        
        _lineView.backgroundColor = BackColor;
        _titleLabel.textColor = ColorCompanyTheme;
        
        _contentLabel.font = SYSTEMFONT(14);
        
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        //自适应布局
        _imgView.sd_layout
        .leftSpaceToView(self, 20)
        .topSpaceToView(self, 12)
        .widthIs(15);
        
        _titleLabel.sd_layout
        .leftSpaceToView(_imgView,5)
        .autoHeightRatio(0)
        .topSpaceToView(self,10);
        [_titleLabel setSingleLineAutoResizeWithMaxWidth:200];
        
        _lineView.sd_layout
        .rightSpaceToView(self,20)
        .leftEqualToView(_imgView)
        .topSpaceToView(_titleLabel,5)
        .heightIs(1);
        
        _contentLabel.sd_layout
        .leftEqualToView(_lineView)
        .rightEqualToView(_lineView)
        .topSpaceToView(_lineView,5)
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:_contentLabel bottomMargin:20];
    }
    
    return self;
}

-(void)setDic:(NSMutableDictionary *)dic
{
    if (dic) {
        self->_dic = dic;
        _titleLabel.text = [dic valueForKey:@"title"];
        _contentLabel.text = [dic valueForKey:@"content"];
        _imgView.image = IMAGENAMED([self.dic valueForKey:@"img"]);
        [self layoutSubviews];
        
    }
}
@end
