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
#import "DAKeyboardControl.h"
@interface WeiboViewControlle ()<UITextViewDelegate>
{
    BOOL _first;
    int _lastId;
    BOOL isRefresh;
    int currentPage;
    
    NSString* atTopId;
    UIWebView * webView;
    UITextView *textView;
    NSString * phoneNumber;
    
    NSMutableArray * _images;  //测试用
    NSMutableArray * _contents;
}

@end

@implementation WeiboViewControlle




-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
  
    [super viewDidLoad];
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"评论"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"项目详情" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    
    [self.navView.rightButton setImage:IMAGENAMED(@"fapiao") forState:UIControlStateNormal];
    [self.navView.rightButton addTarget:self action:@selector(critical:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView.backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    
    self.tableView = [[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView)-kBottomBarHeight-70)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshData:) loadAction:@selector(loadData:)];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     self.view.bounds.size.height - 40.0f,
                                                                     self.view.bounds.size.width,
                                                                     40.0f)];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:toolBar];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f,
                                                                           6.0f,
                                                                           toolBar.bounds.size.width - 20.0f - 68.0f,
                                                                           30.0f)];
    textView.delegate =self;
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [toolBar addSubview:textView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [sendButton setTitle:@"发表" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(submmit:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.frame = CGRectMake(toolBar.bounds.size.width - 68.0f,
                                  6.0f,
                                  58.0f,
                                  29.0f);
    [toolBar addSubview:sendButton];
    
    
    self.view.keyboardTriggerOffset = toolBar.bounds.size.height;
    
    [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
        CGRect toolBarFrame = toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        toolBar.frame = toolBarFrame;
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showyboard:) name:@"showKeyboard" object:nil];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddeKeyboard:)]];
    _first=YES;
    
    httpUtils = [[HttpUtils alloc]init];
    loadingView = [LoadingUtil shareinstance:self.view];
    
    isRefresh = YES;
    [self loadData];
    
}

-(void)showyboard:(id)sender
{
    if ([sender isKindOfClass:NSNotification.class]) {
        NSDictionary* dic =  (NSDictionary* )sender;
        atTopId = [[dic valueForKey:@"userInfo"] valueForKey:@"id"];
    }
    [textView becomeFirstResponder];
}

-(void)hiddeKeyboard:(id)sender
{
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
}
-(void)submmit:(NSDictionary* )userInfo
{
    NSString* url  =[TOPIC stringByAppendingFormat:@"%ld/",(long)self.project_id];
    NSMutableDictionary* dic  =[[NSMutableDictionary alloc]init];
    [dic setValue:textView.text forKey:@"content"];
    [dic setValue:atTopId forKey:@"at_topic"];
    
    [httpUtils getDataFromAPIWithOps:url postParam:dic type:0 delegate:self sel:@selector(requestSubmmit:)];
}

-(void)loadData
{
    if (_first) {
        _first = NO;
    }else{
        
        loadingView.isTransparent  =YES;
    }
    if (!isRefresh) {
        currentPage++;
    }
    
    [LoadingUtil show:loadingView];
    NSString* url = [REPLYLIST stringByAppendingFormat:@"%ld/%d/",(long)self.project_id,currentPage];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestReplyData:)];
}

-(void)refreshData:(id)sender
{
    isRefresh = YES;
    if (self.isEndOfPageSize) {
        currentPage = 0;
    }
    [self loadData];
}

-(void)loadData:(id)sender
{
    isRefresh = NO;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    

    cell.titleStr = [dic valueForKey:@"name"];
    cell.isInvestor = [[dic valueForKey:@"investor"] boolValue];
    [cell.logo sd_setImageWithURL:[dic valueForKey:@"img"] placeholderImage:IMAGENAMED(@"coremember")];
    cell.time.text = [dic valueForKey:@"create_datetime"];
    cell.content =[dic valueForKey:@"content"];
    cell.topicId = [dic valueForKey:@"id"];
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
        CGFloat height = lines*20+120;
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

#pragma ASIHttpquest
//待融资
-(void)requestReplyData:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString* status =[jsonDic valueForKey:@"status"];
        if([status intValue] == 0 || [status intValue] ==-1){
            NSMutableArray* dataArray = [jsonDic valueForKey:@"data"];
            _images=[NSMutableArray array];
            _contents=[[NSMutableArray alloc]init];
            NSDictionary* dic ;
            for (int i = 0; i<dataArray.count; i++) {
                dic =dataArray[i];
                [_images addObject:[dic valueForKey:@"img"]];
                 [_contents addObject:[dic valueForKey:@"content"]];
            }
            
            if ([status integerValue] == -1) {
                self.isEndOfPageSize = YES;
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"已加载全部"];
            }
            
            if(isRefresh){
                self.dataArray = [jsonDic valueForKey:@"data"];
            }else{
                if (!self.dataArray) {
                    self.dataArray = [jsonDic valueForKey:@"data"];
                }
                [self.dataArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                [self.tableView reloadData];
            }
            
             [LoadingUtil close:loadingView];
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
        }
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    loadingView.isError = YES;
    loadingView.content = @"网络请求失败!";
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
