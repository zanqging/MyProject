//
//  FinialPlanTableViewCell.m
//  JinZhiTou
//
//  Created by air on 16/1/25.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import "FinialPlanTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "GlobalDefine.h"
#import "UConstants.h"
#import "TDUtil.h"
@implementation FinialPlanTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    
    return self;
}

-(void)setup
{
    //1.初始化控件
    _iconImgView = [UIImageView new];
    _labelTitle = [UILabel new];
    _labelContent = [UILabel new];
    _lineSeprateView =[UIView new];
    _bottomLineSeprateView =[UIView new];
    //2.设置属性
//    _iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    _labelTitle.textColor = FONT_COLOR_BLACK;
    _labelTitle.font = SYSTEMFONT(16);
    
    _labelTitle.textColor = FONT_COLOR_BLACK;
    _labelTitle.font = SYSTEMFONT(14);
    _labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
    _labelContent.font = SYSTEMFONT(14);
    _labelContent.textColor = FONT_COLOR_BLACK;
    
    _lineSeprateView.backgroundColor = BackColor;
    
    _bottomLineSeprateView.backgroundColor = BackColor;
    
    //3.添加到视图
    [self.contentView addSubview:_iconImgView];
    [self.contentView addSubview:_labelTitle];
    [self.contentView addSubview:_labelContent];
    [self.contentView addSubview:_lineSeprateView];
    [self.contentView addSubview:_bottomLineSeprateView];
    
    //4.自适应布局
    UIView * contentView = self.contentView;
    _iconImgView.sd_layout
    .leftSpaceToView(contentView, 30)
    .topSpaceToView(contentView, 30)
    .widthIs(30)
    .heightIs(30);
//
    _labelTitle.sd_layout
    .leftSpaceToView(_iconImgView, 0)
    .heightIs(30)
    .topEqualToView(_iconImgView);
    
    [_labelTitle setSingleLineAutoResizeWithMaxWidth:250];
    
    _lineSeprateView.sd_layout
    .topSpaceToView(_labelTitle, 5)
    .leftEqualToView(_labelTitle)
    .rightSpaceToView(contentView, 20)
    .heightIs(1);
//
    _labelContent.sd_layout
    .leftEqualToView(_labelTitle)
    .rightSpaceToView(contentView, 20)
    .topSpaceToView(_lineSeprateView,5)
    .autoHeightRatio(0);
    
    _bottomLineSeprateView.sd_layout
    .leftEqualToView(contentView)
    .rightEqualToView(contentView)
    .topSpaceToView(_labelContent, 10)
    .heightIs(3);
    
    [self setupAutoHeightWithBottomView:_bottomLineSeprateView bottomMargin:0];
    
}


-(void)setDic:(NSDictionary *)dic
{
    self->_dic = dic;
    if (self.dic) {
        _iconImgView.image = IMAGENAMED(DICVFK(dic, @"img"));
    }
}

-(void)setTitle:(NSString *)title
{
    self->_title = title;
    _labelTitle.text = [NSString stringWithFormat:@"%@%@",DICVFK(self.dic, @"title"),self.title];
}

-(void)setContent:(NSString *)content
{
    self->_content = content;
    _labelContent.text = self.content;
}

@end
