//
//  AuthViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "AuthViewController.h"
#import "WXApi.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "MMDrawerController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserInfoViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
@interface AuthViewController ()<WXApiDelegate>
{
    UIScrollView* scrollView;
}
@property(retain,nonatomic)MMDrawerController* drawerController;
@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView removeFromSuperview];
    
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
    self.registeButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 120 , WIDTH(self.view)-60, 40)];
    [self.registeButton addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
     self.registeButton.titleLabel.font = SYSTEMFONT(18);
    [self.registeButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registeButton.layer.cornerRadius = 5;
    self.registeButton.layer.borderColor = ColorTheme.CGColor;
    self.registeButton.layer.borderWidth = 1;
    [self.registeButton setTitleColor:ColorTheme forState:UIControlStateNormal];
    [view addSubview:self.registeButton];
    
    self.loginButon = [[UIButton alloc]initWithFrame:CGRectMake(X(self.registeButton),POS_Y(self.registeButton)+10, WIDTH(self.registeButton), 40)];
    self.loginButon.userInteractionEnabled = YES;
    [self.loginButon addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButon.titleLabel.font = SYSTEMFONT(18);
    self.loginButon.layer.borderColor = ColorTheme.CGColor;
    self.loginButon.layer.borderWidth = 1;
    self.loginButon.layer.cornerRadius = 5;
    [self.loginButon setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButon setTitleColor:ColorTheme forState:UIControlStateNormal];
    [view addSubview:self.loginButon];
    
    //微信登录
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2-35, POS_Y(self.loginButon)+20, 70, 70)];
    imgView.image = IMAGENAMED(@"weixin");
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendAuthRequest)]];
    imgView.contentMode  = UIViewContentModeScaleAspectFill;
    [view addSubview:imgView];
    
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(self.view), POS_Y(imgView)+5, WIDTH(self.view), 21)];
    label.text  =@"使用微信登录";
    [view addSubview:label];
}

-(void)sendAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"JInZhT" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
//    [WXApi sendReq:req];
    [WXApi sendAuthReq:req viewController:self delegate:self];
}
-(void) onReq:(BaseReq*)req
{
    
}

-(void)onResp:(BaseResp *)resp
{
    SendAuthResp* res = (SendAuthResp*)resp;
    if (res.errCode==0) {
        NSString* code = res.code;
        NSString* url = @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx33aa0167f6a81dac&secret=bc5e2b89553589bf7d9e568545793842&code=%@&grant_type=authorization_code";
        url = [NSString stringWithFormat:url,code];
        
        [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestFinished:)];
    }
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

-(void)requestFinished:(ASIHTTPRequest*)request
{
    //项目详情
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        
        
    }

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
