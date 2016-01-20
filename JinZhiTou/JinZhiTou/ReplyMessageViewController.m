//
//  ViewController.m
//  AGTableViewCell
//
//  Created by Agenric on 15/9/22.
//  Copyright (c) 2015年 Agenric. All rights reserved.
//

#import "ReplyMessageViewController.h"
#import "TDUtil.h"
#import "ReplyView.h"
#import "MJRefresh.h"
#import "ASIFormDataRequest.h"
#import "WeiboViewControlle.h"
#import "SystemSwipableCell.h"
#import "UIView+SDAutoLayout.h"
#import "BannerViewController.h"
#import "UserTraceViewController.h"
#import "RoadShowDetailViewController.h"
@interface ReplyMessageViewController ()<AGTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate,ReplyDelegate>
{
    BOOL isRefresh;
    int currentPage;
    
    NSString* atTopId;
    NSInteger rowCount;
    NSInteger project_id;
    
    ReplyView* replyView;
}
@end

@implementation ReplyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //1.初始化
    self.tableView = [[UITableViewCustomView alloc]init];
    
    //2.设置属性
    UIView *view = [UIView new];
    [view setBackgroundColor:[UIColor clearColor]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.canCancelContentTouches = NO;
    [self.tableView setTableFooterView:view];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    //3.添加到视图
    [self.view addSubview:self.tableView];
    //3.自适应
    self.tableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0,90, 0));
    
    
    //重新设置加载视图
    self.loadingViewFrame = CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view) - 100);
    //加载数据
    [self refreshProject];
}

-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    [self.tableView.header endRefreshing];
    
    //加载数据
    NSString * url = [MY_TOPIC_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
    if (!self.dataArray) {
        self.startLoading = YES;
    }
    
}

-(void)loadProject
{
    isRefresh =NO;
    //消息回复
    currentPage++;
    NSString * url = [MY_TOPIC_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
    [self.tableView.footer endRefreshing];
}

-(void)setRead:(NSInteger)index
{
    NSString* serverUrl;
    serverUrl= [settopicread stringByAppendingFormat:@"%ld/",index];
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestReadFinished:)];
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray  = dataArray;
    if (self.dataArray.count>0) {
        [self.tableView setIsNone:NO];
        rowCount  =self.dataArray.count;
    }else{
        [self.tableView setIsNone:YES];
        [self.tableView setContent:@"暂无数据"];
    }
    [self.tableView reloadData];
}


-(void)refresh
{
    [super refresh];
    //重新加载数据
    [self refreshProject];
}

#pragma mark -
#pragma mark UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
//    //    NSLog(@"%ld-->%f",indexPath.row,h);
//    return h;
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AGTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    WeiboViewControlle* controller = [[WeiboViewControlle alloc]init];
    NSDictionary* dic = cell.dic;
    controller.titleStr = @"消息回复";
    controller.project_id = [[dic valueForKey:@"pid"] integerValue];
    [self.navigationController pushViewController:controller animated:YES];
    
    [self setRead:[[dic valueForKey:@"id"] integerValue]];
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



#pragma mark -
#pragma mark UITableView Datasources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return self.dataArray.count;
}

- (AGTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"myIdentifier";
    AGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AGTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier inTableView:self.tableView];
        cell.delegate = self;
    }
    
    cell.dic = [self.dataArray objectAtIndex:indexPath.row];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


#pragma mark - AGTableViewCellDelegate
- (NSArray *)AGTableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    AGTableViewRowAction *action1 = [[AGTableViewRowAction alloc] initWithTitle:@"更多" backgroundColor:[UIColor lightGrayColor] index:0];
//    AGTableViewRowAction *action2 = [[AGTableViewRowAction alloc] initWithTitle:@"旗标" backgroundColor:[UIColor orangeColor] index:1];
//    AGTableViewRowAction *action3 = [[AGTableViewRowAction alloc] initWithTitle:@"删除" backgroundColor:[UIColor redColor] index:2];

    return [AGTableViewRowAction actionsWithTitles:@[@"回复",@"删除"] backgroundColors:@[[UIColor redColor],[UIColor orangeColor]]];
}


