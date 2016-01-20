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
    UIView* _viewComment;
    
    //回复背景
    UIImageView *messageBackView;
    
    HttpUtils* httpUtils;
    
    NSIndexPath* currentSelectedCellIndex;
    
    int currentTag;
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
    
    _viewComment = [[UIView alloc]init];
    _viewComment.layer.cornerRadius=3;
    
    //回复背景
    UIImage* image = IMAGENAMED(@"message_reply");
    image  =[image stretchableImageWithLeftCapWidth:image.size.width/2+10 topCapHeight:20];
    messageBackView=[[UIImageView alloc]initWithImage:image];
    [_viewComment addSubview:messageBackView];
    
    
    NSArray *views = @[_iconView, _nameLable,_infoLable, _contentLabel, _picContainerView, _timeLabel,_btnDelete,_btnPrise,_btnComment,_viewComment];
    
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    
    
    //
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
    .topSpaceToView(_timeLabel,-10)
    .widthIs(30)
    .autoHeightRatio(0.5);
    
    _btnPrise.sd_layout
    .rightSpaceToView(_btnComment,10)
    .topEqualToView(_btnComment)
    .widthIs(30)
    .autoHeightRatio(0.5);
    

    if (model.commentViewHeight!=0.0 || model.commentHeaderViewHeight!=0.0) {
        float width = WIDTH(self.contentView)-70;
        _viewComment.sd_layout
        .leftEqualToView(_contentLabel)
        .rightSpaceToView(contentView,10)
        .topSpaceToView(_timeLabel,10)
        .heightIs(model.commentViewHeight+model.commentHeaderViewHeight)
        .widthIs(width);
        
        messageBackView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(-10, 0, 0, 0));
    }else{
        float width = WIDTH(self.contentView)-70;
        _viewComment.sd_layout
        .leftEqualToView(_contentLabel)
        .rightSpaceToView(contentView,10)
        .topSpaceToView(_timeLabel,10)
        .heightIs(0)
        .widthIs(width);
        
        messageBackView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
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
    
    
    if (model.likersArray && model.likersArray.count>0) {
        
        //适配评论区域
        UIView* priseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, model.commentHeaderViewHeight)];
        UILabel* label = [[UILabel alloc]initWithFrame:priseView.frame];
        label.numberOfLines=0;
        label.lineBreakMode= NSLineBreakByClipping;
        label.textColor=ColorCompanyTheme;
        label.font =[UIFont fontWithName:@"Arial" size:13];
        
        [priseView addSubview:label];
        
        
        label.sd_layout
        .autoHeightRatio(0)
        .spaceToSuperView(UIEdgeInsetsMake(0, 0,0, 0));
        
        
        NSDictionary* dic;
        NSString* str=@"    ";
        for (int i = 0; i<model.likersArray.count; i++) {
            dic = model.likersArray[i];
            if (i!=model.likersArray.count-1) {
                str = [str stringByAppendingFormat:@"%@,",[dic valueForKey:@"name"]];
            }else{
                str = [str stringByAppendingFormat:@"%@",[dic valueForKey:@"name"]];
            }
        }
        label.text = str;
        
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, 10, 10)];
        imgview.image = IMAGENAMED(@"gossip_like_normal");
        [priseView addSubview:imgview];
        
        UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, priseView.frame.size.height-1, priseView.frame.size.width, 1)];
        lineView.backgroundColor = [UIColor whiteColor];
        [priseView addSubview:lineView];
        
        lineView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(HEIGHT(priseView)-1, 0, 0, 0));
        
        
        [self.tableView setTableHeaderView:priseView];
    }
    
    if (model.commentArray) {
        self.dataArray = model.commentArray;
        
        float height=0;
        for (int i=0; i<self.dataArray.count; i++) {
//            NSDictionary* dic = self.dataArray[i];
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            float width = self.tableView.frame.size.width-40;
            CGFloat h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:width];
            height+=h;
//            NSLog(@"高度:%f-->%@",height,[dic valueForKey:@"content"]);
            
        }
//        NSLog(@"高度:%f-->%f",model.commentViewHeight,height);
    }
    
//    [_viewComment setupAutoHeightWithBottomView:self.tableView bottomMargin:2]
    [self setupAutoHeightWithBottomView:_viewComment bottomMargin:10];
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
            NSDictionary* tempDic =self.dataArray[currentSelectedCellIndex.row];
            if ([self.dataArray containsObject:tempDic]) {
                NSMutableArray* array  =[NSMutableArray arrayWithArray:self.dataArray];
                [array removeObject:tempDic];
                self.dataArray = array;
                self.model.commentArray = self.dataArray;
                if ([_delegate respondsToSelector:@selector(weiboTableViewCell:refresh:)]) {
                    [_delegate weiboTableViewCell:self refresh:YES];
                }
            }
        }
    }
}



@end
