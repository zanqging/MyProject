//
//  UserCollecteViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/8.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserCollecteViewController.h"
#import "TDUtil.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "HttpUtils.h"
#import "MJRefresh.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "GlobalDefine.h"
#import "SwitchSelect.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "UserCollecteTableViewCell.h"
#import "RoadShowDetailViewController.h"
@interface UserCollecteViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate,LoadingViewDelegate>
{
    HttpUtils* httpUtil;
    LoadingView* loadingView;
    
    bool isRefresh;
    BOOL isLastPage;
    NSInteger currentPage;
    NSInteger currentSelected;
    UIScrollView* scrollView;
}
@end

@implementation UserCollecteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"我的收藏"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    //头部
    [self addSwitchView];
    
    self.tableView=[[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, POS_Y(scrollView), WIDTH(self.view), HEIGHT(self.view)-HEIGHT(scrollView)-HEIGHT(self.navView)) style:UITableViewStylePlain];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=BackColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.tableView];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    
    [self loadData];
    
    //初始化网络请求对象
    httpUtil = [[HttpUtils alloc]init];
    //加载页
    loadingView = [LoadingUtil shareinstance:self.view];
    loadingView.delegate = self;
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    
    //加载数据
    [self loadCollecteData];
}

-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    switch (currentSelected) {
        case 1000:
            [self loadCollecteData];
            break;
        case 1001:
            [self loadFinacingData];
            break;
        case 1002:
            [self loadFinacedData];
            break;
        case 1003:
            [self loadThinkTankData];
            break;
        default:
            [self loadCollecteData];
            break;
    }
    
}

-(void)loadProject
{
    isRefresh =NO;
    if (!self.isEndOfPageSize) {
        currentPage++;
        switch (currentSelected) {
            case 1000:
                [self loadCollecteData];
                break;
            case 1001:
                [self loadFinacingData];
                break;
            case 1002:
                [self loadFinacedData];
                break;
            case 1003:
                [self loadThinkTankData];
                break;
            default:
                [self loadCollecteData];
                break;
        }
        
    }else{
        [self.tableView.footer endRefreshing];
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"已加载全部内容"];
    }
}


-(void)loadCollecteData
{
    NSString* url = [MY_COLLECTE_ROADSHOW stringByAppendingFormat:@"%ld/",(long)currentPage];
    [httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestCollectData:)];
}
-(void)loadThinkTankData
{
    NSString* url = [MY_COLLECTE_THINKTANK stringByAppendingFormat:@"%ld/",(long)currentPage];
    [httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestCollectData:)];
}
-(void)loadFinacingData
{
    NSString* url = [MY_COLLECTE_FINANCING stringByAppendingFormat:@"%ld/",(long)currentPage];
    [httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestCollectData:)];
}
-(void)loadFinacedData
{
    NSString* url = [MY_COLLECTE_FINANCED stringByAppendingFormat:@"%ld/",(long)currentPage];
    [httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestCollectData:)];
}

-(void)addSwitchView
{
    NSMutableArray* array=[NSMutableArray arrayWithObjects: @"微路演",@"融资中",@"已融资",@"投资人", nil];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), 50)];
     scrollView.backgroundColor =WriteColor;
    UITapGestureRecognizer* recognizer;
    float w =WIDTH(self.view)/array.count;
    for (int i =  0; i<array.count; i++) {
        recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        //自然投资人
        SwitchSelect* switchView = [[SwitchSelect alloc]initWithFrame:CGRectMake(w*i, 0,w, 50)];
        switchView.tag =1000+i;
        if (i==0) {
            switchView.isSelected = YES;
        }
        
        switchView.titleName = array[i];
        switchView.backgroundColor = BackColor;
        [switchView addGestureRecognizer:recognizer];
        [scrollView setContentSize:CGSizeMake(w*i, HEIGHT(scrollView))];
        [scrollView addSubview:switchView];
    }
   
   [self.view addSubview:scrollView];
}

