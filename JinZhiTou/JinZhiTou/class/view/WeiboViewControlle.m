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
    
    NSString * phoneNumber;
    UIWebView * webView;
    UITextView *textView;
    
    NSMutableArray * _images;  //测试用
    NSMutableArray * _contents;
}

@end

@implementation WeiboViewControlle
@synthesize weiboData,replyData,superView,deleteWeibo=_deleteWeibo;




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
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    
    self.tableView = [[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView)-20)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        toolBar.frame = toolBarFrame;
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showyboard:) name:@"showKeyboard" object:nil];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddeKeyboard:)]];
    _first=NO;
    
    httpUtils = [[HttpUtils alloc]init];
    loadingView = [LoadingUtil shareinstance:self.view];
    
    
    [self loadData];
    
}

-(void)showyboard:(id)sender
{
    [textView becomeFirstResponder];
}

-(void)hiddeKeyboard:(id)sender
{
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
}
-(void)submmit:(id)sender
{
    NSString* url  =[TOPIC stringByAppendingFormat:@"%ld/",(long)self.project_id];
    NSMutableDictionary* dic  =[[NSMutableDictionary alloc]init];
    [dic setValue:textView.text forKey:@"content"];
    [dic setValue:@"8" forKey:@"at_topic"];
    
    [httpUtils getDataFromAPIWithOps:url postParam:dic type:0 delegate:self sel:@selector(requestSubmmit:)];
}
-(void)loadData
{
    if (isRefresh) {
        loadingView.isTransparent  =YES;
    }else{
        loadingView.isTransparent  =NO;
    }
    [LoadingUtil show:loadingView];
    NSString* url = [REPLYLIST stringByAppendingFormat:@"%ld/%d/",(long)self.project_id,currentPage];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestReplyData:)];
}

-(void)refreshData:(id)sender
{
    
}

-(void)loadData:(id)sender
{
    
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int count=[self.dataArray count];
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboData * weibo=[_datas objectAtIndex:indexPath.row];
    WeiboCell *cell = nil;
    static NSString *CellIdentifier = @"WeiboCell";
    cell = (WeiboCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        cell = [[WeiboCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), height)];
    }
    // Configure the cell...
    cell.controller=self;
    [cell setCellContent:weibo];
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
    

    [cell.logo sd_setImageWithURL:[dic valueForKey:@"img"] placeholderImage:IMAGENAMED(@"coremember")];
    
    cell.title.text = [dic valueForKey:@"name"];
    cell.time.text = [dic valueForKey:@"create_datetime"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboData * data=[_datas objectAtIndex:indexPath.row];
    return [WeiboCell getHeightByContent:data];
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



#pragma -mark 回调方法

-(void)coreLabel:(HBCoreLabel*)coreLabel linkClick:(NSString*)linkStr
{

}
-(void)coreLabel:(HBCoreLabel *)coreLabel phoneClick:(NSString *)linkStr
{
    UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打电话",nil, nil];
    action.tag=102;
    phoneNumber=linkStr;
    [action showInView:self.view.window];
}
-(void)coreLabel:(HBCoreLabel *)coreLabel mobieClick:(NSString *)linkStr
{
    UIActionSheet * action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打电话",@"发短信",nil, nil];
    action.tag=103;
    phoneNumber=linkStr;
    [action showInView:self.view.window];
}






-(void)loadWeboData:(NSArray*)webos complete:(void(^)())complete formDb:(BOOL)fromDb
{
    for(WeiboData * weibo in webos){
        weibo.match=nil;
        [weibo setMatch];
        weibo.uploadFailed=NO;
        [weibo getWeiboReplysByType:1];
        weibo.linesLimit=YES;
        weibo.replyHeight=[WeiboCell heightForReply:weibo.replys];
    }
    NSMutableArray * ary=nil;
    if(fromDb&&[_datas count]==0){
        ary=[[NSMutableArray alloc]init];
        //
    }else{
        if(!_first){
            ary=[NSMutableArray arrayWithArray:_datas];
        }else{
            ary=[[NSMutableArray alloc]init];
        }
    }
    if (!fromDb) {
        int count=[webos count];
        for (int i=0; i<count; i++) {
            WeiboData * webo=[webos objectAtIndex:i];
            BOOL has=NO;
            for (WeiboData * data in _datas) {
                if (data.msgId.intValue==webo.msgId.intValue&&!data.local) {
                    if(_first){
                        [data setMatch];
                        [ary addObject:data];
                    }
                    has=YES;
                    break;
                }
            }
            if (!has) {
                 [ary addObject:webo];
            }
        }
         _first=NO;
    }else{
        [ary addObjectsFromArray:webos];
    }
//    [ary sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        WeiboData *  weibo1=(WeiboData *)obj1;
//        WeiboData *  weibo2=(WeiboData *)obj2;
//        if(weibo1.msgId.intValue>weibo2.msgId.intValue){
//            return NSOrderedAscending;
//        }else if(weibo1.msgId.intValue<weibo2.msgId.intValue){
//            return NSOrderedDescending;
//        }else{
//            return NSOrderedSame;
//        }
//    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        _datas=ary;
        _lastId=((WeiboData*)[webos lastObject]).msgId.intValue;
        [self.tableView reloadData];
        [LoadingUtil close:loadingView];
        if(complete){
            complete();
        }
    });
}

- (void)loadWeboData:(NSArray *) webos {
    [self loadWeboData:webos complete:nil formDb:NO];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==102){
        if(0==buttonIndex){
            NSString * string=[NSString stringWithFormat:@"tel:%@",phoneNumber];
            if(webView==nil)
                webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
            webView.hidden=YES;
            [self.view addSubview:webView];
        }
    }else if (actionSheet.tag==103){
        if(0==buttonIndex){
            NSString * string=[NSString stringWithFormat:@"tel:%@",phoneNumber];
            if(webView==nil)
                webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
            webView.hidden=YES;
            [self.view addSubview:webView];
        }else if(1==buttonIndex){
            
        }
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
            [LoadingUtil close:loadingView];
            [self loadFromDb:YES];
            self.dataArray = [jsonDic valueForKey:@"data"];
            
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
        }else{
            NSLog(@"请求失败!");
        }
    }
}


-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    loadingView.isError = YES;
    loadingView.content = @"网络请求失败!";
}

// 从本地加载数据  update : 加载结束之后是否需要从后台更新数据， 第一次进入时需要更新。
-(void)loadFromDb:(BOOL)update
{
    static int msgId=0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray * array=[[NSMutableArray alloc]init];
        for (int i=0; i<_contents.count; i++) {
            WeiboData * data=[[WeiboData alloc]init];
            data.content=[_contents objectAtIndex:(msgId%_contents.count)];
            data.msgId=[NSString stringWithFormat:@"%d",msgId++];
            [array addObject:data];
        }
        [self loadWeboData:array complete:nil formDb:YES];
    });
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
