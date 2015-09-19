//
//  FinalViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinalViewController.h"
#import "Cell.h"
#import "TDUtil.h"
#import "NavView.h"
#import "HttpUtils.h"
#import "MJRefresh.h"
#import "LineLayout.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "LoadingView.h"
#import "LoadingUtil.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "INSViewController.h"
#import "ASIFormDataRequest.h"
#import "VoteViewController.h"
#import "ThinkTankViewController.h"
#import "RoadShowDetailViewController.h"

@interface FinalViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ASIHTTPRequestDelegate>
{
    NavView* navView;
    HttpUtils* httpUtils;
    LoadingView* loadingView;
    
    BOOL isRefresh;
    int currentPage;
    int currentSelectIndex;
    BOOL isResetPosition;
    NSString* _identify;
    NSMutableArray* currentArray;
}
@property (nonatomic,assign)BOOL isEndOfPageSize;
@end
@implementation FinalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    //设置背景颜色
    self.view.backgroundColor=ColorTheme;
    
    //初始化网络对象
    httpUtils = [[HttpUtils alloc]init];
    //TabBarItem 设置
    UIImage* image=IMAGENAMED(@"btn_tourongzi_selected");
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setSelectedImage:image];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorTheme,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=0;
    [navView setTitle:@"金指投"];
    navView.titleLable.textColor=WriteColor;
    [navView.leftButton setImage:IMAGENAMED(@"top-caidan") forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(userInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [navView.rightButton setImage:IMAGENAMED(@"sousuobai") forState:UIControlStateNormal];
    [navView.rightButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:navView];
    
    self.finalContentTableView = [[UITableViewCustomView alloc]initWithFrame:CGRectMake(51, POS_Y(navView), WIDTH(self.view)-50, HEIGHT(self.view)-POS_Y(navView)-kBottomBarHeight-85)];
    self.finalContentTableView.backgroundColor  =WriteColor;
    [self.view addSubview:self.finalContentTableView];
    
    
    self.finalFunTableView.tag=100001;
    self.finalContentTableView.tag=100002;
    self.finalFunTableView.delegate=self;
    self.finalContentTableView.delegate=self;
    self.finalFunTableView.dataSource=self;
    self.finalContentTableView.dataSource=self;
    self.finalFunTableView.backgroundColor=BackColor;
    self.finalContentTableView.backgroundColor=BackColor;
    self.finalFunTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.finalContentTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    float h =HEIGHT(self.finalFunTableView)/10;
    self.finalFunTableView.contentInset = UIEdgeInsetsMake(h, 0, 0, 0);
    
    [TDUtil tableView:self.finalContentTableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    [self addObserver];
    //加载左侧菜单
    [self loadMenuData];
    //加载数据
    [self loadWaitFinaceData];
    
    loadingView = [LoadingUtil shareinstance:self.view];
    currentSelectIndex = 0;
    loadingView.isTransparent = NO;
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInteractionEnabled:) name:@"userInteractionEnabled" object:nil];
   
    
}


-(void)userInteractionEnabled:(NSDictionary*)dic

{
    
    BOOL isUserInteractionEnabled = [[[dic valueForKey:@"userInfo"] valueForKey:@"userInteractionEnabled"] boolValue];
    
    self.view.userInteractionEnabled = isUserInteractionEnabled;
    
}

-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    switch (currentSelectIndex) {
        case 0:
            [self loadWaitFinaceData];
            break;
        case 1:
            [self loadFinishData];
            break;
        case 2:
            [self loadThinkTank];
            break;
        case 3:
            [self loadRecommendproject];
            break;
        default:
            break;
    }
    
}

-(void)loadProject
{
    isRefresh =NO;
    if (!self.isEndOfPageSize) {
        currentPage++;
        switch (currentSelectIndex) {
            case 0:
                [self loadWaitFinaceData];
                break;
            case 1:
                [self loadFinishData];
                break;
            case 2:
                [self loadThinkTank];
                break;
            case 3:
                [self loadRecommendproject];
                break;
            default:
                break;
        }
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"已加载全部"];
        [self.collectionView.footer endRefreshing];
        isRefresh =NO;
    }
}

