//
//  InteractionViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/29.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "InteractionViewController.h"
#import "NavView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "InteractionHeader.h"
@interface InteractionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NavView*  navView;
}

@end

@implementation InteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=0;
    [navView setTitle:@"路演详情"];
    navView.titleLable.textColor=WriteColor;
    [self.view addSubview:navView];
    
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=NO;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    [self.view addSubview:self.tableView];
    
    //Header
    InteractionHeader* header = [[InteractionHeader alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), 50)];
    [self.tableView setTableHeaderView:header];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"RoadShowTableViewCell";
    //用TableDataIdentifier标记重用单元格
    UITableViewCell* cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 100)];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
