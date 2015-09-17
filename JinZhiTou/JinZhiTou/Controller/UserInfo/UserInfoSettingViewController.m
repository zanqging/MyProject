//
//  UserInfoSettingViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/7.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserInfoSettingViewController.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "PrivacyViewController.h"
#import "UserSettingTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FeedBackViewController.h"
#import "SecuityViewController.h"
@interface UserInfoSettingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray* dataArray;
}
@end

@implementation UserInfoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"设置"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.view addSubview:self.navView];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor= WriteColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:self.tableView];
    
    UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 100)];
    UIButton* btnAction=[[UIButton alloc]initWithFrame:CGRectMake(30, 30, WIDTH(view)-60, 40)];
    [btnAction setTitle:@"注销登录" forState:UIControlStateNormal];
    btnAction.layer.cornerRadius = 5;
    [btnAction setBackgroundColor:ColorTheme];
    [btnAction addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnAction];
    
    [self.tableView setTableFooterView:view];
    
    [self loadDataArray];
    
}
-(void)loadDataArray
{
    dataArray = [NSArray arrayWithObjects:@"新消息推送",@"清除缓存",@"隐私政策",@"在线反馈",@"检测更新", nil];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loginOut:(id)sender
{
    NSUserDefaults* data= [NSUserDefaults standardUserDefaults];
    [data removeObjectForKey:@"isLogin"];

    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"LoginController"];
    [self.navigationController pushViewController:controller animated:YES];
    
    for(UIViewController* c in self.navigationController.childViewControllers){
        if (![c isKindOfClass:controller.class]) {
            [c removeFromParentViewController];
        }
    }

    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section!=0) {
        if (indexPath.row==0) {
            PrivacyViewController* controller =[[PrivacyViewController alloc]init];
            controller.serverUrl = privacy;
            controller.title = self.navView.title;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            FeedBackViewController* controller =[[FeedBackViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }
       
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"SettingViewCell";
    //用TableDataIdentifier标记重用单元格
    UITableViewCell* cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (cell==nil) {
        cell = [[UserSettingTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 100)];
    }

    
    
    NSInteger section = indexPath.section;
    NSInteger row =indexPath.row;
    if (indexPath.row<dataArray.count) {
        if (section!=0) {
            row+=2;
        }
        NSString* content=@"";
        switch (row) {
            case 0:
                content = @"新消息推送";
                break;
            case 1:
                content = @"清除缓存";
                break;
            case 2:
                content = @"隐私政策";
                break;
            case 3:
                content = @"在线反馈";
                break;
            default:
                break;
        }
        
        cell.textLabel.text = content;
    }
    
    cell.backgroundColor = WriteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        default:
            return 2;
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
