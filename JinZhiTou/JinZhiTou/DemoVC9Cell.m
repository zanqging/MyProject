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

#import "DemoVC9Cell.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "Demo9Model.h"
#import "ShareContentView.h"
#import "ReplyTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWeiXinPhotoContainerView.h"


@implementation DemoVC9Cell
{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_infoLable;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    
    //分享内容
    ShareContentView* _shareView;
    UILabel *_timeLabel;
    
    //删除按钮
    UIButton *_btnDelete;
    //点赞
    UIButton *_btnPrise;
    //评论
    UIButton *_btnComment;
    
    //点赞、评论列表
//    UIView* _viewComment;
    
    //回复背景
//    UIImageView *messageBackView;
    
    HttpUtils* httpUtils;
    
    NSIndexPath* currentSelectedCellIndex;
    
    int currentTag;
    
    //扩展
    CycleCommentView * _cycleCommentView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier commentViewHeight:(CGFloat)height commentHeaderViewHeight:(CGFloat)headerHeight
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
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
    _iconView = [UIImageView new];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:14];
    _nameLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _infoLable = [UILabel new];
    _infoLable.font = [UIFont systemFontOfSize:14];
    _infoLable.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    _contentLabel = [UILabel new];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _shareView = [[ShareContentView alloc]init];
    
    /**
     *  测试
     */
    _cycleCommentView = [CycleCommentView new];
    /**
     *  测试
     */
    
    //加入监听事件
    _shareView.userInteractionEnabled = YES;
    [_shareView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareContent:)]];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
    
    _btnDelete = [[UIButton alloc]init];
    [_btnDelete setTitle:@"删除" forState:UIControlStateNormal];
    [_btnDelete.titleLabel setFont:[UIFont fontWithName:@"Arial" size:11]];
    [_btnDelete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnDelete setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    _btnPrise = [[UIButton alloc]init];
    [_btnPrise.titleLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
    [_btnPrise setImage:IMAGENAMED(@"gossip_like_normal") forState:UIControlStateNormal];
    [_btnPrise setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnPrise addTarget:self action:@selector(priseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _btnComment = [[UIButton alloc]init];
    [_btnComment setImage:IMAGENAMED(@"gossip_comment") forState:UIControlStateNormal];
    [_btnComment.titleLabel setFont:[UIFont fontWithName:@"Arial" size:13]];
    [_btnComment setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_btnComment addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _cycleCommentView.delegate = self;
    
    NSArray *views = @[_iconView, _nameLable,_infoLable, _contentLabel, _picContainerView, _timeLabel,_btnDelete,_btnPrise,_btnComment,_cycleCommentView];
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
}


- (void)setModel:(Demo9Model *)model
{
    _model = model;
    //自动布局
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
    
    _infoLable.sd_layout
    .leftSpaceToView(_iconView, margin)
    .topSpaceToView(_nameLable,0)
    .autoHeightRatio(0);
    [_infoLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_infoLable)
    .topSpaceToView(_infoLable, 0)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
    UIView* view = _picContainerView;
    if (model.shareDic) {
        [self.contentView addSubview:_shareView];
        view = _shareView;
        _shareView.sd_layout
        .leftEqualToView(_contentLabel)
        .topSpaceToView(_contentLabel,10)
        .rightSpaceToView(contentView, margin)
        .heightIs(50);
    }else{
        [_shareView removeFromSuperview];
    }
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel);
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(view, margin)
    .heightIs(12)
    .autoHeightRatio(0);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    _btnDelete.sd_layout
    .leftSpaceToView(_timeLabel,5)
    .topSpaceToView(_timeLabel,-15)
    .widthIs(30)
    .heightIs(20);
    
    _btnComment.sd_layout
    .rightEqualToView(_contentLabel)
    .topSpaceToView(_timeLabel,-20)
    .widthIs(40)
    .autoHeightRatio(0.8);
    
    _btnPrise.sd_layout
    .rightSpaceToView(_btnComment,10)
    .topEqualToView(_btnComment)
    .widthIs(40)
    .autoHeightRatio(0.8);
    
    _cycleCommentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightEqualToView(_contentLabel)
    .topSpaceToView(_timeLabel, 10);
    
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.iconName] placeholderImage:IMAGENAMED(@"coremember")];
    if (model.name) {
        _nameLable.text = model.name;
    }
    
    if (model.content) {
        _contentLabel.text = model.content;
    }
    _picContainerView.picPathStringsArray = model.picNamesArray;
    
    NSString* str=@"";
    if ([TDUtil isValidString:model.address]) {
        str = [str stringByAppendingString:model.address];
    }
    if ([TDUtil isValidString:model.position]) {
        str = [str stringByAppendingFormat:@" | %@",model.position];
    }
    
    if ([TDUtil isValidString:str]) {
        _infoLable.text = str;
    }
    
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNamesArray.count) {
        picContainerTopMargin = 10;
    }
    
    //分享
    if (model.shareDic) {
        _shareView.dic = model.shareDic;
    }
    _picContainerView.sd_layout.topSpaceToView(_contentLabel, picContainerTopMargin);
    _timeLabel.text = model.dateTime;
    
    //处理删除按钮
    if (!model.flag) {
        [_btnDelete setAlpha:0];
        [_btnDelete setEnabled:NO];
    }else{
        [_btnDelete setAlpha:1];
        [_btnDelete setEnabled:YES];
    }
    
    
    _cycleCommentView.likersDataArray = self.model.likersArray;
    _cycleCommentView.commentDataArray = self.model.commentArray;
    if (!self.model.likersArray || self.model.likersArray.count==0) {
        if (self.model.commentArray && self.model.commentArray.count>0) {
            [self setupAutoHeightWithBottomView:_cycleCommentView bottomMargin:-20];
        }else{
            [self setupAutoHeightWithBottomView:_timeLabel bottomMargin:20];
        }
    }else{
        [self setupAutoHeightWithBottomView:_cycleCommentView bottomMargin:10];
    }

}

