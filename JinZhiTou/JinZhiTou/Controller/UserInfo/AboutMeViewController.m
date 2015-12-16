//
//  AboutMeViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "AboutMeViewController.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "AboutMeViewCell.h"
#import "MasterViewController.h"
@interface AboutMeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"与我相关"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.view addSubview:self.navView];
    
    
    self.tableView=[[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)) style:UITableViewStylePlain];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=BackColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateStatus) name:@"updateMessageStatus" object:nil];
    
    [self loadData];
    
}

-(void)updateStatus
{
    [self loadData];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    NSMutableDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"huifuxiaoxi" forKey:@"imageName"];
    [dic setValue:@"消息回复" forKey:@"title"];
    [array addObject:dic];
    
    dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"tongzhi" forKey:@"imageName"];
    [dic setValue:@"消息通知" forKey:@"title"];
    [array addObject:dic];
    
    self.dataArray=array;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MasterViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"SystemMessage"];
    NSInteger row = indexPath.row;
    if(row==0){
        controller.type=0;
    }else{
        controller.type=1;
    }
    NSDictionary* dic =self.dataArray[row];
    controller.titleStr = [dic valueForKey:@"title"];
//    controller.type = row;
    [self.navigationController pushViewController:controller animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"aboutMeInfoViewCell";
    //用TableDataIdentifier标记重用单元格
    AboutMeViewCell* cell=(AboutMeViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (cell==nil) {
        cell = [[AboutMeViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 100)];
    }
    
    NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
    if (indexPath.row==0) {
        NSInteger newMessageCount = [[dataStore valueForKey:@"NewMessageCount"] integerValue];
        if (newMessageCount>0) {
            cell.messageCount = [NSString stringWithFormat:@"%ld",newMessageCount];
            [cell setIsBedgesEnabled:YES];
        }
    }else{
        NSInteger systemMessageCount = [[dataStore valueForKey:@"SystemMessageCount"] integerValue];
        if (systemMessageCount>0) {
            cell.messageCount = [NSString stringWithFormat:@"%ld",systemMessageCount];
            [cell setIsBedgesEnabled:YES];
        }

    }
    NSDictionary* dic =self.dataArray[indexPath.row];
    [cell setImageWithName:[dic valueForKey:@"imageName"] setTitle:[dic valueForKey:@"title"]];
    cell.backgroundColor = WriteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (!self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated { [super viewWillAppear:animated];
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
}
@end
