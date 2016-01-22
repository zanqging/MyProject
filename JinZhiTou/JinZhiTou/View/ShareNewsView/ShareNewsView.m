//
//  ShareNewsView.m
//  JinZhiTou
//
//  Created by air on 15/10/28.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "ShareNewsView.h"
#import "GlobalDefine.h"
#import "UConstants.h"
@implementation ShareNewsView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
        v.backgroundColor = BlackColor;
        v.alpha =0.7;
        [self addSubview:v];
        
        
        //内容视图
        contentView  = [[UIView alloc]initWithFrame:CGRectMake(10, HEIGHT(self)/2-170, WIDTH(self)-20, 220)];
        contentView.backgroundColor  =WriteColor;
        [self addSubview:contentView];
        
        UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
        label.textAlignment =  NSTextAlignmentCenter;
        label.textColor = FONT_COLOR_BLACK;
        label.text=@"分享";
        label.font = SYSTEMFONT(20);
        [contentView addSubview:label];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, 70, 70)];
        [contentView addSubview:imgView];
        
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+5, Y(imgView)+25, WIDTH(contentView)-80, HEIGHT(imgView))];
        titleLabel.numberOfLines =2;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [contentView addSubview:titleLabel];
        
        
        //分割线
        UIImageView* lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT(contentView)-50, WIDTH(contentView), 1)];
        lineImgView.backgroundColor=AppColorTheme;
        [contentView addSubview:lineImgView];
        
        self.btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(0, POS_Y(lineImgView), WIDTH(contentView)/2-0.5, 50)];
        [self.btnCancel setTitleColor:AppColorTheme forState:UIControlStateNormal];
        [self.btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [self.btnCancel addTarget:self action:@selector(btnCancel:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:self.btnCancel];
        
        textView=[[UITextView alloc]initWithFrame:CGRectMake(10, POS_Y(imgView)+10, WIDTH(self)-40, 40)];
        textView.delegate =self;
        textView.font  = SYSTEMFONT(18);
        textView.text =@"说点什么吧！";
        textView.textColor = FONT_COLOR_GRAY;
        textView.returnKeyType  =UIReturnKeyDone;
        [contentView addSubview:textView];
        
        
        self.btnSure = [[UIButton alloc]initWithFrame:CGRectMake( WIDTH(contentView)/2, Y(self.btnCancel), WIDTH(self.btnCancel), HEIGHT(self.btnCancel))];
        [self.btnSure setTitleColor:AppColorTheme forState:UIControlStateNormal];
        [self.btnSure addTarget:self action:@selector(btnSure:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnSure setTitle:@"转发" forState:UIControlStateNormal];
        [contentView addSubview:self.btnSure];
    }
    return self;
}

-(void)btnCancel:(id)sender
{
    [self removeFromSuperview];
}

-(void)btnSure:(id)sender
{
    NSString* content  =textView.text;
    if ([content isEqualToString:@"说点什么吧！"]) {
        content = @"";
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"shareNewContent" object:nil userInfo:[NSDictionary dictionaryWithObject:content forKey:@"data"]];
}
-(void)setDic:(NSDictionary *)dic
{
    self->_dic  = dic;
    if (self.dic) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"img"]] placeholderImage:IMAGENAMED(@"loading")];
        

        NSString* content = [dic valueForKey:@"title"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        
        [paragraphStyle setLineSpacing:0];//调整行间距
        //    [paragraphStyle setAlignment:NSTextAlignmentLeft];
        [paragraphStyle setFirstLineHeadIndent:0];
        [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        
        titleLabel.attributedText = attributedString;//ios 6
        [titleLabel sizeToFit];
        
    }
}

-(void)textViewDidBeginEditing:(UITextView *)tv
{
    if ([tv.text isEqualToString:@"说点什么吧！"]) {
        tv.text =@"";
    }
    
    //移动视图
    [UIView animateWithDuration:0.5 animations:^{
        [contentView setFrame:CGRectMake(X(contentView), Y(contentView)-100, WIDTH(contentView), HEIGHT(contentView))];
    }];
}

-(void)textViewDidChange:(UITextView *)tv
{
    
}

-(void)textViewDidEndEditing:(UITextView *)tv
{
    if ([tv.text isEqualToString:@""]) {
        tv.text =@"说点什么吧！";
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [contentView setFrame:CGRectMake(X(contentView), Y(contentView)+100, WIDTH(contentView), HEIGHT(contentView))];
    }];
}

- (BOOL)textView:(UITextView *)tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [tv resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

@end
