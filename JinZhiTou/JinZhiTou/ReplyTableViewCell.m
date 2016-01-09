//
//  DemoVC5CellTableViewCell.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/11/22.
//  Copyright (c) 2015年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * QQ    : 2689718696(gsdios)                                                      *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */


#import "ReplyTableViewCell.h"

#import "UIView+SDAutoLayout.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

@implementation ReplyTableViewCell
{
    UILabel *_view1;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    _view1 = [UILabel new];
    _view1.textColor = [UIColor blackColor];
    _view1.font = [UIFont systemFontOfSize:13];
    _view1.numberOfLines=0;
    _view1.text = @"徐力回复刘路:这个项目不错，可以考虑上市，先要把财务做规范!";
    
    [self.contentView addSubview:_view1];
    
    _view1.sd_layout
    .topSpaceToView(self.contentView,2)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView,10)
//    .widthIs(self.contentView.frame.size.width-20)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_view1 bottomMargin:2];
}

//- (void)setModel:(DemoVC5Model *)model
//{
//    _model = model;
//    //***********************高度自适应cell设置步骤************************
//    
//    [self setupAutoHeightWithBottomView:_view1 bottomMargin:2];
//}

@end