-(void)loadMenuData
{
    NSMutableArray* dataArray=[NSMutableArray arrayWithObjects:@"融资中",@"已融资",@"智囊团",@"金推荐",nil];
    self.array=dataArray;
    
}
-(void)loadWaitFinaceData
{
    loadingView.isTransparent = YES;
    [LoadingUtil showLoadingView:self.finalContentTableView withLoadingView:loadingView];
    NSString* url = [WAIT_FINACE stringByAppendingFormat:@"%d/",currentPage];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestWaitFinaceList:)];
}

-(void)loadFinishData
{
    loadingView.isTransparent = YES;
    [LoadingUtil showLoadingView:self.finalContentTableView withLoadingView:loadingView];
    NSString* url = [FINISHED_FINACE stringByAppendingFormat:@"%d/",currentPage];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestFinishedFinaceList:)];
}

-(void)loadThinkTank
{
    loadingView.isTransparent = YES;
    [LoadingUtil showLoadingView:self.finalContentTableView withLoadingView:loadingView];
    NSString* url = [THINKTANK stringByAppendingFormat:@"%d/",currentPage];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestThinkTankFinaceList:)];
}

-(void)loadRecommendproject
{
    loadingView.isTransparent = YES;
    [LoadingUtil showLoadingView:self.finalContentTableView withLoadingView:loadingView];
    NSString* url = [RECOMMEND_PROJECT stringByAppendingFormat:@"%d/",currentPage];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestRecommendFinaceList:)];
}

-(void)loadProjectDetail:(NSMutableDictionary*)dic
{
    RoadShowDetailViewController* controller = [[RoadShowDetailViewController alloc]init];
    controller.dic = dic;
    controller.type=1;
    controller.title = navView.title;
    [self.navigationController pushViewController:controller animated:YES];
    
}

-(void)addObserver
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(vote:) name:@"vote" object:nil];
    
}


-(void)setArray:(NSMutableArray *)array
{
    self->_array = array;
    [self.finalFunTableView reloadData];
}
-(void)userInfoAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil];
}


