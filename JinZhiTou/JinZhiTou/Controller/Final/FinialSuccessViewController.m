//
//  FinialSuccessViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/14.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialSuccessViewController.h"
#import "NavView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
#import "MMDrawerController.h"
#import "UserFinialViewController.h"
#import "UserTraceViewController.h"
@interface FinialSuccessViewController ()
{
    NavView* navView;
}
@end

@implementation FinialSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    navView.titleLable.textColor=WriteColor;
    navView.title = self.titleStr;
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"项目详情" forState:UIControlStateNormal];
    [navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:navView];
    
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    view.backgroundColor  = WriteColor;
    
    UIImageView* imgView =[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2-70, 30, 140, 140)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = IMAGENAMED(@"Submit");
    [view addSubview:imgView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(30, POS_Y(imgView), WIDTH(self.view)-60, 140)];
    label.numberOfLines =0;
    label.font = SYSTEMFONT(16);
    label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentLeft;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
    
    [paragraphStyle setLineSpacing:10.f];//调整行间距
    [paragraphStyle setAlignment:NSTextAlignmentJustified];
    [paragraphStyle setHeadIndent:-50];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.content];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.content length])];
    
    label.attributedText = attributedString;//ios 6
    [label sizeToFit];
    
    [view addSubview:label];
    
    UIButton* btnAction = [[UIButton alloc]initWithFrame:CGRectMake(50, POS_Y(label)+20, 100, 40)];
    btnAction.layer.borderWidth = 1;
    btnAction.layer.cornerRadius = 20;
    btnAction.titleLabel.font  =SYSTEMFONT(16);
    btnAction.layer.borderColor = AppColorTheme.CGColor;
    [btnAction addTarget:self action:@selector(TraceAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAction setTitle:@"进度查看" forState:UIControlStateNormal];
    [btnAction setTitleColor:ColorTheme forState:UIControlStateNormal];
    [view addSubview:btnAction];
    
    btnAction = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self.view)-WIDTH(btnAction)-50, Y(btnAction), 100, 40)];
    btnAction.layer.cornerRadius = 20;
    btnAction.layer.borderWidth = 1;
    btnAction.titleLabel.font  =SYSTEMFONT(16);
    btnAction.layer.borderColor = AppColorTheme.CGColor;
    [btnAction addTarget:self action:@selector(HomeAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAction setTitle:@"返回首页" forState:UIControlStateNormal];
    [btnAction setTitleColor:AppColorTheme forState:UIControlStateNormal];
    [view addSubview:btnAction];
    
    [self.view addSubview:view];
}

-(void)setTitleStr:(NSString *)titleStr
{
    self->_titleStr = titleStr;
    [navView setTitle:titleStr];
}

-(void)setContent:(NSString *)content{
    self->_content = content;
    label.text = content;
}
/**
 *  返回至上一级业务流程
 *
 *  @param sender 界面
 */
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  投融资进度查看
 *
 *  @param sender 返回至我的投融资功能
 */
-(void)TraceAction:(id)sender
{
    if (self.type==0) {
        UserTraceViewController* controller = [[UserTraceViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UserFinialViewController * controller =[storyBoard instantiateViewControllerWithIdentifier:@"Myfinial"];
        controller.isBackHome = YES;
        controller.navTitle  = @"首页";
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

/**
 *  返回至首页
 *
 *  @param sender 首页
 */
-(void)HomeAction:(id)sender
{
    
    for (UIViewController* c in self.navigationController.childViewControllers) {
        if (c.class  == MMDrawerController.class) {
            [self.navigationController popToViewController:c animated:YES];
        }
    }
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
