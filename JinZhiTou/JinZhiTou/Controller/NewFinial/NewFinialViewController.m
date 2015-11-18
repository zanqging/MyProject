//
//  NewFinialViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "NewFinialViewController.h"
#import "TypeShow.h"
#import "ShareView.h"
#import "MJRefresh.h"
#import "SwitchSelect.h"
#import "INSViewController.h"
#import "NewFinialTableViewCell.h"
#import "HomeTabBarViewController.h"
#import "UserInfoConfigController.h"
@interface NewFinialViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate,TypeShowDelegate>
{
    BOOL isRefresh;
    int currentpage;
    
    TypeShow* typeShow;
    
    NSInteger selectedIndex;
}

@end

@implementation NewFinialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    
    //TabBarItem 设置
    UIImage* image=IMAGENAMED(@"xinsanban-cheng");
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setSelectedImage:image];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorTheme,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    //设置标题
    [self.navView setTitle:@"金指投"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:IMAGENAMED(@"shuruphone") forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction:)]];
    
    [self.navView.rightButton setImage:IMAGENAMED(@"sousuobai") forState:UIControlStateNormal];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction:)]];
    [self.view addSubview:self.navView];
    //头部
    [self loadNewsTag];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInteractionEnabled:) name:@"userInteractionEnabled" object:nil];
    
    //开始加载
    self.startLoading  =YES;
    
//    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc]init];
//    [dataDic setValue:@"陈生珠" forKey:@"name"];
//    [dataDic setValue:@"632223199011260314" forKey:@"idno"];
//    [dataDic setValue:@"他家的" forKey:@"company"];
//    [dataDic setValue:@"会计" forKey:@"position"];
//    [dataDic setValue:@"陕西 西安" forKey:@"addr"];
//    [self.httpUtil getDataFromAPIWithOps:@"userinfo/" postParam:dataDic type:0 delegate:self sel:@selector(requestUserInfo:)];
    
//        NSMutableDictionary* dataDic = [[NSMutableDictionary alloc]init];
//        [dataDic setValue:@"1,2,13" forKey:@"qualification"];
//        [dataDic setValue:@"北京金指投信息科技有限公司" forKey:@"institute"];
//        [dataDic setValue:@"他家的" forKey:@"legalperson"];
//        [self.httpUtil getDataFromAPIWithOps:@"auth/" postParam:dataDic type:0 delegate:self sel:@selector(requestUserInfo:)];
    
   
    
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
    
    NSMutableArray* array = [[NSMutableArray alloc]init];
    NSMutableArray* tempArray = [[NSMutableArray alloc]init];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    int num=0;
    for (int i=0; i<typeShow.dataArray.count; i++) {
        
        if (num>=3) {
            num = 0;
            dic = [[NSMutableDictionary alloc]init];
            [dic setValue:array forKey:@"data"];
            [tempArray addObject:dic];
            array = [[NSMutableArray alloc]init];
            
        }
        
        
        [array addObject:typeShow.dataArray[i]];
        
        if (i==typeShow.dataArray.count -1) {
            if (array.count>0) {
                dic = [[NSMutableDictionary alloc]init];
                [dic setValue:array forKey:@"data"];
                [tempArray addObject:dic];
                array = [[NSMutableArray alloc]init];
            }
        }
        
        num++;
        
    }
    
    controller.dataArray = tempArray;
    controller.type=1;
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)loadProject
{
    isRefresh =NO;
    if (!self.isEndOfPageSize) {
        currentpage++;
        [self loadNewsData:selectedIndex];
        
    }else{
        [self.tableView.footer endRefreshing];
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"已加载全部内容"];
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
    //[httpUtils getDataFromAPIWithOps:str postParam:nil type:0 delegate:self sel:@selector(requestNewsData:)];
    [self.httpUtil getDataFromAPIWithOps:str type:0 delegate:self sel:@selector(requestNewsData:) method:@"GET"];
}

