//
//  CycleCommentView.m
//  JinZhiTou
//
//  Created by air on 15/1/1.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "CycleCommentView.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "ReplyTableViewCell.h"
@implementation CycleCommentView
/**
 *  覆载 初始化init 方法
 *
 *  @return self 实例
 */
- (id)init
{
    if (self = [super init]) {
//        self.backgroundColor = [UIColor redColor];
        [self setup];
    }
    
    return self;
}

/**
 *  初始化设置
 */
- (void) setup
{
    //1.初始化控件
    _lineView = [UIView new];
    _labelPrise = [UILabel new];
    _tableView = [UITableView new];
    _bgImgView = [UIImageView new];
    _iconImgView = [UIImageView new];
    
    //2.添加到本视图
    [self addSubview:_bgImgView];
    [self addSubview:_labelPrise];
    [self addSubview:_lineView];
    [self addSubview:_tableView];
    [self addSubview:_iconImgView];
    
    //3.设置属性
    
    _labelPrise.numberOfLines = 0;
//    _labelPrise.text = @"    陈生珠,陈生珠,陈生珠,陈生珠,陈生珠,陈生珠,陈生珠,陈生珠,陈生珠,陈生珠";
    _labelPrise.font = SYSTEMFONT(14);
    _labelPrise.textColor = AppColorTheme;
    _labelPrise.backgroundColor = ClearColor;
//    _labelPrise.backgroundColor = PopuleColor;
    _labelPrise.lineBreakMode = NSLineBreakByWordWrapping;
    
    _lineView.backgroundColor = WriteColor;
    
    _bgImgView.backgroundColor = BackColor;
    
    _tableView.backgroundColor = ClearColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    //4.自适应布局
    
//    _labelPrise
    _labelPrise.sd_layout
    .topSpaceToView(self, 5)
    .leftSpaceToView(self, 5)
    .rightSpaceToView(self, 5)
    .autoHeightRatio(0);
    
    //_lineView
    _lineView.sd_layout
    .leftEqualToView(_labelPrise)
    .rightEqualToView(_labelPrise)
    .topSpaceToView(_labelPrise, 5)
    .heightIs(1);
    
    //_tableView;
    _tableView.sd_layout
//    .heightIs(100)
    .topSpaceToView(_lineView, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0);
    
    _bgImgView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    [self setupAutoHeightWithBottomView:_tableView bottomMargin:10];
}

#pragma UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.commentDataArray.count;
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
//    NSDictionary* dic = self.dataArray[indexPath.row];
//    NSMutableDictionary * dic = [NSMutableDictionary new];
//    SETDICVFK(dic, @"name", @"陈生珠");
//    SETDICVFK(dic, @"at_name", @"杨林东");
//    SETDICVFK(dic, @"content", @"这是一个比较简单的测试,这是一个比较复杂的测试,这是一个更加复杂的测试,这是一个比较简单的测试,这是一个比较复杂的测试,这是一个更加复杂的测试");
    tableViewCell.dic = self.commentDataArray[indexPath.row];
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCell.backgroundColor = ClearColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic =self.commentDataArray[indexPath.row];
    if(![[dic valueForKey:@"flag"] boolValue]){
        if ([_delegate respondsToSelector:@selector(cycleComment:contentId:atId:isSelf:)]) {
            [_delegate cycleComment:self contentId:DICVFK(dic, @"id") atId:[dic valueForKey:@"id"] isSelf:NO];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(cycleComment:deleteId:)]) {
            [_delegate cycleComment:self deleteId:DICVFK(dic, @"id")];
            
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    float width = self.tableView.frame.size.width;
    CGFloat h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:width];
    NSInteger row = indexPath.row;
    if (row == 0) {
        height = h;
    }else{
        height += h;
    }
    if (self.commentDataArray.count == 1) {
        height -= 1;
    }
    if (row == self.commentDataArray.count-1) {
        _tableView.height = height + 20;
        _tableView.contentSize = CGSizeMake(WIDTH(_tableView), height);
        
        if (!self.likersDataArray || self.likersDataArray.count == 0) {
            self.height  = tableView.height - 20;
        }
        
        [self setupAutoHeightWithBottomView:_tableView bottomMargin:10];
    }
    
    
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


-(void)setLikersDataArray:(NSArray *)likersDataArray
{
    self->_likersDataArray = likersDataArray;
    if (self.likersDataArray && self.likersDataArray.count>0) {
        NSString* str=@"    ";
        NSDictionary * dic;
        for (int i = 0; i<self.likersDataArray.count; i++) {
            dic = self.likersDataArray[i];
            if (i!=self.likersDataArray.count-1) {
                str = [str stringByAppendingFormat:@"%@,",[dic valueForKey:@"name"]];
            }else{
                str = [str stringByAppendingFormat:@"%@",[dic valueForKey:@"name"]];
            }
        }
        _labelPrise.text = str;
        
        if (![str isEqualToString:@"    "]) {
            _iconImgView.image = IMAGENAMED(@"comment");
            _iconImgView.sd_layout
            .widthIs(10)
            .heightIs(10)
            .leftSpaceToView(self, 10)
            .topSpaceToView(self, 10);
        }
        
    }else{
        _labelPrise.text = @"";
        _labelPrise.sd_layout
        .heightIs(0);
        
        _lineView.sd_layout
        .topSpaceToView(self, 0)
        .heightIs(0);
        
        _iconImgView.image = nil;
        _iconImgView.sd_layout
        .widthIs(0)
        .heightIs(0)
        .leftSpaceToView(self, 10)
        .topSpaceToView(self, 10);
        
        _tableView.sd_layout
        //    .heightIs(100)
        .topSpaceToView(self, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0);
    }
    
    [self setupAutoHeightWithBottomView:_tableView bottomMargin:10];
}

-(void)setCommentDataArray:(NSArray *)commentDataArray
{
    self->_commentDataArray = commentDataArray;
    if (!self.commentDataArray || self.commentDataArray.count<=0) {
        self.tableView.height = 0;
        _lineView.sd_layout
        .topSpaceToView(self, 0)
        .heightIs(0);
        
        if (self.likersDataArray && self.likersDataArray.count > 0) {
            [self setupAutoHeightWithBottomView:_labelPrise bottomMargin:10];
        }else{
            _bgImgView.backgroundColor = ClearColor;
        }
    }else{
        [self setupAutoHeightWithBottomView:_tableView bottomMargin:10];
    }
    
    [self.tableView reloadData];
    
    
    
}
@end