-(void)searchAction:(id)sender
{
    INSViewController* controller =[[INSViewController alloc]init];
    controller.title = navView.title;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)vote:(id)sender
{
    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    VoteViewController *controller = [story instantiateViewControllerWithIdentifier:@"Vote"];
    controller.projectId = 11;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (tableView.tag==100001) {
        FinalKindTableViewCell* Cell=(FinalKindTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        Cell.isSelected=YES;
        
        NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
        
        //获取第一行
        FinalKindTableViewCell* cellRowAtFirst=(FinalKindTableViewCell*)[tableView cellForRowAtIndexPath:path];
        if (cellRowAtFirst.isSelected && indexPath.row!=0) {
            cellRowAtFirst.isSelected =NO;
        }
        
        currentPage = 0;
        currentSelectIndex=(int)row;
        switch (row) {
            case 0:
                if (!self.waitFinialDataArray) {
                    [self loadWaitFinaceData];
                }else{
                    loadingView.isTransparent = YES;
                     [LoadingUtil showLoadingView:self.finalContentTableView withLoadingView:loadingView];
                    currentArray = self.waitFinialDataArray;
                    [self.finalContentTableView reloadData];
                }
                break;
            case 1:
                if (!self.finishedFinialDataArray) {
                    currentArray = self.waitFinialDataArray;
                    [self.finalContentTableView reloadData];
                }else{
                    isRefresh = YES;
                    [self loadFinishData];
                    [self.finalContentTableView reloadData];
                }
                break;
            case 2:
                if (!self.thinkTankFinialDataArray) {
                    [self loadThinkTank];
                }else{
                    currentArray = self.thinkTankFinialDataArray;
                    [self.collectionView reloadData];
                }
                break;
            case 3:
                if (!self.recommendFinialDataArray) {
                    [self loadRecommendproject];
                }else{
                    currentArray = self.recommendFinialDataArray;
                    [self.finalContentTableView reloadData];
                }
                break;
            default:
                if (!self.waitFinialDataArray) {
                    [self loadWaitFinaceData];
                }else{
                    currentArray = self.waitFinialDataArray;
                    [self.finalContentTableView reloadData];
                }
                break;
        }
        if (row!=2) {
            [self LinerLayout:NO];
        }else{
            [self LinerLayout:YES];
        }
        
    }else{
        //此处获取项目id
        [self loadProjectDetail:currentArray[row]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag!=100001) {
        return 190;
    }
    return 60;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==100001) {
        FinalKindTableViewCell* Cell=(FinalKindTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        Cell.isSelected=NO;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==100001) {
        return 4;
    }
    if (currentArray.count==0) {
        self.finalContentTableView.isNone =YES;
    }else{
        self.finalContentTableView.isNone =NO;
    }
    return currentArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==100001) {
        static NSString *CustomCellIdentifier = @"CustomCellIdentifier";
        FinalKindTableViewCell *Cell =(FinalKindTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
        if (!Cell) {
            Cell =(FinalKindTableViewCell*)[[FinalKindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
        }
        
        if (indexPath.row==0) {
            Cell.isSelected=YES;
        }
        Cell.lblFunName.text=self.array[indexPath.row];
        Cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return Cell;
        
    }else{
        static NSString *reuseIdetify = @"FinialListView";
        FinalContentTableViewCell *cellInstance = (FinalContentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdetify];
        if (!cellInstance) {
            cellInstance = [[FinalContentTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.finalContentTableView), 190)];
        }
        NSInteger row = indexPath.row;
        NSDictionary* dic = currentArray[row];
        NSURL* url = [NSURL URLWithString:[dic valueForKey:@"thumbnail"]];
        [cellInstance.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading")];
        cellInstance.title = [dic valueForKey:@"company_name"];
        NSMutableArray* arry  =[dic valueForKey:@"industry_type"];
        cellInstance.content = [dic valueForKey:@"project_summary"];
        cellInstance.priseData = [[dic valueForKey:@"like_sum"] integerValue];
        cellInstance.voteData = [[dic valueForKey:@"vote_sum"] integerValue];
        cellInstance.collectionData = [[dic valueForKey:@"collect_sum"] integerValue];
        
        NSString* str=@"";
        for (int i = 0; i< arry.count; i++) {
            str = [str stringByAppendingFormat:@"%@/",arry[i]];
        }
        
        cellInstance.typeDescription = str;
        cellInstance.selectionStyle=UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cellInstance;
    }
    
}


-(void)LinerLayout:(BOOL)flag
{
    if (flag) {
        if (!self.collectionView) {
            //图片浏览
            LineLayout * layOut=[[LineLayout alloc]init];
            layOut.lineSpacing=50;
            layOut.direction=0;
            layOut.size=CGSizeMake(220, 300);
            self.collectionView = [[UICollectionView alloc]initWithFrame:self.finalContentTableView.frame collectionViewLayout:layOut];
            self.collectionView.tag =100003;
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
            self.collectionView.backgroundColor =BackColor;
            
            //注册单元格
            _identify = @"PhotoCell";
            [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:_identify];
            
            [TDUtil collectView:self.collectionView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
        }
        
        [self.view addSubview:self.collectionView];
        
        //移除tableView
        //UITableView* tableView = (UITableView*)[self.view viewWithTag:100002];
        //        if (tableView) {
        //            [self.finalContentTableView removeFromSuperview];
        //        }
        
    }else{
        if (self.collectionView) {
            UICollectionView* collectionView = (UICollectionView*)[self.view viewWithTag:100003];
            if(collectionView){
                [self.collectionView removeFromSuperview];
            }
            
            //            UITableView* tableView = (UITableView*)[self.view viewWithTag:100002];
            //            if (!tableView) {
            //                [self.view addSubview:self.finalContentTableView];
            //                [self.finalContentTableView reloadData];
            //            }
            
        }
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    if (currentArray.count==0) {
        self.finalContentTableView.isNone =YES;
    }else{
        self.finalContentTableView.isNone =NO;
    }
    return currentArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:_identify forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    NSDictionary* dic = currentArray[row];
    NSURL* url = [dic valueForKey:@"img"];
    
    cell.title = [dic valueForKey:@"name"];
    cell.desc = [dic valueForKey:@"title"];
    [cell.imageView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember")];
    
    if (row>0 && !isResetPosition) {
        NSIndexPath* index = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
        isResetPosition = YES;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic = currentArray[indexPath.row];
    
    ThinkTankViewController * controller  = [[ThinkTankViewController alloc ]init];
    controller.dic = dic;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        
    }
}


-(void)setWaitFinialDataArray:(NSMutableArray *)waitFinialDataArray
{
    self->_waitFinialDataArray  = waitFinialDataArray;
    currentArray = self.waitFinialDataArray;
    [self.finalContentTableView reloadData];
}

-(void)setFinishedFinialDataArray:(NSMutableArray *)finishedFinialDataArray
{
    self->_finishedFinialDataArray = finishedFinialDataArray;
    currentArray = self.finishedFinialDataArray;
    [self.finalContentTableView reloadData];
}

-(void)setThinkTankFinialDataArray:(NSMutableArray *)thinkTankFinialDataArray
{
    self->_thinkTankFinialDataArray = thinkTankFinialDataArray;
    currentArray = self.thinkTankFinialDataArray;
    [self.collectionView reloadData];
}

-(void)setRecommendFinialDataArray:(NSMutableArray *)recommendFinialDataArray
{
    self->_recommendFinialDataArray = recommendFinialDataArray;
    currentArray = self.recommendFinialDataArray;
    [self.finalContentTableView reloadData];
}
#pragma ASIHttpRequest
//待融资
-(void)requestWaitFinaceList:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString* status =[jsonDic valueForKey:@"status"];
        if([status intValue] == 0 || [status intValue] ==-1){
            if (isRefresh) {
                self.finishedFinialDataArray = [jsonDic valueForKey:@"data"];
            }else{
                if (self.finishedFinialDataArray) {
                    [self.finishedFinialDataArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                    [self.finalContentTableView reloadData];
                }else{
                    self.finishedFinialDataArray = [jsonDic valueForKey:@"data"];
                }
            }
        }
        [LoadingUtil closeLoadingView:loadingView];
        if (isRefresh) {
            [self.finalContentTableView.header endRefreshing];
        }else{
            [self.finalContentTableView.footer endRefreshing];
        }
        self.finalContentTableView.content = [jsonDic valueForKey:@"msg"];
    }
}

//已融资
-(void)requestFinishedFinaceList:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString* status =[jsonDic valueForKey:@"status"];
        if([status intValue] == 0 || [status intValue] ==-1){
            if (isRefresh) {
                self.finishedFinialDataArray = [jsonDic valueForKey:@"data"];
            }else{
                if (self.finishedFinialDataArray) {
                    [self.finishedFinialDataArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                    [self.finalContentTableView reloadData];
                }else{
                    self.finishedFinialDataArray = [jsonDic valueForKey:@"data"];
                }
               
            }
        }
        [LoadingUtil closeLoadingView:loadingView];
        if (isRefresh) {
            [self.finalContentTableView.header endRefreshing];
        }else{
            [self.finalContentTableView.footer endRefreshing];
        }
self.finalContentTableView.content = [jsonDic valueForKey:@"msg"];
    }
}
//智囊团
-(void)requestThinkTankFinaceList:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString* status =[jsonDic valueForKey:@"status"];
        if([status intValue] == 0 || [status intValue] ==-1){
            if (isRefresh) {
                self.thinkTankFinialDataArray = [jsonDic valueForKey:@"data"];
            }else{
                if (self.thinkTankFinialDataArray) {
                    [self.thinkTankFinialDataArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                    [self.collectionView reloadData];
                }else{
                    self.thinkTankFinialDataArray = [jsonDic valueForKey:@"data"];
                }
                
            }
        }
        [LoadingUtil closeLoadingView:loadingView];
        if (isRefresh) {
            [self.collectionView.header endRefreshing];
        }else{
            [self.collectionView.footer endRefreshing];
        }
        
self.finalContentTableView.content = [jsonDic valueForKey:@"msg"];
    }
}
//平台推荐
-(void)requestRecommendFinaceList:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString* status =[jsonDic valueForKey:@"status"];
        if([status intValue] == 0 || [status intValue] ==-1){
            if (isRefresh) {
                self.recommendFinialDataArray = [jsonDic valueForKey:@"data"];
            }else{
                if (self.recommendFinialDataArray) {
                    [self.recommendFinialDataArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                    [self.finalContentTableView reloadData];
                }else{
                    self.recommendFinialDataArray = [jsonDic valueForKey:@"data"];
                }
                
            }
        }
        [LoadingUtil closeLoadingView:loadingView];
        if (isRefresh) {
            [self.finalContentTableView.header endRefreshing];
        }else{
            [self.finalContentTableView.footer endRefreshing];
        }
        self.finalContentTableView.content = [jsonDic valueForKey:@"msg"];

    }
}
//项目详情
-(void)requestProjectDetail:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            
        }
        self.finalContentTableView.content = [jsonDic valueForKey:@"msg"];
        
        [LoadingUtil closeLoadingView:loadingView];
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        if (isRefresh) {
            [self.finalContentTableView.header endRefreshing];
        }else{
            [self.finalContentTableView.footer endRefreshing];
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
