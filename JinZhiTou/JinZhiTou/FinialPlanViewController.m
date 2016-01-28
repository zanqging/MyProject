//
//  FinialPlanViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/31.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialPlanViewController.h"
#import "FinialPlanTableViewCell.h"
@interface FinialPlanViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* dataArray;
    NSMutableDictionary* dicData; //返回投资列表
}

@end

@implementation FinialPlanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.startLoading = YES;
    //初始化网络
    self.view.backgroundColor = ColorTheme;
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"融资计划"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"项目详情" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-kTopBarHeight-kStatusBarHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BackColor;
    [self.tableView setTableHeaderView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    //加载数据
    [self loadData];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self resetLoadingView];
}
-(void)loadData
{
    dataArray = [[NSMutableArray alloc]init];
    NSMutableDictionary * dic = [NSMutableDictionary new];
    SETDICVFK(dic, @"img", @"plan_icon1");
    SETDICVFK(dic, @"title", @"融资额度: ");
    [dataArray addObject:dic];
    dic = [NSMutableDictionary new];
    SETDICVFK(dic, @"img", @"plan_icon2");
    SETDICVFK(dic, @"title", @"融资方式: ");
    [dataArray addObject:dic];
    dic = [NSMutableDictionary new];
    SETDICVFK(dic, @"img", @"plan_icon3");
    SETDICVFK(dic, @"title", @"释放比例: ");
    [dataArray addObject:dic];
    dic = [NSMutableDictionary new];
    SETDICVFK(dic, @"img", @"plan_icon4");
    SETDICVFK(dic, @"title", @"资金用途: ");
    [dataArray addObject:dic];
    dic = [NSMutableDictionary new];
    SETDICVFK(dic, @"img", @"plan_icon5");
    SETDICVFK(dic, @"title", @"退出方式: ");
    [dataArray addObject:dic];
    //加载视图
    NSString* url = [FINANCE_PLAN stringByAppendingFormat:@"%ld/",(long)self.projectId];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestFinacePlan:)];
    self.startLoading  =YES;
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
    FinialPlanTableViewCell* cell=(FinialPlanTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    if (!cell) {
        cell = [[FinialPlanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier ];
        cell.backgroundColor=WriteColor;
    }
    
    if (dicData) {
        NSInteger row = indexPath.row;
        
        cell.dic = dataArray[row];
        double share2give = [[dicData valueForKey:@"share2give"] doubleValue];
        switch (row) {
            case 0:
                cell.title = [[[dicData valueForKey:@"planfinance"] stringValue] stringByAppendingString:@"万"];
                break;
            case 1:
                cell.title = @"股权融资";
                break;
            case 2:
                cell.title = [[NSString stringWithFormat:@"%.2f",share2give] stringByAppendingString:@"%"];
                break;
            case 3:
                cell.title = @"";
                cell.content  =[dicData valueForKey:@"usage"];
                break;
            case 4:
                cell.title = [dicData valueForKey:@"quitway"];
                break;
            default:
                break;
        }
    }
    
    
    //绘制虚线
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    float h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width
{
    
    if (!self.tableView.cellAutoHeightManager) {
        self.tableView.cellAutoHeightManager = [[SDCellAutoHeightManager alloc] init];
    }
    if (self.tableView.cellAutoHeightManager.contentViewWidth != width) {
        self.tableView.cellAutoHeightManager.contentViewWidth = width;
        [self.tableView.cellAutoHeightManager clearHeightCache];
    }
    UITableViewCell *cell = [self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:indexPath];
    self.tableView.cellAutoHeightManager.modelCell = cell;
    if (cell.contentView.width != width) {
        cell.contentView.width = width;
    }
    return [[self.tableView cellAutoHeightManager] cellHeightForIndexPath:indexPath model:nil keyPath:nil];
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
            self.startLoading  = NO;
        }
        
    }
    
}

-(void)refresh
{
    [super refresh];
    [self loadData];
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.isNetRequestError = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view sendSubviewToBack:self.tableView];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
