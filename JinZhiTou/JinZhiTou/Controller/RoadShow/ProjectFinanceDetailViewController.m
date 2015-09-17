//
//  RoadShowDetailViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ProjectFinanceDetailViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "RoadShowFooter.h"
#import "RoadShowHeader.h"
#import "NSString+SBJSON.h"
#import "RoadShowBottom.h"
#import "ASIFormDataRequest.h"
#import "TeamShowViewController.h"
#import "RoadShowViewController.h"
#import "FinialApplyViewController.h"
#import "FinialPlanViewController.h"
#import "InteractionViewController.h"
#import "ShowCommentViewController.h"
#import "FinialSuccessViewController.h"
#import "FinialPersonTableViewController.h"

@interface ProjectFinanceDetailViewController ()<ASIHTTPRequestDelegate>
{
    HttpUtils* httpUtils;
    LoadingView * loadingView;
    bool isSelected;
}

@end

@implementation ProjectFinanceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //网络初始化
    httpUtils = [[HttpUtils alloc]init];
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"路演详情"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"微路演" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    
    
    [self.view addSubview:self.navView];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-100) style:UITableViewStylePlain];
    self.tableView.bounces=NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=NO;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.contentSize = CGSizeMake(WIDTH(self.view), HEIGHT(self.view)+50);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    [self.view addSubview:self.tableView];

    
    RoadShowHeader* header = [[RoadShowHeader alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), 400)];
    [self.tableView setTableHeaderView:header];
    
    RoadShowFooter* footer = [[RoadShowFooter alloc]initWithFrame:CGRectMake(0, 5, WIDTH(self.view), 350)];
    [self.tableView setTableFooterView:footer];
    self.view.backgroundColor = ColorTheme;
    
    RoadShowBottom* bottomView = [[RoadShowBottom alloc]initWithFrame:CGRectMake(0, HEIGHT(self.view)-50, WIDTH(self.view), 50)];
    [bottomView.btnFunction addTarget:self action:@selector(goRoadShow:) forControlEvents:UIControlEventTouchUpInside];
    bottomView.type = self.type;
    [self.view addSubview:bottomView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(teamShowAction:) name:@"teamShow" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(collect:) name:@"collect" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(prise:) name:@"prise" object:nil];
    
    //加载数据
    [self  loadProjectDetail];
}
//收藏
-(void)collect:(NSDictionary*)dic
{
    NSInteger index = self.projectId;
    NSString* url = [COLLECTE stringByAppendingFormat:@"%ld/",(long)index];
    NSDictionary* dictionary = [[NSMutableDictionary alloc]init];
    index=0;
    if (isSelected) {
        index = 0;
        isSelected = NO;
    }else{
        index = 1;
        isSelected = YES;
    }
    [dictionary setValue:[NSString stringWithFormat:@"%ld",(long)index] forKey:@"action"];
    
    [httpUtils getDataFromAPIWithOps:url postParam:dictionary type:0 delegate:self sel:@selector(requestCollecte:)];
}

//点赞
-(void)prise:(NSDictionary*)dic
{
    NSInteger index = self.projectId;
    NSString* url = [PRISE stringByAppendingFormat:@"%ld/",(long)index];
    NSDictionary* dictionary = [[NSMutableDictionary alloc]init];
    index=0;
    if (isSelected) {
        index = 0;
        isSelected = NO;
    }else{
        index = 1;
        isSelected = YES;
    }
    [dictionary setValue:[NSString stringWithFormat:@"%ld",(long)index] forKey:@"action"];
    [httpUtils getDataFromAPIWithOps:url postParam:dictionary type:0 delegate:self sel:@selector(requestPrise:)];
}
-(void)loadProjectDetail
{
    loadingView = [LoadingUtil shareinstance:self.view];
    
    if (self.projectId!=0) {
        NSString* url = [PROJECT_DETAIL stringByAppendingFormat:@"%ld/",(long)self.projectId];
        [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestProjectDetail:)];
        
        [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    }
   
}
-(void)setBackTitle:(NSString *)backTitle
{
    self->_backTitle = backTitle;
    [self.navView.leftButton setTitle:backTitle forState:UIControlStateNormal];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"RoadShowTableViewCell";
    //用TableDataIdentifier标记重用单元格
    RoadShowTableViewCell* cell=(RoadShowTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (cell==nil) {
        cell = [[RoadShowTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 100)];
    }
    cell.titleLabel.text=@"公司名称";
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(void)teamShowAction:(NSDictionary*)dic
{
    NSInteger tag =[[[dic valueForKey:@"userInfo"]valueForKey:@"tag"] integerValue];
    if (tag==10001) {
        [self FinancePlanViewController:nil];
    }else if(tag==10002){
        [self FinanceListViewController:nil];
    }else if (tag==10003){
        TeamShowViewController* controller = [[TeamShowViewController alloc]init];
        controller.projectId = self.projectId;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self doAction:nil];
    }
}

-(void)goRoadShow:(id)sender
{
    [LoadingUtil show:loadingView];
    [httpUtils getDataFromAPIWithOps:ISINVESTOR postParam:nil type:0 delegate:self sel:@selector(requestIsInvestor:)];
    
}

-(void)doAction:(id)sender
{
    UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = [board instantiateViewControllerWithIdentifier:@"WeiboViewControlle"];
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)FinancePlanViewController:(id)sender
{
    UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    FinialPlanViewController* controller = [board instantiateViewControllerWithIdentifier:@"FinancePlanViewController"];
    controller.projectId =self.projectId;
    [self.navigationController pushViewController:controller animated:YES];
}



-(void)FinanceListViewController:(id)sender
{
    UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    FinialPersonTableViewController* controller = [board instantiateViewControllerWithIdentifier:@"FinanceListViewController"];
    controller.projectId = self.projectId;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma ASIHttpRequester
//===========================================================网络请求=====================================
-(void)requestProjectDetail:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            [LoadingUtil closeLoadingView:loadingView];
        }
        
    }
    
}


//收藏
-(void)requestCollecte:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            
        }
        
    }
    
}

//点赞
-(void)requestPrise:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            
        }
        
    }
    
}
//获取身份认证信息
-(void)requestIsInvestor:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            if (self.type ==0) {
                NSString* url = [JOIN_ROADSHOW stringByAppendingFormat:@"%ld/",(long)self.projectId];
                [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestJoinroadShow:)];
            }else{
                UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                FinialApplyViewController* controller = (FinialApplyViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"FinialApply"];
                controller.projectId = self.projectId;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            DialogView* dialogView =[TDUtil shareInstanceDialogView:self.view];
            [dialogView.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
            [dialogView.shureButton addTarget:self action:@selector(shure:) forControlEvents:UIControlEventTouchUpInside];
            dialogView.tag =10001;
            [self.view addSubview:dialogView];
        }
    }
}

//获取身份认证信息
-(void)requestJoinroadShow:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            FinialSuccessViewController * controller =[[FinialSuccessViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

-(void)cancel:(id)sender
{
    UIView* view = [self.view viewWithTag:10001];
    [view removeFromSuperview];
}

-(void)shure:(id)sender
{
        UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"AuthConfig"];
        [self.navigationController pushViewController:controller animated:YES];
    
    [self cancel:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

@end