- (void)AGTableView:(UITableView *)tableView didSelectActionIndex:(NSInteger)index forRowAtIndexPath:(NSIndexPath *)indexPath {
    AGTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary * dic = cell.dic;
    switch (index) {
        case 0:
            [self buttonTwoActionForItem:dic swipCell:cell];
            break;
        case 1:
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            
            [self buttonOneActionForItem:dic swipCell:cell];
            break;
        default:
            break;
    }
}

/**
 *  删除消息
 *
 *  @param dic      字典数据
 *  @param swipCell 当前单元格Cell
 */
- (void)buttonOneActionForItem:(NSDictionary*)dic swipCell:(id)swipCell
{
    NSString* serverUrl;
    serverUrl= [settopicread stringByAppendingFormat:@"%@/",[dic valueForKey:@"id"]];
    
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestFinished:)];
}

/**
 *  消息回复
 *
 *  @param dic      字典数据
 *  @param swipCell 当前单元格Cell
 */
- (void)buttonTwoActionForItem:(NSDictionary*)dic swipCell:(id)swipCell
{
    if (!replyView) {
        replyView = [[ReplyView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
        replyView.delegate = self;
    }
    //重置布局
    [replyView resetLayout];
    
    atTopId = [dic valueForKey:@"id"];
    project_id =[[dic valueForKey:@"pid"] integerValue];
    [self.view addSubview:replyView];
}
#pragma ReplyDelegate
-(void)replyView:(id)replyView text:(NSString *)text
{
    if ([TDUtil isValidString:text]) {
        NSString* url  =[TOPIC stringByAppendingFormat:@"%ld/",(long)project_id];
        NSMutableDictionary* dic  =[[NSMutableDictionary alloc]init];
        [dic setValue:text forKey:@"content"];
        [dic setValue:atTopId forKey:@"at"];
        
        [self.httpUtil getDataFromAPIWithOps:url postParam:dic type:0 delegate:self sel:@selector(requestSubmmit:)];
        self.startLoading = YES;
        self.isTransparent=YES;
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请先输入内容"];
    }
}



#pragma ASIHttpRequester

-(void)requestFinished:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateStatus" object:nil];
        }
        UIView * view = [UIApplication sharedApplication].windows[0];
        [[DialogUtil sharedInstance]showDlg:view textOnly:[jsonDic valueForKey:@"msg"]];
        [self refreshProject];
    }else{
        UIView * view = [UIApplication sharedApplication].windows[0];
        [[DialogUtil sharedInstance]showDlg:view textOnly:@"系统错误!"];
    }
}

-(void)requestReadFinished:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateStatus" object:nil];
        }
    }
}

-(void)requestTopicList:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0 || [code intValue] == 2) {
            if (isRefresh) {
                self.dataArray =nil;
                self.dataArray = [jsonDic valueForKey:@"data"];
            }else{
                if (!self.dataArray) {
                    self.dataArray = [jsonDic valueForKey:@"data"];
                }else{
                    [self.dataArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                    [self.tableView reloadData];
                }
            }
            
            //移除重新加载数据监听
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
        }else if ([code intValue] == -1){
            //添加监听
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshProject) name:@"reloadData" object:nil];
            //通知重新加载数据
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
        }else{
            self.isNetRequestError =YES;
        }
        
        //设置全部为阅读状态
        if (currentPage!=0) {
            UIView * view = [UIApplication sharedApplication].windows[0];
            [[DialogUtil sharedInstance]showDlg:view textOnly:[jsonDic valueForKey:@"msg"]];
        }
        self.startLoading = NO;
    }
}

-(void)requestSubmmit:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            self.isNetRequestError =NO;
            self.tableView.content = [jsonDic valueForKey:@"msg"];
            currentPage = 0;
        }
        
        //清空数据
        replyView.textView.text = @"";
        [replyView removeFromSuperview];
        
        UIView * view = [UIApplication sharedApplication].windows[0];
        [[DialogUtil sharedInstance]showDlg:view textOnly:[jsonDic valueForKey:@"msg"]];
        
        self.startLoading=NO;
    }else{
        UIView * view = [UIApplication sharedApplication].windows[0];
        [[DialogUtil sharedInstance]showDlg:view textOnly:@"系统错误!"];
    }
    
}

@end
