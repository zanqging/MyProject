//
//  ActionDetailViewController.m
//  Cycle
//
//  Created by air on 15/10/14.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "ActionDetailViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "MJRefresh.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "DAKeyboardControl.h"
#import <QuartzCore/QuartzCore.h>
#define  TEXT_VIEW_HEIGHT  30
@interface ActionDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate, ActionHeaderDeleaget,UITextViewDelegate>
{
    BOOL isRefresh;
    int currentPage;
    float toolBarHeight;
    UIButton *sendButton;
    
    NSInteger conId;
    NSInteger atConId;
    HttpUtils* httpUtils;
    UITextView* textView;
    ActionHeader* headerView;
}
@property(retain,nonatomic)UIToolbar *toolBar;
@end

@implementation ActionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    self.title = @"圈子";
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"全文详情"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.title forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];


    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-kTopBarHeight-kStatusBarHeight)];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.backgroundColor=WriteColor;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.contentSize = CGSizeMake(WIDTH(self.view), HEIGHT(self.view)+220);
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.view addSubview:self.tableView];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    if (self.dic) {
        headerView = [[ActionHeader alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 10)];
        headerView.delegate = self;
        headerView.dic = self.dic;
        [self.tableView setTableHeaderView:headerView];
    }
    
    
    self.classStringName = @"CyclePriseTableViewCell";
    httpUtils = [[HttpUtils alloc]init];
    self.selectIndex = 1;
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     self.view.bounds.size.height,
                                                                     self.view.bounds.size.width,
                                                                     40.0f)];
    self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.toolBar];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f,
                                                              6.0f,
                                                              self.toolBar.bounds.size.width - 20.0f - 68.0f,
                                                              30.0f)];
    textView.delegate = self;
    textView.layer.cornerRadius = 5;
    textView.layer.borderWidth = 1;
    textView.delegate  =self;
    textView.layer.borderColor = FONT_COLOR_GRAY.CGColor;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.toolBar addSubview:textView];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [sendButton setTitle:@"回复" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.frame = CGRectMake(self.toolBar.bounds.size.width - 68.0f,
                                  6.0f,
                                  58.0f,
                                  29.0f);
    [self.toolBar addSubview:sendButton];
    
    __block ActionDetailViewController* blockSelf = self;
    self.view.keyboardTriggerOffset = self.toolBar.bounds.size.height;
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = blockSelf.toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        blockSelf.toolBar.frame = toolBarFrame;
    } constraintBasedActionHandler:nil];
    if (!self.projectId) {
        [self loadData];
    }else{
        NSString* serverUrl = [PUBLISH_CONTENT_DETAIL stringByAppendingFormat:@"%@/",self.projectId];
        if (!httpUtils) {
            httpUtils= [[HttpUtils alloc]init];
        }
        [httpUtils getDataFromAPIWithOps:serverUrl type:0 delegate:self sel:@selector(requestPublishData:) method:@"GET"];
        
        self.selectIndex = 2;
    }
}

-(void)loadData
{
    switch (self.selectIndex) {
        case 1:
            [self loadPriseListData];
            break;
        case 2:
            [self loadCommentListData];
            break;
            
        default:
            break;
    }
}

-(void)setProjectId:(NSString *)projectId
{
    self->_projectId = projectId;
}

-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    [self loadData];
    
}

-(void)loadProject
{
    isRefresh =NO;
    if (!self.isEndOfPageSize) {
        currentPage++;
        [self loadData];
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"已加载全部"];
        isRefresh =NO;
    }
}

-(void)loadPriseListData
{
    NSString* str;
    if (self.dic) {
        str =[self.dic valueForKey:@"id"];
    }else{
        str =self.projectId;
    }
    NSString* serverUrl = [CYCLE_CONTENT_PRISE_LIST stringByAppendingFormat:@"%@/%d/",str,0];
    [httpUtils getDataFromAPIWithOps:serverUrl type:0 delegate:self sel:@selector(requestPriseList:) method:@"GET"];
}

-(void)loadShareListData
{
    
}

-(void)loadCommentListData
{
    NSString* serverUrl = [CYCLE_CONTENT_COMMENT_LIST stringByAppendingFormat:@"%@/%d/",[self.dic valueForKey:@"id"],0];
    [httpUtils getDataFromAPIWithOps:serverUrl type:0 delegate:self sel:@selector(requestPriseList:) method:@"GET"];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic = self.dataArray[indexPath.row];
    if ([[dic valueForKey:@"flag"]boolValue]) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alertView.tag  = [[dic valueForKey:@"id"] integerValue];
        alertView.delegate = self;
        [alertView show];
    }else{
        atConId  = [[dic valueForKey:@"id"] integerValue];
        conId  =[[self.dic valueForKey:@"id"] integerValue];
        [textView becomeFirstResponder];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 100;
    switch (self.selectIndex) {
        case 1:
            height = 50;
            break;
        case 2:
            height = 60;
            break;
        case 3:
            height = 60;
            break;
        default:
            height = 70;
            break;
    }
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"UserInfoViewCell";
    if([self.classStringName isEqualToString:@"CyclePriseTableViewCell"])
    {
        CyclePriseTableViewCell* cell;
        //用TableDataIdentifier标记重用单元格
        cell =[[NSClassFromString(self.classStringName)alloc]init];
        cell=[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
        //如果单元格未创建，则需要新建
        if (cell==nil) {
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            cell = [[NSClassFromString(self.classStringName)alloc]initWithFrame:CGRectMake(0, 0, WIDTH(tableView), height)];
        }
        
        NSDictionary* dic = self.dataArray[indexPath.row];
        cell.dic = dic;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }else{
        CycleShareTableViewCell* cell;
        //用TableDataIdentifier标记重用单元格
        cell =[[NSClassFromString(self.classStringName)alloc]init];
        cell=[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
        //如果单元格未创建，则需要新建
        if (cell==nil) {
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            cell = [[NSClassFromString(self.classStringName)alloc]initWithFrame:CGRectMake(0, 0, WIDTH(tableView), height)];
        }
        
        NSDictionary* dic = self.dataArray[indexPath.row];
        cell.dic = dic;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        return cell;
    }


    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataArray count];
}


-(void)setClassStringName:(NSString *)classStringName
{
    self->_classStringName = classStringName;
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    self->_selectIndex  =selectIndex;

}

-(void)setDataArray:(NSMutableArray *)dataArray{
    self->_dataArray = dataArray;
    
    if ([self.dataArray count]) {
        [self.tableView reloadData];
    }
}

-(BOOL)commentAction:(id)sender
{
    NSString* content = textView.text;
    if ([content isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入回复内容"];
        return false;
    }
    
    [textView resignFirstResponder];
    if(!httpUtils){
        httpUtils = [[HttpUtils alloc]init];
    }
    NSString* serverUrl = [CYCLE_CONTENT_REPLY stringByAppendingFormat:@"%ld/",conId];
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:[NSDictionary dictionaryWithObjectsAndKeys:content,@"content",[NSString stringWithFormat:@"%ld",atConId],@"at", nil] type:0 delegate:self sel:@selector(requestReply:)];
    return true;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (!httpUtils) {
            httpUtils = [[HttpUtils alloc]init];
        }
        NSString* serverUrl = [CYCLE_CONTENT_REPLY_DELETE stringByAppendingFormat:@"%ld/",alertView.tag];
        [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestDeleteReplyFinished:)];
    }
}


