//
//  UserInfo.m
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserInfo.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "UserInfoHeader.h"
#import "UserInfoTableViewCell.h"
@implementation UserInfo
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
        self.tableView.bounces=YES;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.allowsSelection=YES;
        self.tableView.delaysContentTouches=NO;
        self.tableView.backgroundColor=WriteColor;
        self.tableView.showsVerticalScrollIndicator=NO;
        self.tableView.showsHorizontalScrollIndicator=NO;
        self.tableView.contentSize = CGSizeMake(WIDTH(self), HEIGHT(self)+220);
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        
        [self addSubview:self.tableView];
        
        UserInfoHeader* headerView =[[UserInfoHeader alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), 200)];
        [self.tableView setTableHeaderView:headerView];
        
        UIView* footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 50)];
        UIImageView* imgView = [[UIImageView alloc]initWithImage:IMAGENAMED(@"gerenzhongxin-89")];
        imgView.frame = CGRectMake(WIDTH(footView)-30, HEIGHT(footView)/2-5, 20, 20);
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [footView addSubview:imgView];
        imgView.userInteractionEnabled = YES;
        [self.tableView setTableFooterView:footView];
        
        [self loadData];
    }
    return self;
}

-(void)loadData
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"1" forKey:@"index"];
    [dic setValue:@"与我相关" forKey:@"title"];
    [dic setValue:@"yes" forKey:@"isBedEnable"];
    [dic setValue:@"About" forKey:@"imageName"];
    [array addObject:dic];
    
    dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"2" forKey:@"index"];
    [dic setValue:@"我的收藏" forKey:@"title"];
    [dic setValue:@"false" forKey:@"isBedEnable"];
    [dic setValue:@"Collect" forKey:@"imageName"];
    [array addObject:dic];
    
    dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"3" forKey:@"index"];
    [dic setValue:@"我的投融资" forKey:@"title"];
    [dic setValue:@"false" forKey:@"isBedEnable"];
    [dic setValue:@"Authenticate" forKey:@"imageName"];
    [array addObject:dic];
    
    dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"4" forKey:@"index"];
    [dic setValue:@"投资人认证" forKey:@"title"];
    [dic setValue:@"false" forKey:@"isBedEnable"];
    [dic setValue:@"Investment" forKey:@"imageName"];
    [array addObject:dic];
    
    dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"5" forKey:@"index"];
    [dic setValue:@"邀请好友" forKey:@"title"];
    [dic setValue:@"false" forKey:@"isBedEnable"];
    [dic setValue:@"Invite" forKey:@"imageName"];
    [array addObject:dic];
    
    dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"6" forKey:@"index"];
    [dic setValue:@"关于我们" forKey:@"title"];
    [dic setValue:@"false" forKey:@"isBedEnable"];
    [dic setValue:@"Related" forKey:@"imageName"];
    [array addObject:dic];
    
    self.dataArray=array;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* indexStr = [self.dataArray[indexPath.row] valueForKey:@"index"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfoAction" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:indexStr,@"index",nil]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"UserInfoViewCell";
    //用TableDataIdentifier标记重用单元格
    UserInfoTableViewCell* cell=(UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (cell==nil) {
        cell = [[UserInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(tableView), 100)];
    }
    
    if (indexPath.row==0) {
        cell.isBedgesEnabled = YES;
    }
    NSInteger row =indexPath.row;
    NSDictionary* dic = self.dataArray[row];
    [cell setImageWithName:[dic valueForKey:@"imageName"] setTitle:[dic valueForKey:@"title"]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(void)setDataArray:(NSArray *)dataArray
{
    self->_dataArray = dataArray;
    [self.tableView reloadData];
}

-(void)setIsAmious:(BOOL)isAmious
{
    self->_isAmious = isAmious;
    if (self->_isAmious) {
        [self.tableView removeFromSuperview];
        
        //背景
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:self.frame];
        imgView.image = IMAGENAMED(@"kuang");
        [self addSubview:imgView];
    }
}

@end
