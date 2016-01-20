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
@implementation WeiboCell

@synthesize controller;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = BackColor;
        
        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), frame.size.height-10)];
        v.backgroundColor = WriteColor;
        
        self.logo = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
        self.logo.backgroundColor = BlackColor;
        self.logo.layer.cornerRadius = 20;
        self.logo.layer.masksToBounds = YES;
        [v addSubview:self.logo];
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.logo)+5, Y(self.logo), 100, 20)];
        self.title.font  = SYSTEMFONT(14);
        [v addSubview:self.title];
        
        self.authenImgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(self.title), Y(self.title)+15, 15, 15)];
        self.authenImgView.contentMode  =UIViewContentModeScaleAspectFill;
        [v addSubview:self.authenImgView];
        
        self.btnReply = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)-80, Y(self.authenImgView), 60, 20)];
        [self.btnReply.layer setBorderWidth:1];
        [self.btnReply.layer setCornerRadius:10];
        [self.btnReply.titleLabel setFont:SYSTEMFONT(14)];
        [self.btnReply.layer setBorderColor:BackColor.CGColor];
        [self.btnReply addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnReply setTitleColor:BACKGROUND_LIGHT_GRAY_COLOR forState:UIControlStateNormal];
        [self.btnReply setTitle:@"回复" forState:UIControlStateNormal];
        [v addSubview:self.btnReply];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.title), POS_Y(self.title),WIDTH(self)-X(self.title)-40, 80)];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = SYSTEMFONT(14);
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [v addSubview:self.contentLabel];
        
        self.time = [[UILabel alloc]initWithFrame:CGRectMake(X(self.contentLabel), 0, WIDTH(self.contentLabel), 20)];
        self.time.font = SYSTEMFONT(12);
        self.time.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
        [v addSubview:self.time];
        
        [self.contentView addSubview:v];
        
    }
    return self;
}

-(void)setContent:(NSString *)content
{
    self->_content = content;
    if (self.content) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        
        [paragraphStyle setLineSpacing:8.f];//调整行间距
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        
        self.contentLabel.attributedText = attributedString;//ios 6
        [self.contentLabel sizeToFit];
        
        [self.time setFrame:CGRectMake(X(self.time), POS_Y(self.contentLabel), WIDTH(self.time), HEIGHT(self.time))];
        [self setFrame:CGRectMake(0, 0, WIDTH(self), POS_Y(self.contentLabel)+50)];
    }
}

-(void)setTitleStr:(NSString *)titleStr
{
    self->_titleStr = titleStr;
    if (self.titleStr) {
        NSString * content = self.titleStr;
        if (self.atName) {
            content = [content stringByAppendingFormat:@"回复%@",self.atName];
        }
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        
        [paragraphStyle setLineSpacing:10.f];//调整行间距
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        [paragraphStyle setHeadIndent:-50];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [titleStr length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:AppColorTheme range:NSMakeRange(0, self.titleStr.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:AppColorTheme range:NSMakeRange(self.titleStr.length+2, self.atName.length)];
        
        self.title.attributedText = attributedString;//ios 6
        [self.title sizeToFit];
        
        [self.authenImgView setFrame:CGRectMake(POS_X(self.title)+15, Y(self.title), 15, 15)];
        [self.btnReply setFrame:CGRectMake(WIDTH(self)-80, Y(self.authenImgView), 60, 20)];
         [self.contentLabel setFrame:CGRectMake(X(self.title), POS_Y(self.title),WIDTH(self)-X(self.title)-40, 80)];
    }
    
}
- (IBAction)doAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(weiboCell:replyData:)]) {
        [_delegate weiboCell:self replyData:self.topicId];
    }
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

-(void)setIsInvestor:(BOOL)isInvestor
{
    self->_isInvestor = isInvestor;
    NSString* imgName;
    if (self.isInvestor) {
        imgName = @"zhuanjia";
    }else{
        imgName = nil;
    }
    if (imgName) {
        self.authenImgView.image = IMAGENAMED(imgName);
    }
    
}
@end
