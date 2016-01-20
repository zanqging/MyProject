//
//  NewFinialViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "NewFinialViewController.h"
#import "NewsTag.h"
#import "TypeShow.h"
#import "ShareView.h"
#import "MJRefresh.h"
#import "NewFinance.h"
#import "WMPageConst.h"
#import "SwitchSelect.h"
#import "INSViewController.h"
#import "NewFinialTableViewCell.h"
#import "HomeTabBarViewController.h"
#import "UserInfoConfigController.h"
@interface NewFinialViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate,TypeShowDelegate>
{
    BOOL isRefresh;  //刷新
    int currentpage; //当前页码
    BOOL isShowLoadingView; //是否显示加载
    NSInteger selectedIndex;
}
@end

@implementation NewFinialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    [self.navView removeFromSuperview];
    //加载视图区域
    self.loadingViewFrame = self.view.frame;
    
    CGRect rect;
    rect=CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)-100);
    self.tableView=[[UITableViewCustomView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.backgroundColor=BackColor;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refresh) loadAction:@selector(loadProject)];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInteractionEnabled:) name:@"userInteractionEnabled" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewMessage:) name:@"updateMessageStatus" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initWithParent:) name:WMControllerDidAddToSuperViewNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFinished:) name:WMControllerDidFullyDisplayedNotification object:nil];
}

-(void)initWithParent:(NSNotification*)notification
{
    NSDictionary* dic = [notification object];
    selectedIndex = [[dic valueForKey:@"index"] intValue];
    
    if (!self.dataArray) {
        self.startLoading=YES;
        //        [self refresh];
    }
}

-(void)showFinished:(NSNotification*)notification
{
    NSDictionary* dic = [notification object];
    selectedIndex = [[dic valueForKey:@"index"] intValue];
    if (!self.dataArray) {
        self.startLoading=NO;
//        [self refresh];
        //    //加载离线数据
//        [self loadOffLineData];
        //    //开始加载
        [self loadData];
    }
}

/**
 *  加载数据库缓存数据
 */
-(void)loadOffLineData
{
//    NewsTag* newsTag = [[NewsTag alloc]init];
//    NSMutableArray* array = [newsTag selectData:100 andOffset:0];
    NewFinance * finance = [[NewFinance alloc]init];
    self.dataArray = [finance selectData:10 andOffset:currentpage];
    
    
    
}
-(void)loadData
{
//    self.startLoading  =YES;
//    isShowLoadingView  =YES;
    //头部
//    [self loadNewsTag];
    [self loadNewsData:selectedIndex];
}

-(void)userInteractionEnabled:(NSDictionary*)dic

{
    
    BOOL isUserInteractionEnabled = [[[dic valueForKey:@"userInfo"] valueForKey:@"userInteractionEnabled"] boolValue];
    
    self.view.userInteractionEnabled = isUserInteractionEnabled;
    
}

-(void)searchAction:(id)sender
{
    INSViewController* controller =[[INSViewController alloc]init];
    controller.title = self.navView.title;
    controller.titleContent = @"搜索新三板资讯";
    controller.type=1;
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)loadProject
{
    isRefresh =NO;
    isShowLoadingView = NO;
    if (!self.isEndOfPageSize) {
        currentpage++;
        [self loadNewsData:selectedIndex];
        
    }else{
        [self.tableView.footer endRefreshing];
        UIView * view =[UIApplication sharedApplication].windows[0];
        [[DialogUtil sharedInstance]showDlg:view textOnly:@"已加载全部内容"];
    }
}


-(void)userInfoAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil];
}


