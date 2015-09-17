//
//  FinialAuthTraceViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialAuthTraceViewController.h"
#import "TDUtil.h"
#import "NavView.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "LoadingView.h"
#import "LoadingUtil.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "AuthTraceTableViewCell.h"
#import "FinialAuthViewController.h"
#import "FinialAuthDetailViewController.h"
@interface FinialAuthTraceViewController ()<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    NavView* navView;
    HttpUtils* httpUtils;
    LoadingView* loadingView;
}

@end

@implementation FinialAuthTraceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:@"认证进度"];
    navView.titleLable.textColor=WriteColor;
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"首页" forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:navView];
    
    [self loadAuthenticationData];
}


-(void)loadAuthenticationData
{
    //初始化网络请求对象
    httpUtils = [[HttpUtils alloc]init];
    [httpUtils getDataFromAPIWithOps:MY_INVEST_LIST postParam:nil type:0 delegate:self sel:@selector(requestAuthenCation:)];
    
    
    loadingView = [LoadingUtil shareinstance:self.view];
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <self.dataArray.count) {
        FinialAuthDetailViewController* controller = [[FinialAuthDetailViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        FinialAuthViewController* controller = [[FinialAuthViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =indexPath.row;
    
    if (row<self.dataArray.count) {
        NSDictionary* dic = self.dataArray[row];
        BOOL is_qualified = [[dic valueForKey:@"is_qualified"] boolValue];
        if (is_qualified) {
            return 150;
        }
        return 250;
    }else{
        return 70;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row<self.dataArray.count && self.dataArray.count>0) {
        //声明静态字符串对象，用来标记重用单元格
        NSString* TableDataIdentifier=@"TraceTableViewCell";
        //用TableDataIdentifier标记重用单元格
        AuthTraceTableViewCell* cellInstance=(AuthTraceTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
        //如果单元格未创建，则需要新建
        if (cellInstance==nil) {
            NSDictionary* dic = self.dataArray[indexPath.row];
            BOOL is_qualified = [[dic valueForKey:@"is_qualified"] boolValue];
            float height =0;
            if (is_qualified) {
                height = 150;
            }else{
                 height = 250;
            }
            CGRect frame = self.view.frame;
            
            cellInstance = [[AuthTraceTableViewCell alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, height)];
        }
        NSInteger row =indexPath.row;
        NSDictionary* dic = self.dataArray[row];
        
        BOOL is_qualified = [[dic valueForKey:@"is_qualified"] boolValue];
        if (is_qualified) {
            [cellInstance setIsFinished:YES];
            cellInstance.title = [dic valueForKey:@"company"];
        }
        
        return cellInstance;
    }else{
        //声明静态字符串对象，用来标记重用单元格
        NSString* TableDataIdentifier=@"UiTableViewCell";
        //用TableDataIdentifier标记重用单元格
        UITableViewCell* cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
        //如果单元格未创建，则需要新建
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
            cell.backgroundColor = BackColor;
            UIView * view = [[UIView alloc]initWithFrame:cell.frame];
            view.backgroundColor = BackColor;
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(cell)/2-70, HEIGHT(cell)/2, 30, 30)];
            imageView.image = IMAGENAMED(@"shangchuan");
            [view addSubview:imageView];
            UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+5, HEIGHT(cell)/2-5, WIDTH(cell)/2, HEIGHT(cell))];
            lable.textAlignment = NSTextAlignmentLeft;
            lable.text = @"点击添加新的认证";
            lable.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
            lable.font = SYSTEMFONT(16);
            [view addSubview:lable];
            [cell addSubview:view];
        }
        return cell;
    }
    
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray && self.dataArray.count > 0) {
       [self.tableView reloadData];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count+1;
}

#pragma ASIHttpRequester
-(void)requestAuthenCation:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString* status =[jsonDic valueForKey:@"status"];
        if([status intValue] == 0 || [status intValue] ==-1){
            [LoadingUtil closeLoadingView:loadingView];
            self.dataArray = [jsonDic valueForKey:@"data"];
            if (!self.tableView) {
                self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-NAVVIEW_HEIGHT-NAVVIEW_POSITION_Y) style:UITableViewStylePlain];
                self.tableView.bounces=YES;
                self.tableView.delegate=self;
                self.tableView.dataSource=self;
                self.tableView.allowsSelection=YES;
                self.tableView.delaysContentTouches=NO;
                self.tableView.backgroundColor=BackColor;
                self.tableView.showsVerticalScrollIndicator=NO;
                self.tableView.showsHorizontalScrollIndicator=NO;
                self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
                self.tableView.contentSize = CGSizeMake(WIDTH(self.view), HEIGHT(self.view)+100);
                [self.view addSubview:self.tableView];
            }
            if ([status integerValue] == -1) {
//                isLastPage = YES;
            }
        }else{
            loadingView.isError = YES;
            loadingView.content = @"网络请求失败!";
        }
    }else{
        loadingView.isError = YES;
        loadingView.content = @"网络请求失败!";
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    loadingView.isError = YES;
    loadingView.content = @"网络请求失败!";
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
