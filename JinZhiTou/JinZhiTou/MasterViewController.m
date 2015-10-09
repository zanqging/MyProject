//
//  MasterViewController.m
//  SwipeableTableCell
//
//  Created by Ellen Shapiro on 1/5/14.
//  Copyright (c) 2014 Designated Nerd Software. All rights reserved.
//

#import "MasterViewController.h"
#import "TDUtil.h"
#import "ReplyView.h"
#import "MJRefresh.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "GlobalDefine.h"
#import "SwipeableCell.h"
#import "NSString+SBJSON.h"
#import "SystemSwipableCell.h"

#import "ASIFormDataRequest.h"

@interface MasterViewController () <SwipeableCellDelegate,UITableViewDataSource,UITextViewDelegate,UITableViewDelegate,ReplyDelegate,SystemSwipableCellDelegate> {
    BOOL isRefresh;
    int currentPage;
    
    NSString* atTopId;
    NSInteger rowCount;
    
    HttpUtils* httpUtils;
    ReplyView* replyView;
    LoadingView* loadingView;
    SwipeableCell* currentCell;
}
@property (nonatomic, strong) NSMutableArray *cellsCurrentlyEditing;
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    [self.navigationController.navigationBar setHidden:YES];
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"消息回复"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"与我相关" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    self.navView.title  =self.titleStr;
    [self.view addSubview:self.navView];
    
    [self.tableView setFrame:CGRectMake(0, POS_Y(self.navView)+20, WIDTH(self.tableView), HEIGHT(self.view)-POS_Y(self.navView)-40)];
     [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BackColor;
    //1
    self.cellsCurrentlyEditing = [NSMutableArray array];
    
    rowCount = 0;
    
    httpUtils = [[HttpUtils alloc]init];
    loadingView = [LoadingUtil shareinstance:self.view];
    [LoadingUtil show:loadingView];
    [self.view bringSubviewToFront:loadingView];
    
    [self refreshProject];
}


-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    [self.tableView.header endRefreshing];
    
    if (self.type==0) {
        NSString * url = [MY_TOPIC_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
        [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
    }else{
        NSString * url = [MY_SYSTEM_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
        [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
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
            [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
        }else{
            [self.tableView.footer endRefreshing];
            isRefresh =NO;
        }
        
    }else{
        if (!self.isEndOfPageSize) {
            currentPage++;
            NSString * url = [MY_SYSTEM_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
            [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
        }else{
            [self.tableView.footer endRefreshing];
            isRefresh =NO;
        }
    }
    [self.tableView.footer endRefreshing];
}

-(void)setRead
{
    NSString* serverUrl;
    if (self.type==0) {
        serverUrl= [settopicread stringByAppendingFormat:@"%d/",0];
    }else{
        serverUrl= [setsysteminform stringByAppendingFormat:@"%d/",0];
    }
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestReadFinished:)];
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
        NSURL* url = [NSURL URLWithString:[dic valueForKey:@"img"]];
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
        NSLog(@"Unhandled editing style! %d", editingStyle);
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
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestFinished:)];
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


-(void)replyView:(id)replyView text:(NSString *)text
{
    
    if ([TDUtil isValidString:text]) {
        NSString* url  =[TOPIC stringByAppendingFormat:@"%ld/",(long)self.project_id];
        NSMutableDictionary* dic  =[[NSMutableDictionary alloc]init];
        [dic setValue:text forKey:@"content"];
        [dic setValue:atTopId forKey:@"at_topic"];
        
        [httpUtils getDataFromAPIWithOps:url postParam:dic type:0 delegate:self sel:@selector(requestSubmmit:)];
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
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
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
            [LoadingUtil close:loadingView];
            
            if ([status integerValue]==-1) {
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            }
            
            [self setRead];
        }
    }
}

-(void)requestSubmmit:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            loadingView.isError = NO;
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
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"系统错误!"];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"系统错误!"];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
