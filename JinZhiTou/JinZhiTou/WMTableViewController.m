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
#import "RoadShowHomeTableViewCell.h"
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
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoadShowHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WMCell"];
    if (cell == nil) {
        cell = [[RoadShowHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"WMCell"];
    }
    
    NSInteger row = indexPath.row;
    NSDictionary* dic = [self.dataArray objectAtIndex:row];
    [cell setImageName:[dic valueForKey:@"img"]];
    [cell setCompanyName:[dic valueForKey:@"company"]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
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