/**
 *  点赞
 *
 *  @param sender 触发实例
 */
-(void)priseAction:(id)sender
{
    if (!httpUtils) {
        httpUtils = [[HttpUtils alloc]init];
    }
    NSInteger id = self.model.id;
    
    NSString* serverUrl = [CYCLE_CONTENT_PRISE stringByAppendingFormat:@"%ld/%d/",id,self.model.isLike];
    [httpUtils getDataFromAPIWithOps:serverUrl  type:0 delegate:self sel:@selector(requestPriseFinished:) method:@"GET"];
}


/**
 *  评论
 *
 *  @param sender 触发实例
 */
-(void)commentAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(weiboTableViewCell:contentId:atId:isSelf:)]) {
        [_delegate weiboTableViewCell:self contentId:[NSString stringWithFormat:@"%ld",self.model.id] atId:nil isSelf:NO];
    }
}

/**
 *  分享新三板点击
 *
 *  @param sender 触发实例
 */
-(void)shareContent:(id)sender
{
    if ([_delegate respondsToSelector:@selector(weiboTableViewCell:didSelectedShareContentUrl:)]) {
        //分享链接
        NSURL * url = [NSURL URLWithString:[self.model.shareDic valueForKey:@"url"]];
        [_delegate weiboTableViewCell:self didSelectedShareContentUrl:url];
    }
}

-(void)deleteAction:(id)sender
{
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"金指投温馨提示" message:@"是否确认删除内容?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alertView show];
    
    //设置为删除内容
    currentTag = 1;
}
#pragma CycleCommentDelegate
-(void)cycleComment:(id)cycleComment contentId:(NSString *)contentId atId:(NSString *)atId isSelf:(BOOL)isSelf
{
    if ([_delegate respondsToSelector:@selector(weiboTableViewCell:contentId:atId:isSelf:)]) {
        [_delegate weiboTableViewCell:self contentId:[NSString stringWithFormat:@"%ld",self.model.id] atId:atId isSelf:NO];
    }
}

