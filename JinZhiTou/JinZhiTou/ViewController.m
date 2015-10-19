//
//  ViewController.m
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "ViewController.h"
#import "ActionDetailViewController.h"
#import "GlobalDefine.h"
#import "UConstants.h"
#import "HttpUtils.h"
#import "TDUtil.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "MJRefresh.h"
#import "DialogUtil.h"
#import "NSString+SBJSON.h"
#import "DAKeyboardControl.h"
#import "PublishViewController.h"
#import "UserLookForViewController.h"
@interface ViewController ()<WeiboTableViewCellDelegate>
{
    BOOL isRefresh;
    LoadingView* loadingView;
    NSInteger currentPage;
    HttpUtils* httpUtils;
    UITextField *textField;
    NSString* conId,* atConId;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    
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
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction:)]];
    
    [self.navView.rightButton setImage:IMAGENAMED(@"feed_action_share_normal") forState:UIControlStateNormal];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publishAction:)]];
    [self.view addSubview:self.navView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView)-170)];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:self.tableView];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                     self.view.bounds.size.height - 40.0f,
                                                                     self.view.bounds.size.width,
                                                                     40.0f)];
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:toolBar];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f,
                                                                           6.0f,
                                                                           toolBar.bounds.size.width - 20.0f - 68.0f,
                                                                           30.0f)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [toolBar addSubview:textField];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [sendButton setTitle:@"回复" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.frame = CGRectMake(toolBar.bounds.size.width - 68.0f,
                                  6.0f,
                                  58.0f,
                                  29.0f);
    [toolBar addSubview:sendButton];
    
    
    self.view.keyboardTriggerOffset = toolBar.bounds.size.height;
    __block ViewController* viewSelf = self;
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
//        CGRect toolBarFrame = toolBar.frame;
//        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
//        toolBar.frame = toolBarFrame;
        
//        CGRect tableViewFrame = viewSelf.tableView.frame;
//        tableViewFrame.size.height = toolBarFrame.origin.y;
//        viewSelf.tableView.frame = tableViewFrame;
    } constraintBasedActionHandler:nil];
    
    //网络加载
    httpUtils = [[HttpUtils alloc]init];
    loadingView = [LoadingUtil shareinstance:self.view];
    [LoadingUtil show:loadingView];
    
    [self loadData];
}

-(void)loadData
{
//    NSMutableArray* array = [NSMutableArray new];
//    NSMutableDictionary* dic;
//    for (int i=1; i<=8; i++) {
//        dic = [NSMutableDictionary new];
//        NSMutableArray* imgArray = [NSMutableArray new];
//        for (int j = i; j <=7; j++) {
//            [imgArray addObject:[NSString stringWithFormat:@"%d",j]];
//        }
//        [dic setValue:imgArray forKey:@"imageName"];
//        [array addObject:dic];
//    }
//    self.dataArray = array;
    NSString* serverUrl = [CYCLE_CONTENT_LIST stringByAppendingFormat:@"%ld/",currentPage];
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestData:)];
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

-(void)userInfoAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil];
}

