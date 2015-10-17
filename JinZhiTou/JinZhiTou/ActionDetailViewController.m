//
//  ActionDetailViewController.m
//  Cycle
//
//  Created by air on 15/10/14.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "ActionDetailViewController.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@interface ActionDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ActionHeaderDeleaget>
{
    ActionHeader* headerView;
}
@end

@implementation ActionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈";
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
    
    headerView = [[ActionHeader alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 200)];
    headerView.delegate = self;
    [self.tableView setTableHeaderView:headerView];
    
    self.classStringName = @"CyclePriseTableViewCell";
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
    NSString* indexStr = [self.dataArray[indexPath.row] valueForKey:@"index"];
    if (indexStr.integerValue == 5) {
        
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfoAction" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:indexStr,@"index",nil]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 100;
    switch (self.selectIndex) {
        case 1:
            height = 70;
            break;
        case 2:
            height = 70;
            break;
        case 3:
            height = 100;
            break;
        default:
            height = 100;
            break;
    }
    return height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"UserInfoViewCell";
    //用TableDataIdentifier标记重用单元格
     UITableViewCell *cell =[[NSClassFromString(self.classStringName)alloc]init];
     cell=[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (cell==nil) {
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        cell = [[NSClassFromString(self.classStringName)alloc]initWithFrame:CGRectMake(0, 0, WIDTH(tableView), height)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectIndex;
}


-(void)setClassStringName:(NSString *)classStringName
{
    self->_classStringName = classStringName;
}

-(void)setSelectIndex:(NSInteger)selectIndex
{
    self->_selectIndex  =selectIndex;
    [self.tableView reloadData];
}

-(void)actionHeader:(id)header selectedIndex:(NSInteger)selectedIndex className:(NSString *)className
{
    self.classStringName = className;
    self.selectIndex = selectedIndex;
}
@end