-(void)back:(id)sender
{
    if (self.isBackHome) {
        for (UIViewController * c in self.navigationController.childViewControllers) {
            if (c.class == HomeTabBarViewController.class) {
                [self.navigationController popToViewController:c animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)loadNewsData:(NSInteger)index
{
    //添加加载页面
    NSString* str = [NEWS stringByAppendingFormat:@"%ld/%d/",(long)index,currentpage];
    [self.httpUtil getDataFromAPIWithOps:str type:0 delegate:self sel:@selector(requestNewsData:) method:@"GET"];
    
    if (isShowLoadingView) {
        self.startLoading = YES;
        self.isTransparent = YES;
    }
}

-(void)loadNewsTag
{
    isRefresh = YES;
    //添加加载页面
    [self.httpUtil getDataFromAPIWithOps:NEWS_TYPE type:0 delegate:self sel:@selector(requestNewsTagData:) method:@"GET"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.webViewController =[[BannerViewController alloc]init];
    self.webViewController.title = self.navView.title;
    NSDictionary* dic  = self.dataArray[indexPath.row];
    NSURL* url = [NSURL URLWithString:[dic valueForKey:@"url"]];
    self.webViewController.title  = @"新三板";
    self.webViewController.titleStr = @"咨询详情";
    self.webViewController.type = 3;
    self.webViewController.url = url;
    self.webViewController.dic = dic;
    [self.navigationController pushViewController:self.webViewController animated:YES];
    NSString* serverUrl = [NEWS_READ_COUNT stringByAppendingFormat:@"%@/",[dic valueForKey:@"id"]];
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"UsefFinialViewCell";
    //用TableDataIdentifier标记重用单元格
    NewFinialTableViewCell* cell=(NewFinialTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (cell==nil) {
        cell =[[NewFinialTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
    }
    
//    NSDictionary* dic = self.dataArray[indexPath.row];
    NewFinance* finance = self.dataArray[indexPath.row];
//    NSURL* url = [dic valueForKey:@"img"];
    NSURL* url = [NSURL URLWithString:finance.img];
    cell.backgroundColor = BackColor;
    [cell.imgview sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading")];
    cell.source = finance.src;
    cell.titleLabel.text = finance.title;
    cell.typeLabel.text = finance.content;
    cell.dateTime = finance.create_datetime;
    cell.colletcteLabel.text = [finance.share stringValue];
    cell.priseLabel.text = [finance.read stringValue];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentSize = CGSizeMake(WIDTH(tableView), 140*self.dataArray.count+5);
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(void)typeShow:(TypeShow *)typeShow selectedIndex:(NSInteger)index didSelectedString:(NSString *)resultString
{
    isRefresh = YES;
    currentpage = 0;
    selectedIndex = index;
    isShowLoadingView = YES;
    
    [self loadNewsData:selectedIndex];
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray.count<=0) {
        self.tableView.isNone = YES;
    }else{
        self.tableView.isNone = NO;
        [self.tableView reloadData];
    }
}
//==============================刷新功能区域开始==============================//
-(void)refresh
{
//    [super refresh];
    
    if (self.tableView.header.isRefreshing) {
        [self.tableView.header endRefreshing];
    }
    
    if (self.tableView.footer.isRefreshing) {
        [self.tableView.footer endRefreshing];
    }
    //刷新页码为
    currentpage = 0;
    isRefresh  = YES;
    isShowLoadingView = NO;
    self.isEndOfPageSize  =NO;
    if (selectedIndex==0) {
        selectedIndex=1;
    }
    [self loadNewsData:selectedIndex];
//    self.isTransparent  =NO;
}

//==============================刷新功能区域结束==============================//
//==============================网络请求区域开始==============================//
-(void)requestNewsData:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0 || [code intValue] ==2) {
            if ([code integerValue] == 2) {
                self.isEndOfPageSize  =YES;
            }
            
            NewFinance* newFinanceModel = [[NewFinance alloc]init];
            NSMutableArray* tempArray;
            tempArray = [jsonDic valueForKey:@"data"];
            
            if (isRefresh) {
                [newFinanceModel deleteData];
            }
            
            NewFinance* finance;
            NSDictionary* dic;
            
            NSMutableArray* dataArray = [[NSMutableArray alloc]init];
            for (int i = 0; i<tempArray.count; i++) {
                dic = tempArray[i];
                finance = [[NewFinance alloc]init];
                finance.id =[dic valueForKey:@"id"];
                finance.img =[dic valueForKey:@"img"];
                finance.src =[dic valueForKey:@"src"];
                finance.url =[dic valueForKey:@"url"];
                finance.read =[dic valueForKey:@"read"];
                finance.share =[dic valueForKey:@"share"];
                finance.title =[dic valueForKey:@"title"];
                finance.content =[dic valueForKey:@"content"];
                finance.create_datetime =[dic valueForKey:@"create_datetime"];
                
                [dataArray addObject:finance];
                //保存
                [finance save];
            }
            
            if (isRefresh) {
                self.dataArray = dataArray;
            }else{
                if (!self.dataArray) {
                    self.dataArray = dataArray;
                }
                [self.dataArray addObjectsFromArray:dataArray];
                [self.tableView reloadData];
            }

            
            NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
            [dataStore setValue:nil forKey:@"NewFinialCount"];
            [dataStore setValue:@"true" forKey:@"IsNewFinialUpdate"];
            [dataStore setValue:[TDUtil CurrentDay] forKey:@"NewFinialUpdateTime"];
            [self.tabBarItem setBadgeValue:nil];
            
        }else{
            UIView * view =[UIApplication sharedApplication].windows[0];
            [[DialogUtil sharedInstance]showDlg:view textOnly:[jsonDic valueForKey:@"msg"]];
        }
        if (isRefresh) {
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        
        self.tableView.content = [jsonDic valueForKey:@"msg"];
        
        
        if (self.isNetRequestError) {
//            self.isNetRequestError = NO;
        }
        
        self.startLoading = NO;
    }else{
        self.isNetRequestError = YES;
    }
    
}

//
//-(void)requestUserInfo:(ASIHTTPRequest *)request{
//    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
//    NSLog(@"返回:%@",jsonString);
//    
//    [[DialogUtil sharedInstance]showDlg:self.view textOnly:jsonString];
//}

-(void)requestNewsTagData:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0 || [code intValue] ==2) {
            NSMutableArray* array = [jsonDic valueForKey:@"data"];
            
            if (array && array.count>0) {
                NewsTag* newstagModel = [[NewsTag alloc]init];
                //移除数据
                [newstagModel deleteData];
                
                NSMutableArray* dataArray  =[[NSMutableArray alloc]init];
                
                for (int i = 0; i<array.count; i++) {
                    NewsTag* newtag = [[NewsTag alloc]init];
                    newtag.title = [array[i] valueForKey:@"value"];
                    newtag.id = [array[i] valueForKey:@"key"];
                    
                    [dataArray addObject:newtag];
                    //保存数据
                    [newtag save];
                }
            }
            
            //添加监听
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewMessage:) name:@"updateMessageStatus" object:nil];
            
            [self updateNewMessage:nil];
            
            selectedIndex = 0;
            [self loadNewsData:selectedIndex];
            
            //重新设置加载动画
            [self resetLoadingView];
            
            //移除重新加载数据监听
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
        }else if ([code intValue] ==-1){
            //添加重新加载数据监听
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"reloadData" object:nil];
            //通知系统重新登录
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
        }
        
    }else{
        self.isNetRequestError  =YES;
    }
    
}

-(void)updateNewMessage:(NSDictionary*)dic
{
    NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
    NSInteger newMessageCount = [[dataStore valueForKey:@"NewMessageCount"] integerValue];
    NSInteger systemMessageCount = [[dataStore valueForKey:@"SystemMessageCount"] integerValue];
    if (newMessageCount+systemMessageCount>0) {
        [self.navView setIsHasNewMessage:YES];
    }
    
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    self.startLoading = YES;
    self.isNetRequestError = YES;
}


//=============================网络请求区域结束==============================//
- (void)viewDidAppear:(BOOL)animated
{
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (!self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
    }
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
