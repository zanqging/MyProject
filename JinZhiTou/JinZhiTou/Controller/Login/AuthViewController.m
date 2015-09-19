//
//  AuthViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "AuthViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UConstants.h"
#import "GlobalDefine.h"
#import "MMDrawerController.h"
#import "UserInfoViewController.h"
#import "ForgetPassViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
@interface AuthViewController ()
{
    UIScrollView* scrollView;
}
@property(retain,nonatomic)MMDrawerController* drawerController;
@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=ColorTheme;
    
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    view.backgroundColor  =WriteColor;
    [self.view addSubview:view];
    UIImageView* imgView =[[UIImageView alloc]initWithFrame:self.view.frame];
    imgView.image = IMAGENAMED(@"denglu");
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imgView];
    
    
    imgView =[[UIImageView alloc]initWithFrame:CGRectMake(60, 70, WIDTH(self.view)-120  , 100)];
    imgView.image = IMAGENAMED(@"jinzht");
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imgView];
    
    //设置button样式
    self.registeButton = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(imgView)+20, WIDTH(self.view)/2-40, 40)];
    self.registeButton.backgroundColor = ColorTheme;
    [self.registeButton addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.registeButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registeButton.layer.cornerRadius = HEIGHT(self.registeButton)/2;
    [self.registeButton setTitleColor:WriteColor forState:UIControlStateNormal];
    [view addSubview:self.registeButton];
    
    self.loginButon = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2+10,Y(self.registeButton), WIDTH(self.view)/2-40, 40)];
    self.loginButon.backgroundColor = ColorTheme;
    self.loginButon.userInteractionEnabled = YES;
    [self.loginButon addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButon.layer.cornerRadius = HEIGHT(self.loginButon)/2;
    [self.loginButon setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButon setTitleColor:WriteColor forState:UIControlStateNormal];
    [self.loginButon setTitleColor:WriteColor forState:UIControlStateNormal];
    [view addSubview:self.loginButon];
    
    UIButton* btnActionLeft = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2-100, POS_Y(self.loginButon)+30, 100, 40)];
    btnActionLeft.backgroundColor = ClearColor;
    [btnActionLeft addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnActionLeft setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btnActionLeft setTitleColor:ColorTheme forState:UIControlStateNormal];
    [view addSubview:btnActionLeft];
    
    
    UIButton* btnActionRight = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2, Y(btnActionLeft), 100, 40)];
    btnActionRight.backgroundColor = ClearColor;
    [btnActionRight addTarget:self action:@selector(animousAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnActionRight setTitle:@"游客入口" forState:UIControlStateNormal];
    [btnActionRight setTitleColor:ColorTheme forState:UIControlStateNormal];
    [view addSubview:btnActionRight];
    
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2, Y(btnActionLeft)-5, 1, HEIGHT(btnActionLeft)+5)];
    imgView.backgroundColor= ColorTheme;
    [view addSubview:imgView];
}

-(void)forgetAction:(id)sender
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ForgetPassViewController* controller =[storyBoard instantiateViewControllerWithIdentifier:@"ModifyPasswordController"];
    controller.type=0;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)registAction:(id)sender
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller =[storyBoard instantiateViewControllerWithIdentifier:@"RegisteController"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)loginAction:(id)sender
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller =[storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)animousAction:(id)sender
{
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    [data setValue:@"YES" forKey:@"isAnimous"];
    
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller =[storyBoard instantiateViewControllerWithIdentifier:@"HomeTabController"];
    
    UserInfoViewController* userInfoController = [[UserInfoViewController alloc]init];
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:controller
                             leftDrawerViewController:userInfoController
                             rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:280.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
         
     }];

    [self.navigationController pushViewController:self.drawerController animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (!self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
