//
//  ReplyView.m
//  JinZhiTou
//
//  Created by air on 15/10/8.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "ReplyView.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation ReplyView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
        v.backgroundColor = BlackColor;
        v.alpha = 0.7;
        
        [self addSubview:v];
        scrollView = [[UIScrollView alloc]initWithFrame:v.frame];
        [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView:)]];
        [self addSubview:scrollView];
        
        
        //输入框
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(20, HEIGHT(self)/2-125, WIDTH(self)-40, 190)];
        self.contentView.layer.cornerRadius = 5;
        self.contentView.backgroundColor = WriteColor;
        [scrollView addSubview:self.contentView];
        
        //提示
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, WIDTH(self.contentView)-40, 20)];
        label.textColor  =ColorTheme;
        label.font = SYSTEMFONT(14);
        label.text  =@"请输入要回复的内容";
        [self.contentView addSubview:label];
        
        //输入框
        self.textView  =[[UITextView alloc]initWithFrame:CGRectMake(20, POS_Y(label)+5, WIDTH(label), 60)];
        self.textView.delegate = self;
        self.textView.font  = SYSTEMFONT(16);
        self.textView.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:self.textView];
        
        v = [[UIView alloc]initWithFrame:CGRectMake(X(label), POS_Y(self.textView), WIDTH(self.textView), 2)];
        v.backgroundColor  =ColorTheme;
        [self.contentView addSubview:v];
        
        labelTextCount = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)-60, POS_Y(v)+2, 60, 20)];
        labelTextCount.font = SYSTEMFONT(12);
        labelTextCount.textColor = FONT_COLOR_GRAY;
        labelTextCount.textAlignment = NSTextAlignmentRight;
        labelTextCount.text = @"0/140";
        [self.contentView addSubview:labelTextCount];
        
        UIButton* btnAction = [[UIButton alloc]initWithFrame:CGRectMake(X(label), POS_Y(labelTextCount)+10, WIDTH(label), 35)];
        [btnAction setBackgroundColor:AppColorTheme];
        btnAction.layer.cornerRadius = 5;
        [btnAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnAction setTitle:@"回复" forState:UIControlStateNormal];
        [btnAction setTitleColor:WriteColor forState:UIControlStateNormal];
        [self.contentView addSubview:btnAction];
    }
    return self;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [scrollView setContentOffset:CGPointMake(0, 160) animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


-(void)textViewDidChange:(UITextView *)textView
{
    NSString* text = textView.text;
    int length = [TDUtil convertToInt:text];
    
    if (length >= 140) {
        labelTextCount.textColor = ColorTheme;
    }else{
        labelTextCount.textColor = FONT_COLOR_GRAY;
    }
    labelTextCount.text = [NSString stringWithFormat:@"%d/140",length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

-(void)btnAction:(id)sender
{
    NSString* text = self.textView.text;
    int length = [TDUtil convertToInt:text];
    if (length>140) {
        [[DialogUtil sharedInstance]showDlg:self textOnly:@"回复内容不能超过140字哦!"];
    }else{
        if ([_delegate respondsToSelector:@selector(replyView:text:)]) {
            [_delegate replyView:self text:self.textView.text];
        }
    }
}


-(void)resetLayout
{
    [scrollView setContentOffset:CGPointZero];
}

-(void)closeView:(id)sender
{
    [self removeFromSuperview];
}
@end
