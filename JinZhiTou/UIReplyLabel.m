//
//  UIReplyLabel.m
//  JinZhiTou
//
//  Created by air on 15/10/19.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "UIReplyLabel.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation UIReplyLabel
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.font = SYSTEMFONT(13);
        self.atLabel = [[UILabel alloc]init];
        self.atLabel.font = SYSTEMFONT(13);
        self.atNameLabel = [[UILabel alloc]init];
        self.atNameLabel.font = SYSTEMFONT(13);
        self.atSuffixLabel = [[UILabel alloc]init];
        self.atSuffixLabel.font = SYSTEMFONT(13);
        
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.font = SYSTEMFONT(13);
        
        [self addSubview:self.contentLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.atLabel];
        [self addSubview:self.atNameLabel];
        [self addSubview:self.atSuffixLabel];
        
    }
    return self;
}

-(void)setName:(NSString *)name
{
    [self.nameLabel setFrame:CGRectMake(20, 0, 10, 10)];
    [self.nameLabel setTextColor:[UIColor blueColor]];
    self->_name = name;
    [TDUtil setLabelMutableText:self.nameLabel content:self.name lineSpacing:5 headIndent:0];
}

-(void)setAtString:(NSString *)atString
{
    self->_atString = atString;
    [self.atLabel setFrame:CGRectMake(POS_X(self.nameLabel), 0, 10, 10)];
     [TDUtil setLabelMutableText:self.atLabel content:self.atString lineSpacing:5 headIndent:0];
}

-(void)setAtName:(NSString *)atName
{
    self->_atName = atName;
    [self.atNameLabel setTextColor:[UIColor blueColor]];
    [self.atNameLabel setFrame:CGRectMake(POS_X(self.atLabel), 0, 10, 10)];
     [TDUtil setLabelMutableText:self.atNameLabel content:self.atName lineSpacing:5 headIndent:0];
}

-(void)setSuffix:(NSString *)suffix
{
    self->_suffix = suffix;
    if (self.atString) {
        [self.atSuffixLabel setFrame:CGRectMake(POS_X(self.atNameLabel), 0, 10, HEIGHT(self.nameLabel))];
    }else{
        [self.atSuffixLabel setFrame:CGRectMake(POS_X(self.nameLabel), 0, 10, HEIGHT(self.nameLabel))];
    }
    self.atSuffixLabel.text =@"sdhfkjfhdkj";
    self.atSuffixLabel.textAlignment = NSTextAlignmentCenter;
     [TDUtil setLabelMutableText:self.atSuffixLabel content:self.suffix lineSpacing:0 headIndent:0];
}

-(void)setContent:(NSString *)content{
    self->_content = content;
    [self.contentLabel setFrame:CGRectMake(X(self.nameLabel), 0, WIDTH(self), HEIGHT(self.nameLabel))];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    NSInteger line = 0;
    if (content && [content length]>0 && [content length]<17) {
        [TDUtil setLabelMutableText:self.contentLabel content:self.content lineSpacing:0 headIndent:WIDTH(self.nameLabel)+WIDTH(self.atNameLabel)+WIDTH(self.atLabel)+WIDTH(self.atSuffixLabel)];
        line++;
    }else{
        [TDUtil setLabelMutableText:self.contentLabel content:self.content lineSpacing:5 headIndent:WIDTH(self.nameLabel)+WIDTH(self.atNameLabel)+WIDTH(self.atLabel)+WIDTH(self.atSuffixLabel)];
        line = [TDUtil convertToInt:content]/17+1;
    }
    [self.contentLabel setFrame:CGRectMake(X(self.nameLabel), 0, 200, line*12)];
}
@end