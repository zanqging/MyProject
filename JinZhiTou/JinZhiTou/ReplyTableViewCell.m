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
#import "TDUtil.h"
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
    _view1.backgroundColor = ClearColor;
    _view1.textColor = [UIColor blackColor];
    _view1.font = [UIFont systemFontOfSize:13];
    _view1.numberOfLines=0;
    _view1.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.contentView addSubview:_view1];
    
    _view1.sd_layout
    .topSpaceToView(self.contentView,2)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView,10)
    .bottomSpaceToView(self.contentView,2)
    .autoHeightRatio(0);
}

//- (void)setModel:(DemoVC5Model *)model
//{
//    _model = model;
//    //***********************高度自适应cell设置步骤************************
//    
//    [self setupAutoHeightWithBottomView:_view1 bottomMargin:2];
//}

-(void)setDic:(NSDictionary *)dic
{
    if (dic) {
        self->_dic = dic;
        
        //开始组装
        NSString* name = [dic valueForKey:@"name"];
        NSString* atName = [dic valueForKey:@"at_name"];
        NSString* suffix = @":";
        NSString* content = [dic valueForKey:@"content"];
        NSString* str = @"";
        if (name) {
            str =[str stringByAppendingString:name];
        }
        
        if ([TDUtil isValidString:atName] ) {
            str = [str stringByAppendingFormat:@"回复%@%@",atName,suffix];
        }else{
            str = [str stringByAppendingFormat:@"%@",suffix];
        }
        
        str = [str stringByAppendingFormat:@" %@",content];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        
        [paragraphStyle setLineSpacing:0];//调整行间距
        //    [paragraphStyle setAlignment:NSTextAlignmentLeft];
        [paragraphStyle setFirstLineHeadIndent:0];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:ColorCompanyTheme range:NSMakeRange(0, [name length])];
        
        if ([TDUtil isValidString:atName]) {
            [attributedString addAttribute:NSForegroundColorAttributeName value:ColorCompanyTheme range:NSMakeRange([name length]+2, [atName length])];
        }
        
        _view1.attributedText = attributedString;//ios 6
//        [_view1 sizeToFit];
        
//        _view1.sd_layout
//        .topSpaceToView(self.contentView,2)
//        .leftSpaceToView(self.contentView, 10)
//        .rightSpaceToView(self.contentView,10)
//        .bottomSpaceToView(self.contentView,2)
//        .autoHeightRatio(0);
        
//        [self setupAutoHeightWithBottomView:_view1 bottomMargin:12];
        [self layoutSubviews];
        [self setupAutoHeightWithBottomView:_view1 bottomMargin:2];
    }
}

@end
