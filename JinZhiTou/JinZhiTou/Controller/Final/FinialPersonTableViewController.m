//
//  FinialPersonTableViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/31.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialPersonTableViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "FinialPersonTableViewCell.h"
@interface FinialPersonTableViewController ()<ASIHTTPRequestDelegate>
{
    HttpUtils* httpUtils;
}

@end

@implementation FinialPersonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化网络对象
    httpUtils = [[HttpUtils alloc] init];
    
    self.view.backgroundColor = ColorTheme;
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"投资人列表"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"项目详情" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    //加载数据
    [self loadData];
    
}

-(void)loadData
{
    NSString* url = [INVEST_LIST stringByAppendingFormat:@"%ld/",(long)self.projectId];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestInvestList:)];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    
    NSInteger row = indexPath.row;
    NSDictionary* dic  = self.dataArray[row];
    cell.titleLabel.text = [dic valueForKey:@"real_name"];
    cell.finialLabel.text =[NSString stringWithFormat:@"投资金额:%@万",[[dic valueForKey:@"invest_amount"] stringValue]];
    cell.timeLabel.text = [NSString stringWithFormat:@"认证时间:%@",[dic valueForKey:@"certificate_datetime"]];
    NSURL* url = [NSURL URLWithString:[dic valueForKey:@"user_img"]];
    [cell.personImgview sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember")];
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
    return 110;
}

#pragma ASIHttpRequeste 
-(void)requestInvestList:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            self.dataArray  =[jsonDic valueForKey:@"data"];
        }
        self.tableView.content = [jsonDic valueForKey:@"msg"];
        
    }
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray.count>0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.tableView reloadData];
        [self.tableView setIsNone:NO];
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setIsNone:YES];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