-(void)cycleComment:(id)cycleComment deleteId:(NSString *)deleteId
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alertView.tag  = [deleteId integerValue];
    alertView.delegate = self;
    [alertView show];
    currentTag = 0;
}

-(void)cycleComment:(id)cycleComment refresh:(BOOL)refresh data:(NSArray *)dataArray
{
    if (refresh) {
        self.model.commentArray = dataArray;
        if ([_delegate respondsToSelector:@selector(weiboTableViewCell:refresh:)]) {
            [_delegate weiboTableViewCell:self refresh:YES];
        }
    }
}
#pragma UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    NSDictionary* dic = self.dataArray[indexPath.row];
    tableViewCell.dic = dic;
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic =self.dataArray[indexPath.row];
    currentSelectedCellIndex = indexPath;
    if(![[dic valueForKey:@"flag"] boolValue]){
        if ([_delegate respondsToSelector:@selector(weiboTableViewCell:contentId:atId:isSelf:)]) {
            [_delegate weiboTableViewCell:self contentId:[NSString stringWithFormat:@"%ld",self.model.id] atId:[dic valueForKey:@"id"] isSelf:NO];
        }
    }else{
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alertView.tag  = [[dic valueForKey:@"id"] integerValue];
        alertView.delegate = self;
        [alertView show];
        currentTag = 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    float width = self.tableView.frame.size.width;
    CGFloat h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:width];
    NSLog(@"%ld-->%f",indexPath.row,h);
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

#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (currentTag==0) {
            if (!httpUtils) {
                httpUtils = [[HttpUtils alloc]init];
            }
            NSString* serverUrl = [CYCLE_CONTENT_REPLY_DELETE stringByAppendingFormat:@"%ld/",alertView.tag];
            [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestDeleteReplyFinished:)];
            NSMutableArray * array = [NSMutableArray arrayWithArray:self.model.commentArray];
            for (int i = 0;i<array.count;i++) {
                NSDictionary * dic = self.model.commentArray[i];
                if ([DICVFK(dic, @"id") integerValue] == alertView.tag) {
                    [array removeObjectAtIndex:i];
                    self.model.commentArray = array;
                    
                    if ([_delegate respondsToSelector:@selector(weiboTableViewCell:refresh:)]) {
                        [_delegate weiboTableViewCell:self refresh:YES];
                    }
                    
                    break;
                }
            }
            
            
        }else{
            if (!httpUtils) {
                httpUtils = [[HttpUtils alloc]init];
            }
            NSString* serverUrl = [CYCLE_CONTENT_DELETE stringByAppendingFormat:@"%ld/",self.model.id];
            [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestDeleteFinished:)];
            
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:deleteDic:)]) {
                [_delegate weiboTableViewCell:self deleteDic:self.model];
            }
        }
    }
}


#pragma 数据
-(void)setDataArray:(NSArray *)dataArray
{
    if (dataArray) {
        self->_dataArray = dataArray;
        [self.tableView reloadData];
    }
}

-(void)requestDeleteFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"code"];
        if ([status integerValue]==0) {
//            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:deleteDic:)]) {
//                [_delegate weiboTableViewCell:self deleteDic:self.model];
//            }
        }
    }
}


#pragma ASIHttpRequest
-(void)requestPriseFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"code"];
        if ([status integerValue]>=0) {
            BOOL flag = !self.model.isLike;
            NSString* flagStr = flag==true?@"True":@"False";
            self.model.isLike = [NSNumber numberWithBool:[flagStr boolValue]];
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:priseDic:msg:)]) {
                [_delegate weiboTableViewCell:self  priseDic:[dic valueForKey:@"data"] msg:[dic valueForKey:@"msg"]];
            }
        }
        
    }
}

-(void)requestDeleteReplyFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"code"];
        if ([status integerValue]==0) {
            
    
        }
    }
}



@end