-(void)tapAction:(UITapGestureRecognizer*)sender
{
    SwitchSelect* switchView = (SwitchSelect*)sender.view;
    switchView.isSelected =YES;
   
    for ( UIView *  v in scrollView.subviews) {
        if (v.class == SwitchSelect.class) {
            if (v.tag != switchView.tag) {
                ((SwitchSelect*)v).isSelected=NO;
            }
        }
    }
    
    if (currentSelected !=switchView.tag) {
         currentSelected = switchView.tag;
        currentPage = 0;
        self.isEndOfPageSize= NO;
        isLastPage = false;
        switch (currentSelected) {
            case 1000:
                [self loadCollecteData];
                break;
            case 1001:
                [self loadFinacingData];
                break;
            case 1002:
                [self loadFinacedData];
                break;
            case 1003:
                [self loadThinkTankData];
                break;
            default:
                [self loadCollecteData];
                break;
        }
    }
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    NSMutableDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"xiaoxihuifu" forKey:@"imageName"];
    [dic setValue:@"消息回复" forKey:@"title"];
    [array addObject:dic];
    
    [dic setValue:@"jindu" forKey:@"imageName"];
    [dic setValue:@"进度查看" forKey:@"title"];
    [array addObject:dic];
    
    [dic setValue:@"xiaoxihuifu" forKey:@"imageName"];
    [dic setValue:@"消息通知" forKey:@"title"];
    [array addObject:dic];
    
    self.dataArray=array;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoadShowDetailViewController* controller =[[RoadShowDetailViewController alloc]init];
    controller.title =self.navView.title;
    controller.dic = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"UserCollecteViewCell";
    //用TableDataIdentifier标记重用单元格
    UserCollecteTableViewCell* cell=(UserCollecteTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (cell==nil) {
        cell =[[UserCollecteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
    }
    
    NSDictionary* dic = self.dataArray[indexPath.row];
    
    [cell.imgview sd_setImageWithURL:[dic valueForKey:@"thumbnail"] placeholderImage:IMAGENAMED(@"loading")];
    cell.titleLabel.text = [dic valueForKey:@"company_name"];
    cell.desclabel.text = [dic valueForKey:@"project_summary"];
    
    NSArray* arr = [dic valueForKey:@"industry_type"];
    NSString* str =@"";
    for (int i = 0; i<arr.count; i++) {
        str = [str stringByAppendingFormat:@"%@/",arr[i]];
    }
    
    cell.typeLabel.text = str;
    cell.votelabel.text = [[dic valueForKey:@"vote_sum"] stringValue];
    cell.priseLabel.text = [[dic valueForKey:@"like_sum"] stringValue];
    cell.colletcteLabel.text = [[dic valueForKey:@"collect_sum"] stringValue];
    cell.timeLabel.text = [dic valueForKey:@"roadshow_start_datetime"];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    tableView.contentSize = CGSizeMake(WIDTH(tableView), 190*self.dataArray.count+100);
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray.count<=0) {
        self.tableView.isNone = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.isNone = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [self.tableView reloadData];
}

#pragma LoadingView
-(void)refresh
{
    [self loadCollecteData];
    loadingView.isError =NO;
    
}

#pragma ASIHttpquest
//待融资
-(void)requestCollectData:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString* status =[jsonDic valueForKey:@"status"];
        if([status intValue] == 0 || [status intValue] ==-1){
            [LoadingUtil closeLoadingView:loadingView];
            self.dataArray = [jsonDic valueForKey:@"data"];
            
            if ([status integerValue] == -1) {
                isLastPage = YES;
                self.isEndOfPageSize = YES;
            }
        }else{
            loadingView.isError = YES;
            loadingView.content = @"网络请求失败!";
        }
        self.tableView.content = [jsonDic valueForKey:@"msg"];
    }else{
        loadingView.isError = YES;
        loadingView.content = @"网络请求失败!";
    }
    
    if (isRefresh) {
        [self.tableView.header endRefreshing];
    }else{
        [self.tableView.footer endRefreshing];
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
