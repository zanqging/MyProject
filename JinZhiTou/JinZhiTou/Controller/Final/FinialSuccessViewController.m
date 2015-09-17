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
    [navView setTitle:@"投资结果"];
    navView.titleLable.textColor=WriteColor;
    
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"项目详情" forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:navView];
    
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    view.backgroundColor  = WriteColor;
    
    UIImageView* imgView =[[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2-70, 30, 140, 140)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = IMAGENAMED(@"Submit");
    [view addSubview:imgView];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(30, POS_Y(imgView), WIDTH(self.view)-60, 140)];
    label.numberOfLines =0;
    label.font = SYSTEMFONT(16);
    label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"    尊敬的用户，您的投资申请已提交，48小时内会有工作人员与您联系，您也可以在“个人中心”－－“进度查看”中查看到审核进度。";
    [view addSubview:label];
    
    UIButton* btnAction = [[UIButton alloc]initWithFrame:CGRectMake(50, POS_Y(label)+20, 100, 40)];
    btnAction.layer.borderWidth = 1;
    btnAction.layer.cornerRadius = 20;
    btnAction.titleLabel.font  =SYSTEMFONT(16);
    btnAction.layer.borderColor = ColorTheme.CGColor;
    [btnAction addTarget:self action:@selector(TraceAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAction setTitle:@"进度查看" forState:UIControlStateNormal];
    [btnAction setTitleColor:ColorTheme forState:UIControlStateNormal];
    [view addSubview:btnAction];
    
    btnAction = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self.view)-WIDTH(btnAction)-50, Y(btnAction), 100, 40)];
    btnAction.layer.cornerRadius = 20;
    btnAction.layer.borderWidth = 1;
    btnAction.titleLabel.font  =SYSTEMFONT(16);
    btnAction.layer.borderColor = ColorTheme.CGColor;
    [btnAction addTarget:self action:@selector(HomeAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAction setTitle:@"点击返回" forState:UIControlStateNormal];
    [btnAction setTitleColor:ColorTheme forState:UIControlStateNormal];
    [view addSubview:btnAction];
    
    [self.view addSubview:view];
    
    

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
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UserFinialViewController * controller =[storyBoard instantiateViewControllerWithIdentifier:@"Myfinial"];
    controller.isBackHome = YES;
    controller.navTitle  = @"首页";
    [self.navigationController pushViewController:controller animated:YES];
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
