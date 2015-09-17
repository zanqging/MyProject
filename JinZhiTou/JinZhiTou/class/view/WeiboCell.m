//
//  WeiboCell.m
//  wq
//
//  Created by weqia on 13-8-28.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "WeiboCell.h"
#import "NSStrUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>



@implementation ReplyCell
@synthesize label;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        self.headerImgView.image = IMAGENAMED(@"coremember");
        self.headerImgView.backgroundColor = BlackColor;
        self.headerImgView.layer.cornerRadius = 15;
        self.headerImgView.layer.masksToBounds = YES;
        [self addSubview:self.headerImgView];
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.headerImgView)+5, Y(self.headerImgView), 100, HEIGHT(self.headerImgView))];
        self.nameLabel.text = @"马云";
        [self addSubview:self.nameLabel];
    
        self.btnReply = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)-130, Y(self.nameLabel), 60, 20)];
        [self.btnReply.layer setBorderWidth:1];
        [self.btnReply.layer setCornerRadius:2];
        [self.btnReply.layer setBorderColor:ColorTheme.CGColor];
        [self.btnReply addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnReply setTitleColor:ColorTheme forState:UIControlStateNormal];
        [self.btnReply setTitle:@"回复" forState:UIControlStateNormal];
        [self addSubview:self.btnReply];
        
        self.label = [[HBCoreLabel alloc]initWithFrame:CGRectMake(20, POS_Y(self.headerImgView)+15, WIDTH(self)-50, 40)];
        [self addSubview:self.label];
    }
    return self;
}

-(void)prepareForReuse
{
    self.label.match=nil;
}

- (void)layoutPrepar
{
    self.btnReply.layer.cornerRadius = 10;
    self.btnReply.layer.borderColor = [[UIColor redColor] CGColor];
    self.btnReply.layer.borderWidth = 1;
}
- (IBAction)replyAction:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showKeyboard" object:nil];
}
@end


@implementation WeiboCell

@synthesize controller;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.logo = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
        self.logo.image = IMAGENAMED(@"coremember");
        self.logo.backgroundColor = BlackColor;
        self.logo.layer.cornerRadius = 20;
        self.logo.layer.masksToBounds = YES;
        [self addSubview:self.logo];
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.logo)+5, Y(self.logo), 100, HEIGHT(self.logo))];
        self.title.text = @"刘路";
        self.title.font  = SYSTEMFONT(14);
        [self addSubview:self.title];
        
        self.authenImgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.title), Y(self.title)+15, 15, 15)];
        self.authenImgView.contentMode  =UIViewContentModeScaleAspectFill;
        self.authenImgView.image = IMAGENAMED(@"zhuanjia");
        [self addSubview:self.authenImgView];
        
        self.btnReply = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)-80, Y(self.authenImgView), 60, 20)];
        [self.btnReply.layer setBorderWidth:1];
        [self.btnReply.layer setCornerRadius:2];
        [self.btnReply.layer setBorderColor:ColorTheme.CGColor];
        [self.btnReply addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnReply setTitleColor:ColorTheme forState:UIControlStateNormal];
        [self.btnReply setTitle:@"回复" forState:UIControlStateNormal];
        [self addSubview:self.btnReply];
        
        self.content = [[HBCoreLabel alloc]initWithFrame:CGRectMake(X(self.title)+10, POS_Y(self.title)+10, WIDTH(self)-POS_X(self.title)-20, 40)];
        [self addSubview:self.content];
        
        self.replyContent = [[UIView alloc]initWithFrame:CGRectMake(X(self.content)-30, POS_Y(self.content)+10, WIDTH(self.content)-70, 100)];
        [self addSubview:self.replyContent];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, WIDTH(self.replyContent)-20, 20)];
        self.time.font = SYSTEMFONT(14);
        self.time.textColor = [UIColor blueColor];
        
    }
    return self;
}
- (IBAction)doAction:(id)sender {
     NSLog(@"回复当前文章!");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showKeyboard" object:nil];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self){
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma -mark 私有方法

-(void) prepare
{
    [super prepareForReuse];
//    _time.text=@"";
//    _title.text=@"";
    UIView * view=[self.contentView viewWithTag:191];
    if(view){
        [view removeFromSuperview];
    }
    view=[self.contentView viewWithTag:192];
    if(view){
        [view removeFromSuperview];
    }
    linesLimit=NO;
    
    self.btnReply.layer.cornerRadius = 10;
    self.btnReply.layer.borderColor = [[UIColor redColor] CGColor];
    self.btnReply.layer.borderWidth = 1;
}

+(float) heightForReply:(NSArray*)replys
{
    float height=6;
    for(WeiboReplyData * data in replys){
        height+=data.height+80;
    }
    return height;
}


#pragma -mark 接口方法
-(void)loadReply
{
    _replys=_weibo.replys;
    [self.tableReply reloadData];
}

-(void)setCellContent:(WeiboData *)weibo
{
    if (weibo.replys) {
        [self.replyContent addSubview:self.time];
        
        self.back  = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(self.time), WIDTH(self.replyContent), HEIGHT(self.replyContent)-POS_Y(self.time))];
        self.back.contentMode = UIViewContentModeScaleToFill;
        UIImage* img = IMAGENAMED(@"AlbumTriangleB");
        // 重新赋值
        CGFloat top = 10; // 顶端盖高度
        CGFloat bottom = 20 ; // 底端盖高度
        CGFloat left = 50; // 左端盖宽度
        CGFloat right = 50; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        img = [img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.back.image = img;
        [self.replyContent addSubview:self.back];
        
        self.tableReply = [[UITableView alloc]initWithFrame:CGRectMake(0, Y(self.back), WIDTH(self.back), HEIGHT(self.back))];
        self.tableReply.delegate  =self;
        self.tableReply.dataSource = self;
        self.tableReply.backgroundColor = ClearColor;
        self.tableReply.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.replyContent addSubview:self.tableReply];
    }
    
    weibo.willDisplay=YES;
    if(weibo.msgId.intValue==_weibo.msgId.intValue&&weibo.local==_weibo.local&&linesLimit==weibo.linesLimit&&[_weibo.replys count]==[weibo.replys count])
        return;
    [self prepare];
    replyCount=[weibo.replys count];
    linesLimit=weibo.linesLimit;

