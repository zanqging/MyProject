//
//  AnnounceView.m
//  JinZhiTou
//
//  Created by air on 15/11/14.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "AnnounceView.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation AnnounceView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame ]) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
        view.backgroundColor  =BlackColor;
        view.alpha  =0.8;
        [self addSubview:view];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:FRAME(view)];
        self.contentLabel.tag=10001;
        self.contentLabel.textColor = ColorTheme2;
        self.contentLabel.userInteractionEnabled = YES;
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.contentLabel];
        
        UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self)-50, 0, 50, HEIGHT(self))];
        [btnAction setTitleColor:WriteColor forState:UIControlStateNormal];
        [btnAction setTitle:@"x" forState:UIControlStateNormal];
        [btnAction addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
//        [btnAction.titleLabel setFont:SYSTEMFONT(20)];
        [self addSubview:btnAction];
        
        //默认透明
        
    }
    return self;
}

-(void)setAnnounContent:(NSString *)announStartContent middleContent:(NSString *)announMiddleContent endContent:(NSString *)announEndContent
{
    NSString* content =@"";
    if ([TDUtil isValidString:announStartContent]) {
        self->_announStartContent  = announStartContent;
        content  =[content stringByAppendingString:self.announStartContent];
    }
    
    if ([TDUtil isValidString:announMiddleContent]) {
        self->_announMiddleContent = announMiddleContent;
        content  =[content stringByAppendingString:self.announMiddleContent];
    }
    
    if ([TDUtil isValidString:announEndContent]) {
        self->_announEndContent = announEndContent;
        content  =[content stringByAppendingString:self.announEndContent];
    }
    
    
    //设置样式
    NSMutableParagraphStyle* pargraphStyle = [[NSMutableParagraphStyle alloc]init];
    [pargraphStyle setParagraphSpacing:1];
    [pargraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString* attrbutedString = [[NSMutableAttributedString alloc]initWithString:content];
    [attrbutedString addAttribute:NSParagraphStyleAttributeName value:pargraphStyle range:NSMakeRange(0, content.length)];
    [attrbutedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(self.announStartContent.length, self.announMiddleContent.length)];
    [attrbutedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(self.announStartContent.length, self.announMiddleContent.length)];
    
    self.contentLabel.attributedText = attrbutedString;
}

-(void)closeView:(id)sender
{
    [self removeFromSuperview];
}
@end
