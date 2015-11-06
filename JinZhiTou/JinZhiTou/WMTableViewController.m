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
#import "FinalContentTableViewCell.h"
@interface WMTableViewController ()

@end

@implementation WMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = BackColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refresh) loadAction:@selector(loadProject)];
}

-(void)loadProject
{
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    static NSString *reuseIdetify = @"FinialListView";
    FinalContentTableViewCell *cellInstance = (FinalContentTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cellInstance) {
        cellInstance = [[FinalContentTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 190)];
    }
    NSDictionary* dic = self.dataArray[row];
    NSURL* url = [NSURL URLWithString:[dic valueForKey:@"img"]];
    __block FinalContentTableViewCell* cell = cellInstance;
    [cellInstance.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
        if (image) {
            cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
        }
    }];
    
    cellInstance.title = [dic valueForKey:@"company"];
    cellInstance.content = [dic valueForKey:@"project_summary"];
    cellInstance.start = [[dic valueForKey:@"stage"] valueForKey:@"start"];
    cellInstance.typeDescription = [dic valueForKey:@"addr"];
    cellInstance.backgroundColor = ClearColor;
    cellInstance.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cellInstance;
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray) {
        [self.tableView reloadData];
    }
}
- (void)dealloc {
    NSLog(@"%@ destroyed",[self class]);
}

@end