//    self.mLogo.layer.cornerRadius=3;
//    self.mLogo.clipsToBounds=YES;
    self.mLogo.layer.cornerRadius = self.mLogo.frame.size.width/2;
    self.mLogo.layer.masksToBounds =YES;
    self.mLogo.image=nil;
    self.mLogo.backgroundColor=[UIColor redColor];
    [self.content registerCopyAction];
    _weibo=weibo;
    self.content.linesLimit=_weibo.linesLimit;
    __weak HBCoreLabel * wcontent=self.content;
    MatchParser* match=[_weibo getMatch:^(MatchParser *parser,id data) {
        if (wcontent) {
            WeiboData * weibo=(WeiboData*)data;
            if (weibo.willDisplay) {
                dispatch_async(dispatch_get_main_queue(), ^{
                   wcontent.match=parser;
                });
            }
        }
    } data:weibo];
    self.content.match=match;
//    ContactData *contact = [[WeqiaAppDelegate App].dbUtil searchSingle:[ContactData class]where:[NSString stringWithFormat:@"mid='%@'",weibo.mid] orderBy:nil];
//    if (contact != nil) {
//        self.title.text=contact.mName;
//        if([NSStrUtil notEmptyOrNull:contact.mLogo]){
//            [self.mLogo setImageWithURL:[NSURL URLWithString:contact.mLogo] placeholderImage:[UIImage imageNamed:@"people.png"]];
//        }else{
//            self.mLogo.image=[UIImage imageNamed:@"people.png"];
//        }
//    }else{
//        self.mLogo.image=[UIImage imageNamed:@"people.png"];
//    }
    CGRect frame= self.time.frame;
    frame.size.width = 150;
    self.time.frame = frame;
    self.time.text=@"1小时前";
    
    self.tableReply.scrollEnabled=NO;
    float offset=0.0f;
    if(weibo.numberOfLineLimit<weibo.numberOfLinesTotal){
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:self.title.textColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:button];
        [button addTarget:self action:@selector(limitAction) forControlEvents:UIControlEventTouchUpInside];
        if(weibo.linesLimit){
            [button setTitle:@"全文" forState:UIControlStateNormal];
            _content.frame=CGRectMake(40, 60, _weibo.miniWidth,_weibo.heightOflimit);
            offset=25;
        }else{
            [button setTitle:@"收起" forState:UIControlStateNormal];
            _content.frame=CGRectMake(40, 60, _weibo.miniWidth,_weibo.height);
            offset=25;
        }
        button.frame=CGRectMake(20, self.content.frame.origin.y+self.content.frame.size.height+6, 50, 20);
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        button.tag=191;
    }else{
        _content.frame=CGRectMake(40, 60, _weibo.miniWidth,_weibo.height);
    }
    //_content.backgroundColor=[UIColor blackColor];
    _weibo.imageHeight = 0;
