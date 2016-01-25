//
//  WMTableViewController.m
//  WMPageController
//
//  Created by Mark on 15/6/13.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMTableViewController.h"
#import "TDUtil.h"
#import "WMPageConst.h"
#import "ProjectTableViewCell.h"
#import "FinalingTableViewCell.h"
#import "ThinkTankTableViewCell.h"
#import "ThinkTankViewController.h"
#import "FinalCompanyTableViewCell.h"
#import "FinalPersonTableViewCell.h"
#import "FinalContentTableViewCell.h"
@interface WMTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isRefresh;
}
@end

@implementation WMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navView removeFromSuperview];
    
    self.tableView = [[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)-kBottomBarHeight-100)];
    self.tableView.backgroundColor = BackColor;
    self.tableView.delegate = self;
    self.tableView.dataSource  =self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.loadingViewFrame = self.tableView.frame;
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refresh) loadAction:@selector(loadProject)];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initWithParent:) name:WMControllerDidAddToSuperViewNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showFinished:) name:WMControllerDidFullyDisplayedNotification object:nil];
    
    isRefresh = YES;
}

-(void)initWithParent:(NSNotification*)notification
{
    NSDictionary* dic = [notification valueForKey:@"userInfo"];
    self.selectIndex = [[dic valueForKey:@"index"] intValue];
    self.menuSelectIndex = [[dic valueForKey:@"menuIndex"] intValue];
    
    if (!self.dataArray) {
        self.startLoading=YES;
    }
}

-(void)showFinished:(NSNotification*)notification
{
    NSDictionary* dic = [notification valueForKey:@"userInfo"];
    self.selectIndex = [[dic valueForKey:@"index"] intValue];
    self.menuSelectIndex = [[dic valueForKey:@"menuIndex"] intValue];
    if (!self.dataArray) {
        self.startLoading=NO;
        [self refresh];
    }
}

-(void)refresh
{
    self.currentPage =0;
    isRefresh = YES;
    if (self.menuSelectIndex==0) {
        //网络请求
        if (!self.dataArray) {
            self.startLoading  =YES;
        }
        NSString* srverUrl = [NSString stringWithFormat:@"project/%d/%d/",self.selectIndex+1,self.currentPage];
        [self.httpUtil getDataFromAPIWithOps:srverUrl  type:0 delegate:self sel:@selector(requestFinished:) method:@"GET"];
    }else{
        if (!self.dataArray) {
            self.startLoading  =YES;
        }
        switch (self.selectIndex) {
            case 2:
                [self thinkTank];
                break;
            default:
                [self finialCommicuteList];
                break;
        }
    }
}

-(void)thinkTank
{
    if (self.menuSelectIndex==1) {
        //网络请求
        if (!self.dataArray) {
            self.startLoading  =YES;
        }
        NSString* srverUrl = [THINKTANK stringByAppendingFormat:@"%d/",self.currentPage];
        [self.httpUtil getDataFromAPIWithOps:srverUrl  type:0 delegate:self sel:@selector(requestFinished:) method:@"GET"];
    }
}


-(void)finialCommicuteList
{
    if (self.menuSelectIndex==1) {
        //网络请求
        if (!self.dataArray) {
            self.startLoading  =YES;
        }
        
        NSString* srverUrl = [FINIAL_COMM stringByAppendingFormat:@"%d/%d/",self.selectIndex+1,self.currentPage];
        [self.httpUtil getDataFromAPIWithOps:srverUrl  type:0 delegate:self sel:@selector(requestFinished:) method:@"GET"];
    }
}