-(void)commentAction:(id)sender
{
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"回复消息"];
    NSString* content = textField.text;
    if(!httpUtils){
        httpUtils = [[HttpUtils alloc]init];
    }
    
    NSString* serverUrl = [CYCLE_CONTENT_REPLY stringByAppendingFormat:@"%@/",conId];
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:[NSDictionary dictionaryWithObjectsAndKeys:content,@"content",atConId,@"at", nil] type:0 delegate:self sel:@selector(requestReply:)];
}
-(void)publishAction:(id)sender
{
    UIStoryboard* board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PublishViewController* controller = [board instantiateViewControllerWithIdentifier:@"PublishViewController"];
    controller.controller = self;
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    self->_dataArray = dataArray;
    if (dataArray && dataArray.count>0) {
        [self.tableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ActionDetailViewController* controller = [[ActionDetailViewController alloc]init];
    controller.dic = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count>0) {
        return [self getHeightItemWithIndexpath:indexPath];
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"CellInstance";
    //用TableDataIdentifier标记重用单元格
    WeiboTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    if (!cell) {
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        cell  =  [[WeiboTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary* dic =self.dataArray[indexPath.row];
    cell.dic =dic;
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma WeiboTableViewCellDelegate
-(void)weiboTableViewCell:(id)weiboTableViewCell userId:(NSString*)userId isSelf:(BOOL)isSelf
{
    UserLookForViewController* controller = [[UserLookForViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)weiboTableViewCell:(id)weiboTableViewCell contentId:(NSString *)contentId atId:(NSString *)atId isSelf:(BOOL)isSelf
{
    atConId  =atId;
    conId  =contentId;
    [textField becomeFirstResponder];
}

-(void)weiboTableViewCell:(id)weiboTableViewCell deleteDic:(NSDictionary *)dic
{
    if ([self.dataArray containsObject:dic]) {
        [self.dataArray removeObject:dic];
        [self.tableView reloadData];
    }
}

-(void)weiboTableViewCell:(id)weiboTableViewCell refresh:(BOOL)refresh
{
    if (refresh) {
        [self loadData];
    }
}

-(CGFloat)getHeightItemWithIndexpath:(NSIndexPath*) indexpath
{
    NSDictionary* dic = self.dataArray[indexpath.row];
    //内容
    NSString* content = [dic valueForKey:@"content"];
    NSInteger picsCount = [[dic valueForKey:@"pics"] count];
    NSInteger likersCount = [[dic valueForKey:@"likers"] count];
    NSInteger commentCount = [[dic valueForKey:@"comment"] count];
    
    
    int number = [TDUtil convertToInt:content] / 17;
    if (number>5) {
        number  =5;
    }else{
        if ([content length]>0) {
            number++;
        }
    }
    
    CGFloat height = number*25;
    if(picsCount>0 && picsCount<=3){
        height +=70;
    }else{
        if (picsCount%3!=0) {
            height += (picsCount/3+1)*80;
        }else{
            height += (picsCount/3)*80;
        }
    }
    
    if (likersCount>0 && likersCount<7) {
        height+=50;
    }else{
        height += (likersCount/7+1)*20;
    }
    
    for (int i=0; i<commentCount; i++) {
        NSMutableArray* array  = [dic valueForKey:@"comment"];
        NSDictionary* dic  = array[i];
        NSString* name  = [dic valueForKey:@"name"];
        NSString* atLabel = [dic valueForKey:@"at_label"];
        NSString* atName = [dic valueForKey:@"at_name"];
        NSString* suffix =  [dic valueForKey:@"label_suffix"];
        NSString* content =  [dic valueForKey:@"content"];
        NSString* str = name;
        if (atLabel) {
            str = [str stringByAppendingString:atLabel];
        }
        
        if (atName) {
            str = [str stringByAppendingString:atName];
        }
        
        if (suffix) {
            str = [str stringByAppendingString:suffix];
        }
        
        if (content) {
            str = [str stringByAppendingString:content];
        }
        
        NSInteger line = [TDUtil convertToInt:str]/17;
        
        if (line>0) {
            height +=line*20;
        }else{
            height += 20;
        }
        
    }
    
    height+=140;
    return height;
}
#pragma ASIHttpRequest
-(void)requestData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        NSMutableArray* dataArray = [NSMutableArray new];
        NSMutableArray* arrayData = [dic valueForKey:@"data"];
        if ([status integerValue]==0  || [status integerValue]==-1) {
            if (isRefresh) {
                dataArray = arrayData;
            }else{
                for (int i=0; i<arrayData.count; i++) {
                    [dataArray addObject:arrayData[i]];
                }
            }
            self.dataArray = dataArray;
            if (isRefresh) {
                [self.tableView.header endRefreshing];
            }else{
                [self.tableView.footer endRefreshing];
            }
            
            if ([status integerValue]==-1) {
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"内容已加载完毕!"];
            }
            
            [LoadingUtil close:loadingView];
        }else{
            
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
            [self loadData];
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}
@end