//    if(!weibo.local){
//        if(weibo.isGetReply){
//            if ([weibo.replys isKindOfClass:[NSArray class]]&&[weibo.replys count]>0) {
//                [self.tableReply reloadData];
//                [self.back setHidden:NO];
//            } else {
//                [self.back setHidden:YES];
//            }
//        }else{
//            [self.back setHidden:YES];
//            [weibo getWeiboReplysByType:1];
//        }
//    }else{
//        [self.back setHidden:YES];
//    }
    [self.back setHidden:NO];
    float height=_weibo.replyHeight;
    
    frame=self.replyContent.frame;
    frame.origin.y=self.content.frame.origin.y+self.content.frame.size.height+5;
    frame.size.height=_weibo.replyHeight+30;
    self.replyContent.frame=frame;
    
    frame=_back.frame;
    frame.size.height=height;
    frame.origin.y=28;
    _back.frame=frame;
    
    frame=_tableReply.frame;
    frame.size.height=height-6;
    frame.origin.y=35;
    _tableReply.frame=frame;
    if(weibo.local){
        [self.btnReply setEnabled:NO];
    }else{
        [self.btnReply setEnabled:YES];
    }
}
+(float)getHeightByContent:(WeiboData*)data
{
    float height;
    if(data.shouldExtend){
        if(data.linesLimit){
            height=data.heightOflimit+25;
        }else{
            height=data.height+25;
        }
    }else{
        height=data.height;
    }
    if ([data.replys isKindOfClass:[NSArray class]]&&[data.replys count]>0&&!data.local) {
        return 120.0+data.imageHeight+height+6+data.replyHeight;
    } else  {
        return 120.0+data.imageHeight+height;
    }
}



#pragma -mark 事件响应方法

-(void)limitAction
{
    if(_weibo.linesLimit){
        _weibo.linesLimit=NO;
        [controller.tableView reloadData];
    }else{
        _weibo.linesLimit=YES;
        [controller.tableView reloadData];
        [controller.tableView scrollRectToVisible:CGRectMake(0, self.frame.origin.y, 320, controller.tableView.frame.size.height) animated:NO];
    }
    
}

-(IBAction)deleteAction:(id)sender
{
    
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"删除分享"
                                                  message:nil
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确认", nil];
    alert.tag=222;
    [alert show];
}


-(void)delAndReplyAction
{
    
}


#pragma -mark  tableReply delegate
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboReplyData * data=[_weibo.replys objectAtIndex:indexPath.row];
    return data.height+80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_weibo.replys count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuse=@"WeiboReplyCell";
    ReplyCell * cell=[tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        cell = [[ReplyCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.replyContent), height)];
    }
    if(indexPath.row>=_weibo.replys.count)
        return cell;
    WeiboReplyData * data=[_weibo.replys objectAtIndex:indexPath.row];
    __weak HBCoreLabel * wlabel=cell.label;
    MatchParser * match=[data getMatch:^(MatchParser *parser, id data) {
        if (wlabel) {
            WeiboData * weibo=(WeiboData*)data;
            if (weibo.willDisplay) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    wlabel.match=parser;
                });
            }
        }
    } data:_weibo];
    [cell layoutPrepar];
    
    cell.label.match=match;
    cell.label.userInteractionEnabled=YES;
    CGRect frame=cell.label.frame;
    cell.backgroundColor=[UIColor clearColor];
    frame.size.height=data.height;
    cell.label.frame=frame;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    //[cell prepareForReuse];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath=indexPath;
    _reply=[_weibo.replys objectAtIndex:indexPath.row];
    [self delAndReplyAction];
}


@end