-(void)loadNewsTag
{
    isRefresh = YES;
    //添加加载页面
//    [self.httpUtil getDataFromAPIWithOps:NEWS_TYPE postParam:nil type:0 delegate:self sel:@selector(requestNewsTagData:)];
    [self.httpUtil getDataFromAPIWithOps:NEWS_TYPE type:0 delegate:self sel:@selector(requestNewsTagData:) method:@"GET"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.webViewController){
        self.webViewController =[[BannerViewController alloc]init];
        self.webViewController.title = self.navView.title;
    }
    NSDictionary* dic  = self.dataCreateArray[indexPath.row];
    NSURL* url = [NSURL URLWithString:[dic valueForKey:@"url"]];
    self.webViewController.type = 3;
    self.webViewController.url = url;
    self.webViewController.dic = dic;
    [self.navigationController pushViewController:self.webViewController animated:YES];
    NSString* serverUrl = [NEWS_READ_COUNT stringByAppendingFormat:@"%@/",[dic valueForKey:@"id"]];
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
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
    
    NSDictionary* dic = self.dataCreateArray[indexPath.row];
    NSURL* url = [dic valueForKey:@"img"];
    cell.backgroundColor = BackColor;
    [cell.imgview sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading")];
    cell.titleLabel.text = [dic valueForKey:@"title"];
    cell.desclabel.text = [dic valueForKey:@"src"];
    cell.typeLabel.text = [dic valueForKey:@"content"];
    cell.timeLabel.text = [dic valueForKey:@"create_datetime"];
    cell.colletcteLabel.text = [[dic valueForKey:@"share"] stringValue];
    cell.priseLabel.text = [[dic valueForKey:@"read"] stringValue];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentSize = CGSizeMake(WIDTH(tableView), 150*self.dataCreateArray.count+80);
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.isNone = NO;
    return self.dataCreateArray.count;
}

-(void)typeShow:(TypeShow *)typeShow selectedIndex:(NSInteger)index didSelectedString:(NSString *)resultString
{
    isRefresh = YES;
    currentpage = 0;
    selectedIndex = index;
    [self loadNewsData:selectedIndex];
}


-(void)setDataCreateArray:(NSMutableArray *)dataCreateArray
{
    self->_dataCreateArray = dataCreateArray;
    if (self.dataCreateArray.count<=0) {
        self.tableView.isNone = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.isNone = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [self.tableView reloadData];
}
//==============================刷新功能区域开始==============================//
-(void)refresh
{
    [super refresh];
    currentpage = 0;
    isRefresh  = YES;
    [self loadNewsData:selectedIndex];
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
            }else{
                if (isRefresh) {
                    self.dataCreateArray = [jsonDic valueForKey:@"data"];
                }else{
                    if (!self.dataCreateArray) {
                        self.dataCreateArray = [jsonDic valueForKey:@"data"];
                    }
                    [self.dataCreateArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                    [self.tableView reloadData];
                }
            }
            
            NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
            [dataStore setValue:nil forKey:@"NewFinialCount"];
            [dataStore setValue:@"true" forKey:@"IsNewFinialUpdate"];
            [dataStore setValue:[TDUtil CurrentDay] forKey:@"NewFinialUpdateTime"];
            [self.tabBarItem setBadgeValue:nil];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        }
        if (isRefresh) {
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        
        self.tableView.content = [jsonDic valueForKey:@"msg"];
        
        self.startLoading = NO;
        if (self.isNetRequestError) {
            self.isNetRequestError = NO;
        }
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
        if ([code intValue] == 0 || [code intValue] ==-1) {
            NSMutableArray* array = [jsonDic valueForKey:@"data"];
            
            if (array && array.count>0) {
                
                
                typeShow = [[TypeShow alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), 50) data:array];
                typeShow.delegate = self;
                [self.view addSubview:typeShow];
            }
        }
        
        CGRect rect;
        if (typeShow) {
            rect=CGRectMake(0, POS_Y(typeShow), WIDTH(self.view), HEIGHT(self.view)-HEIGHT(self.navView)-kBottomBarHeight);
        }else{
            rect=CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-HEIGHT(self.navView)-kBottomBarHeight);
        }
        self.tableView=[[UITableViewCustomView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
        self.tableView.bounces=YES;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.allowsSelection=YES;
        self.tableView.delaysContentTouches=NO;
        self.tableView.showsVerticalScrollIndicator=NO;
        self.tableView.showsHorizontalScrollIndicator=NO;
        self.tableView.backgroundColor=BackColor;
        self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.tableView removeFromSuperview];
        [self.view addSubview:self.tableView];
        [self.view sendSubviewToBack:self.tableView];
        
        [TDUtil tableView:self.tableView target:self refreshAction:@selector(refresh) loadAction:@selector(loadProject)];
        
        NSInteger  index =[[typeShow.dataArray[0] valueForKey:@"key"] integerValue];
        
        selectedIndex = index;
        [self loadNewsData:index];
        
        //添加监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewMessage:) name:@"updateMessageStatus" object:nil];
        
        
        [self updateNewMessage:nil];
        
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
