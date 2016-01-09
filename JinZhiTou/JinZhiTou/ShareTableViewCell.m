//
//  DemoVC9Cell.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//


/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * 持续更新地址: https://github.com/gsdios/SDAutoLayout                              *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */

#import "ShareTableViewCell.h"

#import "Demo9Model.h"
#import "ShareContentView.h"
#import "ReplyTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWeiXinPhotoContainerView.h"
#import "UITableView+SDAutoTableViewCellHeight.h"


@implementation ShareTableViewCell
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    
    ShareContentView* _shareView;
    
    UILabel *_timeLabel;
    
    //删除按钮
    UIButton *_btnDelete;
    //点赞
    UIButton *_btnPrise;
    //评论
    UIButton *_btnComment;
    
    //点赞、评论列表
    UIView* _viewComment;
    //回复背景
    UIImageView *imgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier commentViewHeight:(CGFloat)height commentHeaderViewHeight:(CGFloat)headerHeight
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.commentViewHeight = height;
        self.commentHeaderViewHeight = headerHeight;
//        [self setup];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.commentViewHeight=200;
        self.commentHeaderViewHeight=20;
//        [self setup];
    }
    return self;
}

- (void)setup
{
    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    
    _shareView = [[ShareContentView alloc]init];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
    _btnDelete = [[UIButton alloc]init];
    [_btnDelete setTitle:@"删除" forState:UIControlStateNormal];
    [_btnDelete.titleLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
    [_btnDelete setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    _btnPrise = [[UIButton alloc]init];
    [_btnPrise.titleLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
    [_btnPrise setImage:IMAGENAMED(@"gossip_like_normal") forState:UIControlStateNormal];
    [_btnPrise setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    _btnComment = [[UIButton alloc]init];
    [_btnComment setImage:IMAGENAMED(@"gossip_comment") forState:UIControlStateNormal];
    [_btnComment.titleLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
    [_btnComment setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    _viewComment = [[UIView alloc]init];
    _viewComment.layer.cornerRadius=3;
    
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel, _shareView, _timeLabel,_btnDelete,_btnPrise,_btnComment,_viewComment];
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    [self layout];
    
    //回复背景
    UIImage* image = IMAGENAMED(@"message_reply");
    image  =[image stretchableImageWithLeftCapWidth:image.size.width/2+10 topCapHeight:20];
    imgView=[[UIImageView alloc]initWithImage:image];
    [_viewComment addSubview:imgView];
    
    imgView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(-10, 0, 0, 0));
    
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.bounces=NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollEnabled =NO;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_viewComment addSubview:self.tableView];
    
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UIView* priseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.commentHeaderViewHeight)];
    UILabel* label = [[UILabel alloc]initWithFrame:priseView.frame];
    label.numberOfLines=0;
    label.lineBreakMode= NSLineBreakByClipping;
    label.textColor=ColorCompanyTheme;
    label.font =[UIFont fontWithName:@"Arial" size:13];
    label.text = @"    徐力,徐力,徐力,徐力,徐力,徐力,徐力,徐力,徐力,徐力,徐力,徐力,徐力,徐力,徐力,徐力";
    [priseView addSubview:label];
    
    label.sd_layout
    .autoHeightRatio(0)
    .spaceToSuperView(UIEdgeInsetsMake(0, 0,0, 0));
    
    UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 10, 10)];
    imgview.image = IMAGENAMED(@"gossip_like_normal");
    [priseView addSubview:imgview];
    
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, priseView.frame.size.height-1, priseView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [priseView addSubview:lineView];
    
    lineView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(HEIGHT(priseView)-1, 0, 0, 0));
    
//  priseView.backgroundColor = ColorChicken;
    [self.tableView setTableHeaderView:priseView];
    
    [self setupAutoHeightWithBottomView:_viewComment bottomMargin:15];
    
}


-(void)layout
{
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin + 5)
    .widthIs(40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topEqualToView(_iconView)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, margin)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    _shareView.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel,10)
    .rightSpaceToView(contentView, margin)
    .heightIs(50);
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_shareView, margin)
    .heightIs(15)
    .autoHeightRatio(0);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _btnDelete.sd_layout
    .leftSpaceToView(_timeLabel,5)
    .topSpaceToView(_timeLabel,-7)
    .widthIs(30)
    .autoHeightRatio(0);
    
    _btnComment.sd_layout
    .rightEqualToView(_contentLabel)
    .topSpaceToView(_timeLabel,-10)
    .widthIs(30)
    .autoHeightRatio(0.5);
    
    _btnPrise.sd_layout
    .rightSpaceToView(_btnComment,10)
    .topEqualToView(_btnComment)
    .widthIs(30)
    .autoHeightRatio(0.5);
    
    float width = WIDTH(self.contentView)-70;
    _viewComment.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(contentView,10)
    .topSpaceToView(_timeLabel,10)
    .heightIs(self.commentViewHeight)
    .widthIs(width);
}

- (void)setModel:(Demo9Model *)model
{
    _model = model;
    
    [self setup];
    
    _iconView.image = [UIImage imageNamed:model.iconName];
    _nameLable.text = model.name;
    _contentLabel.text = model.content;
    _timeLabel.text = @"1分钟前";
    [_btnDelete setTitle:@"全文" forState:UIControlStateNormal];
}


#pragma UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 0;
}

#pragma UITableViewDelegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* Identifier =@"CommentTableViewCell";
    ReplyTableViewCell* tableViewCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!tableViewCell) {
        tableViewCell = [[ReplyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        tableViewCell.backgroundColor = [UIColor clearColor];
    }
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    CGFloat h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
}


- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width
{
    
    if (!self.tableView.cellAutoHeightManager) {
        self.tableView.cellAutoHeightManager = [[SDCellAutoHeightManager alloc] init];
    }
    if (self.tableView.cellAutoHeightManager.contentViewWidth != width) {
        self.tableView.cellAutoHeightManager.contentViewWidth = width;
        [self.tableView.cellAutoHeightManager clearHeightCache];
    }
    UITableViewCell *cell = [self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:indexPath];
    self.tableView.cellAutoHeightManager.modelCell = cell;
    if (cell.contentView.width != width) {
        cell.contentView.width = width;
    }
    return [[self.tableView cellAutoHeightManager] cellHeightForIndexPath:indexPath model:nil keyPath:nil];
}

@end
