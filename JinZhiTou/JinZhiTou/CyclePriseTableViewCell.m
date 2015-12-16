//
//  CyclePriseTableViewCell.m
//  Cycle
//
//  Created by air on 15/10/15.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "CyclePriseTableViewCell.h"
#import "GlobalDefine.h"
#import "UConstants.h"
@implementation CyclePriseTableViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //头像
        headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        [self addSubview:headerImgView];
        
        //名称
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(headerImgView)+10, Y(headerImgView), 70, 21)];
        nameLabel.font = SYSTEMFONT(14);
        nameLabel.textColor = FONT_COLOR_GRAY;
        [self addSubview:nameLabel];
        
        companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(nameLabel)+5, Y(nameLabel), 200, HEIGHT(nameLabel))];
        companyLabel.textColor = FONT_COLOR_GRAY;
        companyLabel.font = FONT(@"Arial", 14);
        [self addSubview:companyLabel];
        
        
        contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(nameLabel), POS_Y(nameLabel), WIDTH(companyLabel)+50, 20)];
        contentLabel.textColor = FONT_COLOR_BLACK;
        contentLabel.font = FONT(@"Arial", 14);
        contentLabel.numberOfLines = 0;
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:contentLabel];

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)setDic:(NSDictionary *)dic
{
    self->_dic =dic;
    if (self.dic) {
        nameLabel.text = [dic valueForKey:@"name"];
        [headerImgView sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"photo"]] placeholderImage:IMAGENAMED(@"coremember")];
        
        NSString* atName = [dic valueForKey:@"at_name"];
        NSString* atLabel = @"";
        NSString* suffix  =@":";
        if(atName && ![atName isEqualToString:@""]){
            atLabel = @"回复";
        }
        NSString* content =  [dic valueForKey:@"content"];
        NSString* str = @"";
        if (atLabel) {
            str = [str stringByAppendingString:atLabel];
        }
        
        if (atName) {
            str = [str stringByAppendingString:atName];
        }
        
        if (suffix && atLabel) {
            str = [str stringByAppendingString:suffix];
        }
        
        if (content) {
            str = [str stringByAppendingString:content];
        }
        contentLabel.text  =str;
    }
}
@end
