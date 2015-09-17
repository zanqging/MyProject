//
//  FinialPlanViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/31.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialPlanViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "FinialPersonTableViewCell.h"
@interface FinialPlanViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    HttpUtils* httpUtils;
    LoadingView* loadingView;
    NSMutableArray* dataArray;
    NSMutableDictionary* dicData; //返回投资列表
}

@end

@implementation FinialPlanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化网络
    httpUtils = [[HttpUtils alloc]init];
    self.view.backgroundColor = ColorTheme;
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"融资计划"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"项目详情" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //加载数据
    [self loadData];
    
}

-(void)loadData
{
    dataArray = [[NSMutableArray alloc]init];
    [dataArray addObject:@"融资额度"];
    [dataArray addObject:@"融资方式"];
    [dataArray addObject:@"释放比例"];
    [dataArray addObject:@"资金用途"];
    [dataArray addObject:@"退出方式"];
    
    //加载视图
    loadingView = [LoadingUtil shareinstance:self.view];
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    
    
    NSString* url = [FINANCE_PLAN stringByAppendingFormat:@"%ld/",(long)self.projectId];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestFinacePlan:)];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"FinalPersonCell";
    //用TableDataIdentifier标记重用单元格
    FinialPersonTableViewCell* cell=(FinialPersonTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    if (!cell) {
        cell = [[FinialPersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier ];
    }
    
    if (dicData) {
        NSInteger row = indexPath.row;
        cell.titleLabel.text = dataArray[row];
        double share2give = [[dicData valueForKey:@"share2give"] doubleValue]*100;
        switch (row) {
            case 0:
                cell.rightLabel.text = [[[dicData valueForKey:@"plan_finance"] stringValue] stringByAppendingString:@"万"];
                break;
            case 1:
                cell.rightLabel.text = [dicData valueForKey:@"finance_pattern"];
                break;
            case 2:
                cell.rightLabel.text = [[NSString stringWithFormat:@"%.2f",share2give] stringByAppendingString:@"%"];
                break;
            case 3:
                cell.textView.text  =[dicData valueForKey:@"fund_purpose"];
                break;
            case 4:
                cell.rightLabel.text = [dicData valueForKey:@"quit_way"];
                break;
            default:
                break;
        }
    }
    
    
    //绘制虚线
    [cell layoutPre];
    return cell;
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row!=3) {
        return 70;
    }else{
        return 110;
    }
}

#pragma ASIHttpRequester
//===========================================================网络请求=====================================
-(void)requestFinacePlan:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            dicData = [jsonDic valueForKey:@"data"];
            [self.tableView reloadData];
            
            [LoadingUtil closeLoadingView:loadingView];
        }
        
    }
    
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
