//
//  TimeLineViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "TimeLineViewController.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "TDUtil.h"
#import "TypeShow.h"
#import "HttpUtils.h"
#import "MJRefresh.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "SwitchSelect.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "INSViewController.h"
#import "ASIFormDataRequest.h"
#import "NewFinialTableViewCell.h"
#import "HomeTabBarViewController.h"
#import "BannerViewController.h"

@interface TimeLineViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate>
{
    BOOL isRefresh;
    int selectedIndex;
    int currentpage;
    HttpUtils* httpUtils;
    TypeShow* typeShow;
    LoadingView* loadingView;
}

@end

@implementation TimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    httpUtils = [[HttpUtils alloc]init];
    
    //TabBarItem 设置
    UIImage* image=IMAGENAMED(@"btn-quanzi-cheng");
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setSelectedImage:image];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorTheme,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=0;
    [self.navView setTitle:@"金指投"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:IMAGENAMED(@"top-caidan") forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(userInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navView.rightButton setImage:IMAGENAMED(@"sousuobai") forState:UIControlStateNormal];
    [self.navView.rightButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.navView];
    //头部
    [self loadNewsTag];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInteractionEnabled:) name:@"userInteractionEnabled" object:nil];
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
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)refreshProject
{
    isRefresh =YES;
    currentpage = 0;
    switch (selectedIndex) {
        case 0:
            [self loadNewsData];
            break;
        case 1:
            [self loadFinialData];
            break;
        default:
            [self loadNewsData];
            break;
    }
    
}

-(void)loadProject
{
    isRefresh =NO;
    if (!self.isEndOfPageSize) {
        currentpage++;
        switch (selectedIndex) {
            case 0:
                [self loadNewsData];
                break;
            case 1:
                [self loadFinialData];
                break;
            default:
                [self loadNewsData];
                break;
        }
        
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
-(void)loadNewsData
{
    
    //添加加载页面
    if (isRefresh) {
        loadingView.isTransparent = YES;
        [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    }
    
    
    NSString* str = [KNOWLEDGE stringByAppendingFormat:@"%d/",currentpage];
    [httpUtils getDataFromAPIWithOps:str postParam:nil type:0 delegate:self sel:@selector(requestNewsData:)];
    
}

-(void)loadNewsTag
{
    isRefresh = YES;
    //添加加载页面
    loadingView = [LoadingUtil shareinstance:self.view];
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    
    //添加加载页面
    [httpUtils getDataFromAPIWithOps:KNOWLEDGE_TAG postParam:nil type:0 delegate:self sel:@selector(requestNewsTagData:)];
}

-(void)loadFinialData
{
    if (isRefresh) {
        loadingView.isTransparent = YES;
    }
    [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    
    NSString* str = [MY_FINIAL_PROJECT stringByAppendingFormat:@"%d/",currentpage];
    [httpUtils getDataFromAPIWithOps:str postParam:nil type:0 delegate:self sel:@selector(requestFinalData:)];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BannerViewController* controller =[[BannerViewController alloc]init];
    controller.title = self.navView.title;
    NSDictionary* dic  = self.dataCreateArray[indexPath.row];
    NSURL* url = [NSURL URLWithString:[dic valueForKey:@"href"]];
    controller.type = 3;
    controller.url = url;
    controller.dic = dic;
    [self.navigationController pushViewController:controller animated:YES];
    NSString* serverUrl = [NEWS_READ_COUNT stringByAppendingFormat:@"%@/",[dic valueForKey:@"id"]];
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:0 sel:nil];
}


-(void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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
    NSURL* url = [dic valueForKey:@"src"];
    [cell.imgview sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading")];
    cell.titleLabel.text = [dic valueForKey:@"title"];
    cell.desclabel.text = [dic valueForKey:@"source"];
    cell.typeLabel.text = [dic valueForKey:@"content"];
    cell.colletcteLabel.text = [[dic valueForKey:@"like"] stringValue];
    cell.priseLabel.text = [[dic valueForKey:@"readcount"] stringValue];
    cell.backgroundColor = WriteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    tableView.contentSize = CGSizeMake(WIDTH(tableView), 150*self.dataCreateArray.count+80);
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedIndex == 0) {
        self.tableView.isNone = NO;
        return self.dataCreateArray.count;
    }else{
        return self.dataFinialArray.count;
    }
}

- (void) viewWillAppear: (BOOL)inAnimated {
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
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

-(void)setDataFinialArray:(NSMutableArray *)dataFinialArray
{
    self->_dataFinialArray = dataFinialArray;
    if (self.dataFinialArray.count<=0) {
        self.tableView.isNone = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else{
        self.tableView.isNone = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [self.tableView reloadData];
}

-(void)requestNewsData:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] ==-1) {
            if (isRefresh) {
                self.dataCreateArray = [jsonDic valueForKey:@"data"];
            }else{
                if (!self.dataCreateArray) {
                    self.dataCreateArray = [jsonDic valueForKey:@"data"];
                }
                [self.dataCreateArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                [self.tableView reloadData];
            }
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        }
        if (isRefresh) {
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        
        self.tableView.content = [jsonDic valueForKey:@"msg"];
        
        //关闭加载视图
        [LoadingUtil closeLoadingView:loadingView];
    }
}


-(void)requestNewsTagData:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] ==-1) {
            NSMutableArray* array = [jsonDic valueForKey:@"data"];
            
            NSMutableArray* dataArray = [[NSMutableArray alloc]init];
            
            if (array && array.count>0) {
                
                NSMutableDictionary* dic;
                for (int i=0; i<array.count; i++) {
                    dic = [[NSMutableDictionary alloc]init];
                    [dic setValue:array[i] forKey:@"name"];
                    if(i==0){
                        [dic setValue:@"Yes" forKey:@"isSelected"];
                    }
                    [dataArray addObject:dic];
                }
                
                
                typeShow = [[TypeShow alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), 50) data:dataArray];
                [self.view addSubview:typeShow];
            }
        }
        
        CGRect rect;
        if (typeShow) {
            rect=CGRectMake(0, POS_Y(typeShow), WIDTH(self.view), HEIGHT(self.view)-HEIGHT(self.navView));
        }else{
            rect=CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-HEIGHT(self.navView));
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
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [self.tableView removeFromSuperview];
        [self.view addSubview:self.tableView];
        
        [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
        
        
        
        [self loadNewsData];
        
    }
}




-(void)requestFinalData:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] ==-1) {
            if (isRefresh) {
                self.dataFinialArray = [jsonDic valueForKey:@"data"];
            }else{
                if (!self.dataFinialArray) {
                    self.dataFinialArray = [jsonDic valueForKey:@"data"];
                }
                [self.dataFinialArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                [self.tableView reloadData];
            }
            
        }
        if (isRefresh) {
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
        //关闭加载视图
        [LoadingUtil closeLoadingView:loadingView];
        self.tableView.content = [jsonDic valueForKey:@"msg"];
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    
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
