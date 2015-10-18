//
//  ActionHeader.m
//  Cycle
//
//  Created by air on 15/10/14.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "ActionHeader.h"
#import "GlobalDefine.h"
#import "UConstants.h"
@implementation ActionHeader
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        }
    return self;
}

-(void)btnAction:(UIButton*)sender
{
    NSInteger index = sender.tag;
    NSString* className =@"CyclePriseTableViewCell";
    switch (index) {
        case 1:
            className = @"CycleShareTableViewCell";
            break;
        case 2:
            className = @"CycleShareTableViewCell";
            break;
        case 3:
            className = @"CyclePriseTableViewCell";
            break;
        default:
            className = @"CyclePriseTableViewCell";
            break;
    }
    if ([self.delegate respondsToSelector:@selector(actionHeader:selectedIndex:className:)]) {
        [_delegate actionHeader:self selectedIndex:index className:className];
    }
}

-(void)setDic:(NSDictionary *)dic
{
    self->_dic  = dic;
    if (self.dic) {
        
        //头像
        headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self addSubview:headerImgView];
        
        //头像
        NSURL* url = [NSURL URLWithString:[dic valueForKey:@"photo"]];
        [headerImgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember")];
        
        
        //名称
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(headerImgView)+10, Y(headerImgView), 50, 21)];
        nameLabel.font = SYSTEMFONT(14);
        nameLabel.textColor = [UIColor blueColor];
        [self addSubview:nameLabel];
        
        //姓名
        nameLabel.text = [dic valueForKey:@"name"];
        
        companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(nameLabel)+5, Y(nameLabel), 200, HEIGHT(nameLabel))];
        companyLabel.textColor = FONT_COLOR_GRAY;
        companyLabel.font = FONT(@"Arial", 14);
        [self addSubview:companyLabel];
        
        companyLabel.text = [[dic valueForKey:@"position"] objectAtIndex:0];
        
        
        industoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel), POS_Y(nameLabel)+5, WIDTH(nameLabel)+WIDTH(companyLabel), HEIGHT(nameLabel))];
        industoryLabel.font = FONT(@"Arial", 14);
        industoryLabel.textColor = FONT_COLOR_GRAY;
        [self addSubview:industoryLabel];
        
         industoryLabel.text = [dic valueForKey:@"city"];
        
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel), POS_Y(industoryLabel)+10, WIDTH(self)-70, 50)];
        contentLabel.textColor = FONT_COLOR_BLACK;
        contentLabel.font = FONT(@"Arial", 14);
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:contentLabel];
        
        //内容
        contentLabel.text = [dic valueForKey:@"content"];
        
        imgContentView = [[UIView alloc]initWithFrame:CGRectMake(X(nameLabel), POS_Y(contentLabel), WIDTH(contentLabel), 10)];
        
        //点赞，分享,评论
        //评论
        criticalButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)-70, POS_Y(contentLabel)+10, 50, 25)];
        [criticalButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [criticalButton.titleLabel setFont:FONT(@"Arial", 10)];
        [criticalButton setImage:IMAGENAMED(@"gossip_comment") forState:UIControlStateNormal];
        [self addSubview:criticalButton];
        
        //分享
        shareButton = [[UIButton alloc]initWithFrame:CGRectMake(X(criticalButton)-50, Y(criticalButton), WIDTH(criticalButton), HEIGHT(criticalButton))];
        [shareButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [shareButton setTitle:@"转发" forState:UIControlStateNormal];
        [shareButton.titleLabel setFont:FONT(@"Arial", 10)];
        [shareButton setImage:IMAGENAMED(@"gossip_share") forState:UIControlStateNormal];
        [self addSubview:shareButton];
        
        //点赞
        priseButton = [[UIButton alloc]initWithFrame:CGRectMake(X(shareButton)-50, Y(shareButton), WIDTH(shareButton), HEIGHT(shareButton))];
        [priseButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [priseButton.titleLabel setFont:FONT(@"Arial", 10)];
        [priseButton setImage:IMAGENAMED(@"gossip_like_normal") forState:UIControlStateNormal];
        [self addSubview:priseButton];
        
        
        //底部
        UIImageView* lineImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(priseButton)+10, WIDTH(self), 1)];
        lineImageView.backgroundColor = FONT_COLOR_GRAY;
        [self addSubview:lineImageView];
        
        
        //点赞，分享,评论
        //点赞
        priseListButton = [[UIButton alloc]initWithFrame:CGRectMake(0, POS_Y(lineImageView), WIDTH(self)/3, HEIGHT(self)-POS_Y(lineImageView)-2)];
        priseListButton.tag =1;
        [priseListButton setTitleColor:FONT_COLOR_BLACK forState:UIControlStateNormal];
        [priseListButton.titleLabel setFont:FONT(@"Arial", 10)];
        [priseListButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:priseListButton];
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(priseListButton), Y(priseListButton)+10, 1, HEIGHT(priseListButton)-20)];
        imgView.backgroundColor = lineImageView.backgroundColor;
        [self addSubview:imgView];
        
        //分享
        shareListButton = [[UIButton alloc]initWithFrame:CGRectMake(POS_X(priseListButton), Y(priseListButton), WIDTH(priseListButton), HEIGHT(priseListButton))];
        shareListButton.tag =2;
        [shareListButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [shareListButton setTitle:@"扩散 8" forState:UIControlStateNormal];
        [shareListButton.titleLabel setFont:FONT(@"Arial", 10)];
        [shareListButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareListButton];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(shareListButton), Y(shareListButton)+10, 1, HEIGHT(shareListButton)-20)];
        imgView.backgroundColor = lineImageView.backgroundColor;
        [self addSubview:imgView];
        //评论
        criticalListButton = [[UIButton alloc]initWithFrame:CGRectMake(POS_X(shareListButton), Y(shareListButton), WIDTH(priseListButton), HEIGHT(priseListButton))];
        criticalListButton.tag =3;
        [criticalListButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [criticalListButton setTitle:@"评论 46" forState:UIControlStateNormal];
        [criticalListButton.titleLabel setFont:FONT(@"Arial", 10)];
        [criticalListButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:criticalListButton];
        
        NSMutableArray* dataArray = [self.dic valueForKey:@"likers"];
        [priseButton setTitle:[NSString stringWithFormat:@"%ld",dataArray.count] forState:UIControlStateNormal];
        [priseListButton setTitle:[NSString stringWithFormat:@"赞  %ld",dataArray.count] forState:UIControlStateNormal];
        dataArray = [self.dic valueForKey:@"comment"];
        [criticalButton setTitle:[NSString stringWithFormat:@"%ld",dataArray.count] forState:UIControlStateNormal];
        [criticalListButton setTitle:[NSString stringWithFormat:@"评论  %ld",dataArray.count] forState:UIControlStateNormal];
        lineImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT(self), WIDTH(self), 1)];
        lineImageView.backgroundColor = FONT_COLOR_GRAY;
        [self addSubview:lineImageView];

    }
}
@end
