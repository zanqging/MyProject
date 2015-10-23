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
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imgView.image = IMAGENAMED(@"denglu");
    [view  addSubview:imgView];
    
    //设置button样式
    self.registeButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 100 , WIDTH(self.view)-60, 40)];
    [self.registeButton addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
     self.registeButton.titleLabel.font = SYSTEMFONT(14);
    [self.registeButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registeButton.layer.cornerRadius = 5;
    self.registeButton.layer.borderColor = ColorTheme.CGColor;
    self.registeButton.layer.borderWidth = 1;
    [self.registeButton setTitleColor:ColorTheme forState:UIControlStateNormal];
    [view addSubview:self.registeButton];
    
    self.loginButon = [[UIButton alloc]initWithFrame:CGRectMake(X(self.registeButton),POS_Y(self.registeButton)+10, WIDTH(self.registeButton), 40)];
    self.loginButon.userInteractionEnabled = YES;
    [self.loginButon addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButon.titleLabel.font = SYSTEMFONT(14);
    self.loginButon.layer.borderColor = ColorTheme.CGColor;
    self.loginButon.layer.borderWidth = 1;
    self.loginButon.layer.cornerRadius = 5;
    [self.loginButon setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButon setTitleColor:ColorTheme forState:UIControlStateNormal];
    [view addSubview:self.loginButon];
    

    
    
    UIButton* btnActionRight = [[UIButton alloc]initWithFrame:CGRectMake(X(self.loginButon), POS_Y(self.loginButon)+5, WIDTH(self.loginButon), HEIGHT(self.loginButon))];
    [btnActionRight setTitle:@"游客入口" forState:UIControlStateNormal];
    btnActionRight.titleLabel.font = SYSTEMFONT(14);
    btnActionRight.layer.borderColor = ColorTheme.CGColor;
    btnActionRight.layer.borderWidth = 1;
    btnActionRight.layer.cornerRadius = 5;
    [btnActionRight setTitleColor:ColorTheme forState:UIControlStateNormal];
    [btnActionRight addTarget:self action:@selector(animousAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnActionRight];
    
    
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
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
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
