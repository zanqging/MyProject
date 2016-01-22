//
//  MasterViewController.m
//  SwipeableTableCell
//
//  Created by Ellen Shapiro on 1/5/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//

#import "MasterViewController.h"
#import "ReplyView.h"
#import "MJRefresh.h"
#import "SwipeableCell.h"
#import "WeiboViewControlle.h"
#import "SystemSwipableCell.h"
#import "BannerViewController.h"
#import "UserTraceViewController.h"
#import "RoadShowDetailViewController.h"

@interface MasterViewController () <SwipeableCellDelegate,UITableViewDataSource,UITextViewDelegate,UITableViewDelegate,ReplyDelegate,SystemSwipableCellDelegate> {
    BOOL isRefresh;
    int currentPage;
    
    NSString* atTopId;
    NSInteger rowCount;
    
    ReplyView* replyView;
    SwipeableCell* currentCell;
}
@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    [self.navView removeFromSuperview];
    self.navView = nil;
    
    self.tableView = [[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)-100)];
     [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BackColor;
    [self.view addSubview:self.tableView];
    //1
    self.cellsCurrentlyEditing = [NSMutableArray array];
    self.loadingViewFrame = self.tableView.frame;
    rowCount = 0;
    [self refreshProject];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    [self.tableView.header endRefreshing];
    
    if (self.type==0) {
        NSString * url = [MY_TOPIC_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
        [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
        self.startLoading = YES;
    }else{
        NSString * url = [MY_SYSTEM_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
        [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
    }
    
}

-(void)loadProject
{
    isRefresh =NO;
    if (self.type==0) {
        //消息回复
        if (!self.isEndOfPageSize) {
            currentPage++;
            NSString * url = [MY_TOPIC_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
            [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
        }else{
            [self.tableView.footer endRefreshing];
            isRefresh =NO;
        }
        
    }else{
        if (!self.isEndOfPageSize) {
            currentPage++;
            NSString * url = [MY_SYSTEM_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
            [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
        }else{
            [self.tableView.footer endRefreshing];
            isRefresh =NO;
        }
    }
    [self.tableView.footer endRefreshing];
}

-(void)setRead:(NSInteger)index
{
    NSString* serverUrl;
    if (self.type==0) {
        serverUrl= [settopicread stringByAppendingFormat:@"%ld/",index];
        [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestReadFinished:)];
    }
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row  = indexPath.row;
    NSDictionary* dic  =self.dataArray[row];
    NSString* content =[dic valueForKey:@"content"];
    
    NSInteger lenght = [TDUtil convertToInt:content];
    NSInteger lines = lenght / 16;
    if (lines<=0) {
        lines = 1;
    }
    float height = lines *20;
    return height+50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row  = indexPath.row;
    NSDictionary* dic  =self.dataArray[row];
    if (self.type==0) {
        SwipeableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        [cell.titleLabel setText: [dic valueForKey:@"name"]];
        NSURL* url = [NSURL URLWithString:[dic valueForKey:@"photo"]];
        [cell.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember")];
        [cell setItemText:[dic valueForKey:@"content"]];
        cell.delegate = self;
        cell.dic = dic;
        
        if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
            [cell openCell];
        }
        return cell;
    }else{
        SystemSwipableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemCell" forIndexPath:indexPath];
        [cell.titleLabel setText: [dic valueForKey:@"create_datetime"]];
        [cell setItemText:[dic valueForKey:@"content"]];
        cell.delegate = self;
        cell.dic = dic;
        [cell layout];
        if ([self.cellsCurrentlyEditing containsObject:indexPath]) {
            [cell openCell];
        }
        return cell;
    }
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //1
        [self.dataArray removeObjectAtIndex:indexPath.row];
        
        //2
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        //3
    }
}

#pragma mark - SwipeableCellDelegate
- (void)buttonOneActionForItem:(NSDictionary*)dic swipCell:(id)swipCell
{
    NSString* serverUrl;
    if (self.type==0) {
        serverUrl= [settopicread stringByAppendingFormat:@"%@/",[dic valueForKey:@"id"]];
    }else{
        serverUrl= [deletemsgread stringByAppendingFormat:@"%@/",[dic valueForKey:@"id"]];
    }
    
    currentCell = swipCell;
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestFinished:)];
}

- (void)buttonTwoActionForItem:(NSDictionary*)dic swipCell:(id)swipCell
{
    if (!replyView) {
        replyView = [[ReplyView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
        replyView.delegate = self;
    }
    //重置布局
    [replyView resetLayout];
    
    atTopId = [dic valueForKey:@"id"];
    self.project_id =[[dic valueForKey:@"pid"] integerValue];
    
    currentCell = swipCell;
    [self.view addSubview:replyView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemSwipableCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.type!=0) {
        NSDictionary* dic = cell.dic;
        NSString* serverUrl= [setsysteminform stringByAppendingFormat:@"%@/",[dic valueForKey:@"id"]];
        [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestReadFinished:)];
        
        [self notification:dic];
    }else{
        WeiboViewControlle* controller = [[WeiboViewControlle alloc]init];
        NSDictionary* dic = cell.dic;
        controller.titleStr = @"消息回复";
        controller.project_id = [[dic valueForKey:@"pid"] integerValue];
        [self.navigationController pushViewController:controller animated:YES];
        
        [self setRead:[[dic valueForKey:@"id"] integerValue]];
    }
}
-(void)replyView:(id)replyView text:(NSString *)text
{
    
    if ([TDUtil isValidString:text]) {
        NSString* url  =[TOPIC stringByAppendingFormat:@"%ld/",(long)self.project_id];
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
- (void)cellDidOpen:(UITableViewCell *)cell
{
    NSIndexPath *currentEditingIndexPath = [self.tableView indexPathForCell:cell];
    [self.cellsCurrentlyEditing addObject:currentEditingIndexPath];
}

- (void)cellDidClose:(UITableViewCell *)cell
{
    [self.cellsCurrentlyEditing removeObject:[self.tableView indexPathForCell:cell]];
}

-(void)notification:(NSDictionary*)dic
{
    dic =[dic valueForKey:@"extras"];
    NSString* type = [dic valueForKey:@"api"];
    
    int index=-1;
    NSString* str;
    for (int i=0; i<ROMATE_MSG_TYPE.count; i++) {
        str=[ROMATE_MSG_TYPE valueForKey:[NSString stringWithFormat:@"%d",i]];
        if ([str isEqualToString:type]) {
            index = i;
        }
    }
    
    if (index!=-1) {
        switch (index) {
            case 0:
                [self loadProjectDetail:[[dic valueForKey:@"_id"] integerValue]];
                break;
            case 1:
//                [self loadMsgDetail:[[dic valueForKey:@"_id"] integerValue]];
                break;
            case 2:
//                [self loadSystemMsgDetail:[[dic valueForKey:@"_id"] integerValue]];
                break;
            case 3:
                [self loadWebViewDetail:[NSURL URLWithString:[dic valueForKey:@"url"]]];
                break;
            case 4:
                [self loadWebViewDetail:[NSURL URLWithString:[dic valueForKey:@"url"]]];
                break;
            case 5:
                [self loadWebViewDetail:[NSURL URLWithString:[dic valueForKey:@"url"]]];
                break;
            case 6:
                [self loadTraceInfo:1000];
                break;
            case 7:
                [self loadTraceInfo:1001];
                break;
            case 8:
                [self loadTraceInfo:1002];
                break;
            default:
                break;
        }
    }
    
    
}

////为了MPMoviePlayerViewController保持横平
//- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
//{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}



-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self resetLoadingView];
}
-(void)loadProjectDetail:(NSInteger)index
{
    RoadShowDetailViewController* controller = [[RoadShowDetailViewController alloc]init];
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld",(long)index] forKey:@"id"];
    controller.type=1;
//    Project* project = [[Project alloc]init];
//    project = [[Project alloc]init];
//    project.imgUrl = [dic valueForKey:@"img"];
//    project.tag = [dic valueForKey:@"tag"];
//    project.company = [dic valueForKey:@"company"];
//    project.projectId = [[dic valueForKey:@"id"] integerValue];
//    project.invest = [NSString stringWithFormat:@"%@",[dic valueForKey:@"invest"]];
//    project.planfinance = [NSString stringWithFormat:@"%@",[dic valueForKey:@"planfinance"]];
    
    controller.dic = dic;

    controller.title = @"系统通知";
    [self.navigationController pushViewController:controller animated:YES];
}

//-(void)loadMsgDetail:(NSInteger)index
//{
//    UIStoryboard* storyBorard =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    MasterViewController* controller =(MasterViewController*)[storyBorard instantiateViewControllerWithIdentifier:@"SystemMessage"];
//    controller.type=0;
//    controller.titleStr = @"消息回复";
//    [self.navigationController pushViewController:controller animated:YES];
//}
//
//-(void)loadSystemMsgDetail:(NSInteger)index
//{
//    UIStoryboard* storyBorard =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    MasterViewController* controller =(MasterViewController*)[storyBorard instantiateViewControllerWithIdentifier:@"SystemMessage"];
//    controller.type=1;
//    controller.titleStr = @"系统通知";
//    [self.navigationController pushViewController:controller animated:YES];
//}

-(void)loadTraceInfo:(NSInteger)index
{
    UserTraceViewController* controller =[[UserTraceViewController alloc]init];
    controller.currentSelected =index;
    controller.titleStr = @"系统通知";
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)loadWebViewDetail:(NSURL*)url
{
    BannerViewController* controller = [[BannerViewController alloc]init];
    // NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",index] forKey:@"id"];
    controller.titleStr = @"消息推送";
    controller.title = @"系统通知";
    controller.type = 3;
    controller.url = url;
    [self.navigationController pushViewController:controller animated:YES];
}

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
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        [self refreshProject];
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"系统错误!"];
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
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
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
        
        if (currentCell) {
            [currentCell closeCell];
        }
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        
        self.startLoading=NO;
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"系统错误!"];
    }
    
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
@end