-(void)actionHeader:(id)header selectedIndex:(NSInteger)selectedIndex className:(NSString *)className
{
    self.classStringName = className;
    if (self.selectIndex != selectedIndex) {
        self.selectIndex = selectedIndex;
        [self loadData];
    }
}

-(void)actionHeader:(id)header data:(NSDictionary*)data prise:(BOOL)priseFlag
{
    if (data) {
        if (priseFlag) {
            [self.dataArray addObject:data];
        }else{
            [data setValue:nil forKey:@"flag"];
            for (NSDictionary* d in self.dataArray) {
                if ([[d valueForKey:@"uid"] integerValue] == [[data valueForKey:@"uid"] integerValue]) {
                    [self.dataArray removeObject:d];
                    
                }
            }
        }
    }
    
    [self.tableView reloadData];
}

-(void)actionHeader:(id)header data:(NSDictionary *)data critical:(BOOL)criticalFlag
{
    atConId  = [[data valueForKey:@"at_uid"] integerValue];
    conId  =[[self.dic valueForKey:@"id"] integerValue];
    
    [textView becomeFirstResponder];
}

-(void)textViewDidChange:(UITextView *)tv
{
    CGFloat height = textView.contentSize.height;
    if (toolBarHeight != height) {
        NSLog(@"%f",height);
        if (toolBarHeight!=0) {
            CGRect toolBarFrame = self.toolBar.frame;
            NSLog(@"%@",NSStringFromCGRect(toolBarFrame));
            toolBarFrame.origin.y -=(height-toolBarHeight);
            toolBarFrame.size.height+=(height-toolBarHeight);
            
            [self.toolBar setFrame:toolBarFrame];
            
            sendButton.frame = CGRectMake(self.toolBar.bounds.size.width - 68.0f,
                                          HEIGHT(self.toolBar)/2-15,
                                          58.0f,
                                          29.0f);
        }
        toolBarHeight=height;
    }
}

-(void)textViewDidChangeSelection:(UITextView *)tv
{
    //    NSLog(@"-----%@",tv.text);
}

#pragma ASIHttpRequest
-(void)requestPublishData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue] == 0 || [status integerValue] == -1) {
            self.dic = [dic valueForKey:@"data"];
            
            //[[DialogUtil sharedInstance]showDlg:self.view textOnly:@"内容获取成功!"];
            if (self.dic) {
                headerView = [[ActionHeader alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 10)];
                headerView.delegate = self;
                headerView.dic = self.dic;
                [self.tableView setTableHeaderView:headerView];
                
                //列表
                if (self.selectIndex==1) {
                    self.dataArray = [self.dic valueForKey:@"like"];
                }else{
                    self.dataArray = [self.dic valueForKey:@"comment"];
                }
            }
        }
        
        if (isRefresh) {
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
    }
}
-(void)requestPriseList:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue] == 0 || [status integerValue] == -1) {
            self.dataArray = [dic valueForKey:@"data"];
        }
        
        if (isRefresh) {
            [self.tableView.header endRefreshing];
        }else{
            [self.tableView.footer endRefreshing];
        }
    }
}
-(void)requestReply:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue] ==0) {
            //currentSelectedCell.dic = [dic valueForKey:@"data"];
//            NSIndexPath* indexPath = [self.tableView indexPathForCell:currentSelectedCell];
//            NSDictionary* dataDic = self.dataArray[indexPath.row];
//            NSMutableArray* array =[dataDic  valueForKey:@"comment"];
//            NSDictionary* dicTemp = [dic valueForKey:@"data"];
//            [array insertObject:dicTemp atIndex:0];
//            self.dataArray[indexPath.row] = dataDic;
//            [self.tableView reloadData];
            [self loadCommentListData];
        }
        //[[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
    }
}
-(void)requestDeleteReplyFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
//            NSDictionary* tempDic =self.dataArray[currentSelectedCellIndex.row];
//            if ([self.dataArray containsObject:tempDic]) {
//                [self.dataArray removeObject:tempDic];
//            }
            [self loadCommentListData];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}

@end
