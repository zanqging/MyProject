//
//  InfoFoldView.m
//  JinZhiTou
//
//  Created by air on 16/1/13.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import "ComFinanceFoldInfoView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation ComFinanceFoldInfoView
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
        _lineView = [UIView new];
        _contentLabel1 = [UILabel new];
        _contentLabel2 = [UILabel new];
        _contentLabel3 = [UILabel new];
        _contentLabel4 = [UILabel new];
        
        [self addSubview:_imgView];
        [self addSubview:_contentLabel1];
        [self addSubview:_contentLabel2];
        [self addSubview:_contentLabel3];
        [self addSubview:_contentLabel4];
        [self addSubview:_lineView];
        
        
        _contentLabel1.font = SYSTEMFONT(14);
        _contentLabel2.font = SYSTEMFONT(14);
        _contentLabel3.font = SYSTEMFONT(14);
        _contentLabel4.font = SYSTEMFONT(14);
        _imgView.backgroundColor = BlackColor;
        _lineView.backgroundColor = BackColor;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        //自适应布局
        _imgView.sd_layout
        .leftSpaceToView(self,30)
        .heightRatioToView(self,0.4)
        .topSpaceToView(self,0);
        
        _lineView.sd_layout
        .rightSpaceToView(self,20)
        .leftEqualToView(_imgView)
        .topSpaceToView(_imgView,5)
        .heightIs(1);
        
        _contentLabel1.sd_layout
        .leftEqualToView(_lineView)
        .rightEqualToView(_lineView)
        .topSpaceToView(_lineView,5)
        .autoHeightRatio(0);
        
        _contentLabel2.sd_layout
        .leftEqualToView(_lineView)
        .rightEqualToView(_lineView)
        .topSpaceToView(_contentLabel1,5)
        .autoHeightRatio(0);
        
        
        _contentLabel3.sd_layout
        .leftEqualToView(_lineView)
        .rightEqualToView(_lineView)
        .topSpaceToView(_contentLabel2,5)
        .autoHeightRatio(0);
        
        _contentLabel4.sd_layout
        .leftEqualToView(_lineView)
        .rightEqualToView(_lineView)
        .topSpaceToView(_contentLabel3,5)
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:_contentLabel4 bottomMargin:20];
    }
    
    return self;
}

-(void)setDic:(NSMutableDictionary *)dic
{
    if (dic) {
        self->_dic = dic;
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"logo"]] placeholderImage:IMAGENAMED(@"loading")];
        _contentLabel1.text  = [dic valueForKey:@"name"];
        _contentLabel2.text  = [NSString stringWithFormat:@"成立时间:%@",[dic valueForKey:@"foundingtime"]];
        _contentLabel3.text  = [NSString stringWithFormat:@"机构总部:%@",[dic valueForKey:@"addr"]];
        _contentLabel4.text  = [NSString stringWithFormat:@"公司官网:%@",[dic valueForKey:@"homepage"]];
        
        [self layoutSubviews];
        
    }
}
@end
