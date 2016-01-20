//
//  WeiboViewControlle.m
//  wq
//
//  Created by weqia on 13-8-28.
//  Copyright (c) 2013年 Weqia. All rights reserved.
//

#import "WeiboViewControlle.h"
#import "JSONKit.h"
#import "TDUtil.h"
#import "MJRefresh.h"
#import "WeiboCell.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "ReplyViewController.h"
#import "ReplyView.h"
@interface WeiboViewControlle ()<UITextViewDelegate,WeiboDeleget,ReplyDelegate>
{
    BOOL _first;
    int _lastId;
    BOOL isRefresh;
    int currentPage;
    
    NSString* atTopId;
    UIWebView * webView;
    NSString * phoneNumber;
    
    NSMutableArray * _images;  //测试用
    NSMutableArray * _contents;
    
    ReplyView* replyView;
}

@end

@implementation WeiboViewControlle




-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor  =ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"评论"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.titleStr forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.navView.rightButton setImage:IMAGENAMED(@"fapiao") forState:UIControlStateNormal];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(critical:)]];
    
    
    self.tableView = [[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView)-kBottomBarHeight-40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshData:) loadAction:@selector(loadData:)];
    _first=YES;
    
    
    isRefresh = YES;
    [self loadData];
}

-(void)submmit:(NSString*)text
{
    NSString* str = text;
    
    if ([TDUtil isValidString:str]) {
        NSString* url  =[TOPIC stringByAppendingFormat:@"%ld/",(long)self.project_id];
        NSMutableDictionary* dic  =[[NSMutableDictionary alloc]init];
        [dic setValue:str forKey:@"content"];
        [dic setValue:atTopId forKey:@"at"];
        
        [self.httpUtil getDataFromAPIWithOps:url postParam:dic type:0 delegate:self sel:@selector(requestSubmmit:)];
        self.startLoading = YES;
        self.isTransparent = YES;
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请先输入内容"];
    }
    
}

-(void)loadData
{
    if (!isRefresh) {
        currentPage++;
    }
    if (_first) {
        _first = NO;
        self.startLoading = YES;
    }
    NSString* url = [REPLYLIST stringByAppendingFormat:@"%ld/%d/",(long)self.project_id,currentPage];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestReplyData:)];
}

-(void)refreshData:(id)sender
{
    isRefresh = YES;
    currentPage = 0;
    [self loadData];
}

-(void)loadData:(id)sender
{
    isRefresh = NO;
    if (self.isEndOfPageSize) {
        currentPage = 0;
    }
    [self loadData];
}

-(void)critical:(id)sender
{
    ReplyViewController* controller =[[ReplyViewController alloc]init];
    controller.project_id = self.project_id;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count=[self.dataArray count];
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboCell *cell = nil;
    static NSString *CellIdentifier = @"WeiboCell";
    cell = (WeiboCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        cell = [[WeiboCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), height)];
        cell.delegate = self;
    }
    // Configure the cell...
    cell.controller=self;
    float height=[self tableView:tableView heightForRowAtIndexPath:indexPath];
    UIView * view=[cell.contentView viewWithTag:1200];
    if(view==nil){
        UIImageView * line=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dv_line.png"]];
        
        line.frame=CGRectMake(0, height-1, 320, 1);
        [cell.contentView  addSubview:line];
        line.tag=1200;
    }else{
        view.frame=CGRectMake(0, height-1, 320, 1);
    }
    NSInteger row = indexPath.row;
    NSDictionary* dic =self.dataArray[row];
    

    cell.topicId = [dic valueForKey:@"id"];
    cell.atName = [dic valueForKey:@"at_name"];
    cell.titleStr = [dic valueForKey:@"name"];
    cell.isInvestor = [[dic valueForKey:@"investor"] boolValue];
    [cell.logo sd_setImageWithURL:[dic valueForKey:@"photo"] placeholderImage:IMAGENAMED(@"coremember")];
    cell.time.text = [dic valueForKey:@"date"];
    cell.content =[dic valueForKey:@"content"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray && self.dataArray.count>0) {
        NSInteger row = indexPath.row;
        NSDictionary* dic =self.dataArray[row];
        NSInteger length = [TDUtil convertToInt:[dic valueForKey:@"content"]];
        NSInteger lines = length/16;
        if (lines<0) {
            lines =1;
        }
        CGFloat height = lines*20+100;
        return height;
    }
        return 0;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboData * data=[_datas objectAtIndex:indexPath.row];;
    if (data) {
        data.willDisplay=YES;
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboData * data=[_datas objectAtIndex:indexPath.row];;
    if (data) {
        data.willDisplay=NO;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray.count==0) {
        self.tableView.isNone = YES;
    }else{
        self.tableView.isNone = NO;
        NSDictionary* dic ;
        for (int i =0 ; i<self.dataArray.count; i++) {
            dic  = self.dataArray[i];
        }
        [self.tableView reloadData];
    }
}

-(void)refresh
{
    currentPage = 0;
    isRefresh = YES;
    [self loadData];
}

#pragma WeiboDelegate
-(void)weiboCell:(id)sender replyData:(id)data
{
    if (data) {
        atTopId = [data stringValue];
        if (!replyView) {
            replyView = [[ReplyView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
            replyView.delegate = self;
        }
        //重置布局
        [replyView resetLayout];
        [self.view addSubview:replyView];
    }
}

#pragma ReplyDelegate
-(void)replyView:(id)replyView text:(NSString *)text
{
    [self submmit:text];
}
#pragma ASIHttpquest
//待融资
-(void)requestReplyData:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString* code =[jsonDic valueForKey:@"code"];
        if([code intValue] == 0 || [code intValue] ==2){
            NSMutableArray* dataArray = [jsonDic valueForKey:@"data"];
            _images=[NSMutableArray array];
            _contents=[[NSMutableArray alloc]init];
            NSDictionary* dic ;
            for (int i = 0; i<dataArray.count; i++) {
                dic =dataArray[i];
                [_images addObject:[dic valueForKey:@"photo"]];
                 [_contents addObject:[dic valueForKey:@"content"]];
            }
            
            if ([code integerValue] == 2) {
                self.isEndOfPageSize = YES;
            }
            
            if(isRefresh){
                self.dataArray = [jsonDic valueForKey:@"data"];
            }else{
                if (!self.isEndOfPageSize) {
                    if (!self.dataArray) {
                        self.dataArray = [jsonDic valueForKey:@"data"];
                    }
                    [self.dataArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                    [self.tableView reloadData];                    
                }
            }
            self.startLoading = NO;
        }else{
            self.isNetRequestError = YES;
        }
        self.tableView.content = [jsonDic valueForKey:@"msg"];
    }else{
        self.isNetRequestError = YES;
    }
    
    if (isRefresh) {
        [self.tableView.header endRefreshing];
    }else{
        [self.tableView.footer endRefreshing];
    }
    
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
}

-(void)requestSubmmit:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            self.isNetRequestError = NO;
            self.tableView.content = [jsonDic valueForKey:@"msg"];
            
            currentPage = 0;
            [self loadData];
            [replyView removeFromSuperview];
            [replyView.textView setText:@""];
        }
    }
    self.startLoading = NO;
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
