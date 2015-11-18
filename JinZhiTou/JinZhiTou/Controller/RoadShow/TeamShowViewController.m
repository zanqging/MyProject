//
//  TeamShowViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "TeamShowViewController.h"
#import "Cell.h"
#import "MJRefresh.h"
#import "LineLayout.h"
#import "TeamDetailViewController.h"
#import "ThinkTankTableViewCell.h"
@interface TeamShowViewController ()<UITableViewDataSource , UITableViewDelegate,ASIHTTPRequestDelegate>
{
    BOOL isResetPosition;
    BOOL isRefresh;
    int currentPage;
    NSString* _identify;
}

@end

@implementation TeamShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"核心团队"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"项目详情" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    self.tableView=[[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView)) style:UITableViewStyleGrouped];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=BackColor;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.tableView];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];

    
    //加载数据啊
    [self loadData];
}

-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    self.startLoading  =YES;
    [self loadData];
}

-(void)loadProject
{
    isRefresh =NO;
    if (!self.isEndOfPageSize) {
        currentPage++;
        [self loadData];
    }else{
        isRefresh =NO;
    }
}



-(void)loadData
{
    NSString* url = [COREMEMBER stringByAppendingFormat:@"%ld/",(long)self.projectId];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestCoreMember:)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    [self loadProjectDetail:row];
}

-(void)loadProjectDetail:(NSInteger)index
{
    TeamDetailViewController* controller = [[TeamDetailViewController alloc]init];
    NSMutableDictionary* dic = self.dataArray[index];
    controller.dataDic = dic;
    controller.title = @"成员详情";
    [self.navigationController pushViewController:controller animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 150;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =indexPath.row;
    static NSString *reuseIdetify = @"FinialThinkView";
    ThinkTankTableViewCell *cellInstance = (ThinkTankTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cellInstance) {
        float height =[self tableView:tableView heightForRowAtIndexPath:indexPath];
        cellInstance = [[ThinkTankTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), height)];
    }
    NSDictionary* dic = self.dataArray[row];
    NSURL* url = [NSURL URLWithString:[dic valueForKey:@"img"]];
    __block ThinkTankTableViewCell* cell = cellInstance;
    [cellInstance.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
        if (image) {
            cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
    cellInstance.title = [dic valueForKey:@"name"];
    cellInstance.content =  [dic valueForKey:@"title"];;
    cellInstance.typeDescription = [dic valueForKey:@"profile"];
    cellInstance.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cellInstance;
}


-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray && self.dataArray.count>0) {
        self.tableView.isNone = NO;
        [self.tableView reloadData];
    }else{
        self.tableView.isNone = YES;
    }
    
}
#pragma ASIHttpRequest
-(void)requestCoreMember:(ASIHTTPRequest *)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableArray* jsonDic = [jsonString JSONValue];
    
    if (jsonDic) {
        int code = [[jsonDic valueForKey:@"code"] intValue];
        if (code==0) {
            self.dataArray = [jsonDic valueForKey:@"data"];
        }
        
        self.tableView.content = [jsonDic valueForKey:@"msg"];
        if (self.tableView.header.isRefreshing) {
            [self.tableView.header endRefreshing];
        }
        if (self.tableView.footer.isRefreshing) {
            [self.tableView.footer endRefreshing];
        }
        self.startLoading = NO;
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
