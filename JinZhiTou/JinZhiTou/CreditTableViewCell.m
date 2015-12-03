//
//  CreditTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/11/12.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "CreditTableViewCell.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation CreditTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = BackColor;
        v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self)-5)];
        v.backgroundColor = WriteColor;
        [self addSubview:v];
        
        //标题
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, WIDTH(v)-20, 21)];
        titleLabel.numberOfLines=2;
        titleLabel.font  =SYSTEMBOLDFONT(18);
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [v addSubview:titleLabel];
        
        //内容
        contentLabel  =[[UILabel alloc]initWithFrame:CGRectMake(X(titleLabel), POS_Y(titleLabel)+5, WIDTH(self)-20, 20)];
        contentLabel.numberOfLines = 3;
        contentLabel.font =SYSTEMFONT(16);
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [v addSubview:contentLabel];
        
        [self performSelector:@selector(layout:) withObject:self afterDelay:1];
    }
    return self;
}

-(void)layout:(id)sender
{
    [v setFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self)-5)];
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    self->_dataDic  =dataDic;
    if (self.dataDic) {
        NSString* title = [self.dataDic valueForKey:@"title"];
        NSString* content  =[self.dataDic valueForKey:@"content"];
        NSString* dateTime  =[self.dataDic valueForKey:@"date"];
        if (![dateTime isKindOfClass:NSNull.class]) {
            dateTime = [dateTime stringByAppendingString:content];
        }else{
            dateTime = content;
        }
        
        
        [titleLabel setFrame:CGRectMake(10, 10, WIDTH(v)-20, 21)];
        title = [title stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
        title = [title stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
       
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        
        [paragraphStyle setLineSpacing:0];//调整行间距
        //    [paragraphStyle setAlignment:NSTextAlignmentLeft];
        [paragraphStyle setFirstLineHeadIndent:0];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [title length])];
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[self.dataDic valueForKey:@"searchText"] options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSArray* result = [regex matchesInString:title options:0 range:NSMakeRange(0, title.length)];
        if (result) {
            for(NSTextCheckingResult* r in result)
            {
            
                 [attributedString addAttribute:NSForegroundColorAttributeName value:AppColorTheme range:r.range];
            }
        }
        
        titleLabel.attributedText = attributedString;//ios 6
        [titleLabel sizeToFit];

        dateTime = [dateTime stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
        dateTime = [dateTime stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
        [contentLabel setFrame:CGRectMake(X(titleLabel), POS_Y(titleLabel)+5, WIDTH(self)-20, 20)];
        
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        
        [paragraphStyle setLineSpacing:0];//调整行间距
        //    [paragraphStyle setAlignment:NSTextAlignmentLeft];
        [paragraphStyle setFirstLineHeadIndent:0];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        attributedString = [[NSMutableAttributedString alloc] initWithString:dateTime];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [dateTime length])];
        
//        regex = [NSRegularExpression regularExpressionWithPattern:[self.dataDic valueForKey:@"searchText"] options:NSRegularExpressionCaseInsensitive error:&error];
//        
//        result = [regex matchesInString:dateTime options:0 range:NSMakeRange(0, dateTime.length)];
//        if (result) {
//            for(NSTextCheckingResult* r in result)
//            {
//                [attributedString addAttribute:NSForegroundColorAttributeName value:AppColorTheme range:r.range];
//            }
//        }
        contentLabel.attributedText = attributedString;
        [contentLabel sizeToFit];
        
        [v setFrame:CGRectMake(0, 0, WIDTH(self), POS_Y(contentLabel)+5)];
    }
}
@end
