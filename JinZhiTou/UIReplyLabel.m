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
    [self.nameLabel setFrame:CGRectMake(10, 0, 10, 13)];
    [self.nameLabel setTextColor:[UIColor colorWithRed:211.0f/255.0 green:161.0f/255.0 blue:36.0f/255.0 alpha:1]];
    self->_name = name;
    [TDUtil setLabelMutableText:self.nameLabel content:self.name lineSpacing:0 headIndent:0];
    self.nameLabel.text = @"";
}

-(void)setAtString:(NSString *)atString
{
    self->_atString = atString;
    [self.atLabel setFrame:CGRectMake(POS_X(self.nameLabel), 0, 10, 13)];
     [TDUtil setLabelMutableText:self.atLabel content:self.atString lineSpacing:0 headIndent:0];
    self.atLabel.text = @"";
}

-(void)setAtName:(NSString *)atName
{
    self->_atName = atName;
    [self.atNameLabel setTextColor:[UIColor colorWithRed:211.0f/255.0 green:161.0f/255.0 blue:36.0f/255.0 alpha:1]];
    [self.atNameLabel setFrame:CGRectMake(POS_X(self.atLabel), 0, 10, 13)];
     [TDUtil setLabelMutableText:self.atNameLabel content:self.atName lineSpacing:0 headIndent:0];
    self.atNameLabel.text = @"";
}

-(void)setSuffix:(NSString *)suffix
{
    self->_suffix = suffix;
    if (self.atName) {
        [self.atSuffixLabel setFrame:CGRectMake(POS_X(self.atNameLabel), 0, 10, HEIGHT(self.nameLabel))];
    }else{
        [self.atSuffixLabel setFrame:CGRectMake(POS_X(self.nameLabel), 0, 10, HEIGHT(self.nameLabel))];
    }
    self.atSuffixLabel.textAlignment = NSTextAlignmentCenter;
     [TDUtil setLabelMutableText:self.atSuffixLabel content:self.suffix lineSpacing:0 headIndent:0];
    self.atSuffixLabel.text =@"";
}

-(void)setContent:(NSString *)content{
    self->_content = content;
    [self.contentLabel setFrame:CGRectMake(X(self.nameLabel), Y(self.atSuffixLabel), WIDTH(self)-20, HEIGHT(self)-10)];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    if (content && [content length]>0 && [content length]<17) {
//        [TDUtil setLabelMutableText:self.contentLabel content:self.content lineSpacing:5 headIndent:WIDTH(self.nameLabel)+WIDTH(self.atNameLabel)+WIDTH(self.atLabel)+WIDTH(self.atSuffixLabel)];
//    }else{
//        [TDUtil setLabelMutableText:self.contentLabel content:self.content lineSpacing:5 headIndent:WIDTH(self.nameLabel)+WIDTH(self.atNameLabel)+WIDTH(self.atLabel)+WIDTH(self.atSuffixLabel)];
//    }
    
//    float indent = WIDTH(self.nameLabel)+WIDTH(self.atNameLabel)+WIDTH(self.atLabel)+WIDTH(self.atSuffixLabel);
//    if (self.atString) {
//        indent /=3;
//    }else{
//        indent /=8;
//    }
//    NSString* str=@" ";
//    for(int i= 0;i<indent;i++){
//        str=[str stringByAppendingString:@" "];
//    }
//    str = [str stringByAppendingString:content];
    
    //开始组装
    NSString* str = @"";
    if (self.name) {
        str =[str stringByAppendingString:self.name];
    }
    
    if ([TDUtil isValidString:self.atName] ) {
        str = [str stringByAppendingFormat:@"回复%@%@",self.atName,self.suffix];
    }else{
        str = [str stringByAppendingFormat:@"%@",self.suffix];
    }
    
    str = [str stringByAppendingFormat:@" %@",content];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
    
    [paragraphStyle setLineSpacing:3];//调整行间距
    //    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setFirstLineHeadIndent:0];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:ColorCompanyTheme range:NSMakeRange(0, [self.name length])];
    
    if ([TDUtil isValidString:self.atName]) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:ColorCompanyTheme range:NSMakeRange([self.name length]+2, [self.atName length])];
    }
    
    self.contentLabel.attributedText = attributedString;//ios 6
    [self.contentLabel sizeToFit];
    
    [self setFrame:CGRectMake(X(self), Y(self), WIDTH(self), POS_Y(self.contentLabel)+10)];
    
}

@end
