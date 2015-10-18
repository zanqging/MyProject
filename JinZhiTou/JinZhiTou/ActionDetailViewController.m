//
//  ActionDetailViewController.m
//  Cycle
//
//  Created by air on 15/10/14.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "ActionDetailViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
@interface ActionDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ActionHeaderDeleaget>
{
    HttpUtils* httpUtils;
    ActionHeader* headerView;
}
@end

@implementation ActionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈";
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"全文详情"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.title forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];


    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-kTopBarHeight-kStatusBarHeight)];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.backgroundColor=WriteColor;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.contentSize = CGSizeMake(WIDTH(self.view), HEIGHT(self.view)+220);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.view addSubview:self.tableView];
    
    headerView = [[ActionHeader alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 200)];
    headerView.delegate = self;
    headerView.dic = self.dic;
    [self.tableView setTableHeaderView:headerView];
    
    self.classStringName = @"CyclePriseTableViewCell";
    httpUtils = [[HttpUtils alloc]init];
    self.selectIndex = 1;
    [self loadData];
    
}

-(void)loadData
{
    switch (self.selectIndex) {
        case 1:
            [self loadPriseListData];
            break;
        case 2:
            [self loadShareListData];
            break;
        case 3:
            [self loadCommentListData];
            break;
            
        default:
            break;
    }
}

-(void)loadPriseListData
{
    NSString* serverUrl = [CYCLE_CONTENT_PRISE_LIST stringByAppendingFormat:@"%@/%d/",[self.dic valueForKey:@"id"],0];
    [httpUtils getDataFromAPIWithOps:serverUrl type:0 delegate:self sel:@selector(requestPriseList:) method:@"GET"];
}

-(void)loadShareListData
{
    
}

-(void)loadCommentListData
{
    NSString* serverUrl = [CYCLE_CONTENT_COMMENT_LIST stringByAppendingFormat:@"%@/%d/",[self.dic valueForKey:@"id"],0];
    [httpUtils getDataFromAPIWithOps:serverUrl type:0 delegate:self sel:@selector(requestPriseList:) method:@"GET"];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 100;
    switch (self.selectIndex) {
        case 1:
            height = 44;
            break;
        case 2:
            height = 60;
            break;
        case 3:
            height = 60;
            break;
        default:
            height = 70;
            break;
    }
    return height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"UserInfoViewCell";
    if([self.classStringName isEqualToString:@"CyclePriseTableViewCell"])
    {
        CyclePriseTableViewCell* cell;
        //用TableDataIdentifier标记重用单元格
        cell =[[NSClassFromString(self.classStringName)alloc]init];
        cell=[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
        //如果单元格未创建，则需要新建
        if (cell==nil) {
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            cell = [[NSClassFromString(self.classStringName)alloc]initWithFrame:CGRectMake(0, 0, WIDTH(tableView), height)];
        }
        
        NSDictionary* dic = self.dataArray[indexPath.row];
        cell.dic = dic;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }else{
        CycleShareTableViewCell* cell;
        //用TableDataIdentifier标记重用单元格
        cell =[[NSClassFromString(self.classStringName)alloc]init];
        cell=[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
        //如果单元格未创建，则需要新建
        if (cell==nil) {
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            cell = [[NSClassFromString(self.classStringName)alloc]initWithFrame:CGRectMake(0, 0, WIDTH(tableView), height)];
        }
        
        NSDictionary* dic = self.dataArray[indexPath.row];
        cell.dic = dic;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }


    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(void)setClassStringName:(NSString *)classStringName
{
    self->_classStringName = classStringName;
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    self->_selectIndex  =selectIndex;

}

-(void)setDataArray:(NSMutableArray *)dataArray{
    self->_dataArray = dataArray;
    if (self.dataArray) {
        [self.tableView reloadData];
    }
}

-(void)actionHeader:(id)header selectedIndex:(NSInteger)selectedIndex className:(NSString *)className
{
    self.classStringName = className;
    if (self.selectIndex != selectedIndex) {
        self.selectIndex = selectedIndex;
        [self loadData];
    }
}

#pragma ASIHttpRequest
-(void)requestPriseList:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue] == 0 || [status integerValue] == -1) {
            self.dataArray = [dic valueForKey:@"data"];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"内容获取成功!"];
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}

@end