-(void)loadProject
{
    self.currentPage++;
    isRefresh = NO;
    if (self.menuSelectIndex==0) {
        //网络请求
        if (!self.dataArray) {
            self.startLoading  =YES;
        }
        NSString* srverUrl = [NSString stringWithFormat:@"project/%d/%d/",self.selectIndex+1,self.currentPage];
        [self.httpUtil getDataFromAPIWithOps:srverUrl  type:0 delegate:self sel:@selector(requestFinished:) method:@"GET"];
    }else{
        if (!self.dataArray) {
            self.startLoading  =YES;
        }
        switch (self.selectIndex) {
            case 2:
                [self thinkTank];
            default:
                [self finialCommicuteList];
                break;
        }
    }
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    NSLog(@"%@ viewWillAppear",[self class]);
//}
//
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    NSLog(@"%@ viewDidAppear",[self class]);
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    NSLog(@"%@ viewWillDisappear",[self class]);
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    NSLog(@"%@ viewDidDisappear",[self class]);
//}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.menuSelectIndex==0) {
        NSLog(@"%d-->%d-->%@",self.menuSelectIndex,self.selectIndex,_delegate);
        //待融资、融资中、已融资
        if (self.menuSelectIndex==0) {
            if ([_delegate respondsToSelector:@selector(wmTableViewController:tapIndexPath:atSelectedIndex:data:)]) {
                [_delegate wmTableViewController:self tapIndexPath:indexPath atSelectedIndex:self.selectIndex data:self.dataArray[indexPath.row]];
            }
        }else{
            //            if ([_delegate respondsToSelector:@selector(wmTableViewController:thinkTankDetailData:)]) {
            //                [_delegate wmTableViewController:self thinkTankDetailData:self.dataArray[indexPath.row]];
            //            }
        }
        
    }else{
        
        switch (self.selectIndex) {
            case 0:
                if ([_delegate respondsToSelector:@selector(wmTableViewController:personalFincance:)]) {
                    [_delegate wmTableViewController:self personalFincance:self.dataArray[indexPath.row]];
                }
                break;
            case 1:
                if ([_delegate respondsToSelector:@selector(wmTableViewController:comFincance:)]) {
                    [_delegate wmTableViewController:self comFincance:self.dataArray[indexPath.row]];
                }
                break;
            case 2:
                if ([_delegate respondsToSelector:@selector(wmTableViewController:thinkTankDetailData:)]) {
                    [_delegate wmTableViewController:self thinkTankDetailData:self.dataArray[indexPath.row]];
                }
                break;
                
            default:
                if ([_delegate respondsToSelector:@selector(wmTableViewController:personalFincance:)]) {
                    [_delegate wmTableViewController:self personalFincance:self.dataArray[indexPath.row]];
                }
                break;
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    static NSString *reuseIdetify = @"FinialListView";
    [self.tableView setContentSize:CGSizeMake(WIDTH(self.tableView), 105*self.dataArray.count+10)];
    if (self.menuSelectIndex==0) {
        if (self.selectIndex==0) {
            FinalContentTableViewCell *cellInstance = (FinalContentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdetify];
            if (!cellInstance) {
                float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
                cellInstance = [[FinalContentTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
            }
            NSDictionary* dic = self.dataArray[row];
            NSURL* url = [NSURL URLWithString:[dic valueForKey:@"img"]];
            __block FinalContentTableViewCell* cell = cellInstance;
            [cellInstance.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
                if (image) {
                    cell.imgView.contentMode = UIViewContentModeScaleToFill;
                }
            }];
            
            
            cellInstance.backgroundColor = ClearColor;
            cellInstance.title = [dic valueForKey:@"abbrevcompany"];
            cellInstance.roadShowTime = [dic valueForKey:@"date" ];
            cellInstance.typeDescription = [dic valueForKey:@"company"];
            cellInstance.address = DICVFK(dic, @"addr");
            cellInstance.selectionStyle=UITableViewCellSelectionStyleDefault;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cellInstance;
        }else if(self.selectIndex==1 || self.selectIndex==2){
            static NSString *reuseIdetify = @"FinialThinkView";
            FinalingTableViewCell *cellInstance = (FinalingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdetify];
            if (!cellInstance) {
                float height =[self tableView:tableView heightForRowAtIndexPath:indexPath];
                cellInstance = [[FinalingTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
            }
            
            NSDictionary* dic = self.dataArray[row];
            NSURL* url = [NSURL URLWithString:[dic valueForKey:@"img"]];
            __block FinalingTableViewCell* cell = cellInstance;
            [cellInstance.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
                if (image) {
                    cell.imgView.contentMode = UIViewContentModeScaleToFill;
                }
            }];
            float progress =([[dic valueForKey:@"invest"] floatValue]*100)/[[dic valueForKey:@"planfinance"] floatValue];
            NSString* progressStr= [NSString stringWithFormat:@"%.2f",progress];
            progressStr= [progressStr stringByAppendingString:@"%"];
            cellInstance.title = [dic valueForKey:@"abbrevcompany"];
            cellInstance.progress = progressStr;
            cellInstance.assist =  [NSString stringWithFormat:@"%@",[dic valueForKey:@"tag"]];
            cellInstance.hasFinanceAccount =  [dic valueForKey:@"invest"];;
            cellInstance.selectionStyle=UITableViewCellSelectionStyleDefault;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cellInstance;
        }else{
            static NSString *reuseIdetify = @"FinialThinkView";
            ProjectTableViewCell *cellInstance = (ProjectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdetify];
            if (!cellInstance) {
                float height =[self tableView:tableView heightForRowAtIndexPath:indexPath];
                cellInstance = [[ProjectTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
            }
            
            NSDictionary* dic = self.dataArray[row];
            NSURL* url = [NSURL URLWithString:[dic valueForKey:@"img"]];
            __block ProjectTableViewCell* cell = cellInstance;
            [cellInstance.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
                if (image) {
                    cell.imgView.contentMode = UIViewContentModeScaleToFill;
                }
            }];
            
            cellInstance.title = [dic valueForKey:@"abbrevcompany"];
            cellInstance.content = [dic valueForKey:@"company"];
            cellInstance.typeDescription =  [NSString stringWithFormat:@"上传时间:%@",[dic valueForKey:@"date"]];
            cellInstance.selectionStyle=UITableViewCellSelectionStyleDefault;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cellInstance;
        }
    }else{
        if (self.selectIndex==0) {
            static NSString *reuseIdetify = @"FinialThinkView";
            FinalPersonTableViewCell *cellInstance = (FinalPersonTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdetify];
            if (!cellInstance) {
                float height =[self tableView:tableView heightForRowAtIndexPath:indexPath];
                cellInstance = [[FinalPersonTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
            }
            
            NSDictionary* dic = self.dataArray[row];
            NSURL* url = [NSURL URLWithString:[dic valueForKey:@"photo"]];
            __block FinalPersonTableViewCell* cell = cellInstance;
            [cellInstance.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
                if (image) {
                    cell.imgView.contentMode = UIViewContentModeScaleToFill;
                }
            }];
            
            cellInstance.title = [dic valueForKey:@"name"];
            cellInstance.content = [dic valueForKey:@"company"];
            cellInstance.typeDescription =  [dic valueForKey:@"position"];;
            cellInstance.selectionStyle=UITableViewCellSelectionStyleDefault;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cellInstance;
            
        }else if(self.selectIndex==1){
            static NSString *reuseIdetify = @"FinialThinkView";
            FinalCompanyTableViewCell *cellInstance = (FinalCompanyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdetify];
            if (!cellInstance) {
                float height =[self tableView:tableView heightForRowAtIndexPath:indexPath];
                cellInstance = [[FinalCompanyTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
            }
            
            NSDictionary* dic = self.dataArray[row];
            NSURL* url;
            url = [NSURL URLWithString:[dic valueForKey:@"logo"]];
            __block FinalCompanyTableViewCell* cell = cellInstance;
            [cellInstance.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
                if (image) {
                    cell.imgView.contentMode = UIViewContentModeScaleAspectFit;
                }
            }];
            
            cellInstance.title = [dic valueForKey:@"name"];
            cellInstance.contentLabel.text = [dic valueForKey:@"addr"];
            cellInstance.subTitleLabel.text = [dic valueForKey:@"abbrevname"];
            cellInstance.selectionStyle=UITableViewCellSelectionStyleDefault;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cellInstance;
            
        }else{
            static NSString *reuseIdetify = @"FinialThinkView";
            ThinkTankTableViewCell *cellInstance = (ThinkTankTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdetify];
            if (!cellInstance) {
                float height =[self tableView:tableView heightForRowAtIndexPath:indexPath];
                cellInstance = [[ThinkTankTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
            }
            
            NSDictionary* dic = self.dataArray[row];
            NSURL* url = [NSURL URLWithString:[dic valueForKey:@"photo"]];
            __block ThinkTankTableViewCell* cell = cellInstance;
            [cellInstance.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
                if (image) {
                    cell.imgView.contentMode = UIViewContentModeScaleToFill;
                }
            }];
            
            cellInstance.title = [dic valueForKey:@"name"];
            cellInstance.content = [dic valueForKey:@"company"];
            cellInstance.typeDescription =  [dic valueForKey:@"position"];;
            cellInstance.selectionStyle=UITableViewCellSelectionStyleDefault;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cellInstance;
        }
    }
    
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray && self.dataArray.count>0) {
        
        [self.tableView setIsNone:NO];
    }else{
        [self.tableView setIsNone:YES];
        self.tableView.content = @"暂无相关数据";
    }
    [self.tableView reloadData];
}
- (void)dealloc {
    NSLog(@"%@ destroyed",[self class]);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    //取消tableViewCell选中状态
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
}


-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        if (self.dataArray) {
            [[DialogUtil sharedInstance]showDlg:[UIApplication sharedApplication].windows[0] textOnly:[jsonDic valueForKey:@"msg"]];
        }
        
        int code = [[jsonDic valueForKey:@"code"] intValue];
        if (code>=0) {
            if (isRefresh) {
                self.dataArray = [jsonDic valueForKey:@"data"];
            }else{
                if (!self.dataArray) {
                    self.dataArray = [jsonDic valueForKey:@"data"];
                }else{
                    NSMutableArray* array = self.dataArray;
                    [array addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                    self.dataArray = array;
                }
            }
        }
        
        self.startLoading  =NO;
    }else{
        self.isNetRequestError = YES;
    }
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}
@end
