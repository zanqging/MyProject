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
#import "FinalingTableViewCell.h"
#import "ThinkTankTableViewCell.h"
#import "ThinkTankViewController.h"
#import "FinalCompanyTableViewCell.h"
#import "FinalPersonTableViewCell.h"
#import "FinalContentTableViewCell.h"
@interface WMTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation WMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)-kBottomBarHeight-100)];
    self.tableView.backgroundColor = BackColor;
    self.tableView.delegate = self;
    self.tableView.dataSource  =self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refresh) loadAction:@selector(loadProject)];
}


-(void)refresh{
    if ([_delegate respondsToSelector:@selector(wmTableViewController:refresh:)]) {
        [_delegate wmTableViewController:self refresh:nil];
    }
}
-(void)loadProject
{
    if ([_delegate respondsToSelector:@selector(wmTableViewController:loadMore:)]) {
        [_delegate wmTableViewController:self loadMore:nil];
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
//    if (self.menuType==1) {
//        return 105;
//    }else if (self.menuType==2) {
//        if (self.type==0) {
//            return 105;
//        }else{
//            return 110;
//        }
//    }else{
//        switch (self.type) {
//            case 0:
//                return 105;
//                break;
//            case 1:
//                return 105;
//                break;
//            default:
//                return 110;
//                break;
//        }
//    }
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
    if (self.menuType!=2 && self.type!=3) {
        if (self.menuType==1) {
            if ([_delegate respondsToSelector:@selector(wmTableViewController:thinkTankDetailData:)]) {
                [_delegate wmTableViewController:self thinkTankDetailData:self.dataArray[indexPath.row]];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(wmTableViewController:tapIndexPath:data:)]) {
                [_delegate wmTableViewController:self tapIndexPath:indexPath data:self.dataArray[indexPath.row]];
            }
        }
    }else{
        if (self.menuType==0 && self.type==3) {
            if ([_delegate respondsToSelector:@selector(wmTableViewController:playMedia:data:)]) {
                [_delegate wmTableViewController:self playMedia:YES data:self.dataArray[indexPath.row]];
            }
        }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    static NSString *reuseIdetify = @"FinialListView";
    if (self.menuType==0) {
        if (self.type==0) {
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
            cellInstance.title = [dic valueForKey:@"company"];
            cellInstance.roadShowTime = [dic valueForKey:@"date" ];
            cellInstance.typeDescription = [dic valueForKey:@"tag"];
            cellInstance.selectionStyle=UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cellInstance;
        }else if(self.type==1 || self.type==2){
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
            cellInstance.title = [dic valueForKey:@"company"];
            cellInstance.progress = progressStr;
            cellInstance.assist =  [NSString stringWithFormat:@"%@人",[dic valueForKey:@"investor"]];
            cellInstance.hasFinanceAccount =  [dic valueForKey:@"invest"];;
            cellInstance.selectionStyle=UITableViewCellSelectionStyleNone;
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
            NSURL* url = [NSURL URLWithString:[dic valueForKey:@"img"]];
            __block ThinkTankTableViewCell* cell = cellInstance;
            [cellInstance.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
                if (image) {
                    cell.imgView.contentMode = UIViewContentModeScaleToFill;
                }
            }];
            
            cellInstance.title = [dic valueForKey:@"name"];
            cellInstance.content = [dic valueForKey:@"company"];
            cellInstance.typeDescription =  [dic valueForKey:@"desc"];;
            cellInstance.selectionStyle=UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cellInstance;
        }
    }else{
        if (self.type==0) {
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
            cellInstance.selectionStyle=UITableViewCellSelectionStyleNone;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cellInstance;
            
        }else if(self.type==1){
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
            cellInstance.contentLabel.text = [dic valueForKey:@"profile"];
            cellInstance.selectionStyle=UITableViewCellSelectionStyleNone;
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
            cellInstance.selectionStyle=UITableViewCellSelectionStyleNone;
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
        [self.tableView reloadData];
    }else{
        [self.tableView setIsNone:YES];
        self.tableView.content = @"暂无相关数据";
    }
}
- (void)dealloc {
    NSLog(@"%@ destroyed",[self class]);
}

@end
