//
//  ShowCommentViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/29.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ShowCommentViewController.h"
#import "NavView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@interface ShowCommentViewController ()
{
    NavView* navView;
    UIView* v;
    UITextField* textField;
}
@end

@implementation ShowCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=0;
    [navView setTitle:@"写评论"];
    navView.titleLable.textColor=WriteColor;
    [self.view addSubview:navView];
    
    v = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    v.backgroundColor = WriteColor;
    [self.view addSubview:v];
    
    textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 30, WIDTH(self.self.view)-130, 40)];
    textField.placeholder = @"输入评论内容";
    [v addSubview:textField];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, POS_Y(textField), WIDTH(textField), 1)];
    imgView.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
    [v addSubview:imgView];
    
    UIButton * btnAction = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self.view)-110, Y(imgView)-30, 90, 25)];
    btnAction.layer.borderWidth=1;
    btnAction.layer.cornerRadius  = 15;
    [btnAction setTitle:@"发表" forState:UIControlStateNormal];
    [btnAction.titleLabel setFont:SYSTEMFONT(16)];
    btnAction.layer.borderColor = BACKGROUND_LIGHT_GRAY_COLOR.CGColor;
    [btnAction setTitleColor:ColorFontLight forState:UIControlStateNormal];
    [v addSubview:btnAction];
    
    self.view.backgroundColor = ColorTheme;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
