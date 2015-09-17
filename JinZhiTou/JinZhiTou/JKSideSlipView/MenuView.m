//
//  MenuView.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "MenuView.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "UserInfoHeader.h"
#import "UserInfoTableViewCell.h"
@implementation MenuView
+(instancetype)menuView
{
    MenuView *result = nil;

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    for (id object in nibView)
    {
        if ([object isKindOfClass:[self class]])
        {
            result = object;
            break;
        }
    }
    return result;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [ super initWithFrame:frame]) {
        self.backgroundColor = ColorTheme;
        //设置标题
        navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.frame.size.width,NAVVIEW_HEIGHT)];
        navView.imageView.alpha=0;
        [navView setTitle:@"个人中心"];
        navView.titleLable.textColor=WriteColor;
        [navView.rightButton setImage:IMAGENAMED(@"top-caidan") forState:UIControlStateNormal];
        [navView.rightButton addTarget:self action:@selector(menu:)forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:navView];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self), HEIGHT(self)-POS_Y(navView)-kBottomBarHeight)];
        self.tableView.bounces=YES;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.allowsSelection=YES;
        self.tableView.delaysContentTouches=NO;
        self.tableView.backgroundColor=WriteColor;
        self.tableView.showsVerticalScrollIndicator=NO;
        self.tableView.showsHorizontalScrollIndicator=NO;
        self.tableView.contentSize = CGSizeMake(WIDTH(self), HEIGHT(self)-50);
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:self.tableView];
        
        UserInfoHeader* headerView =[[UserInfoHeader alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), 200)];
        [self.tableView setTableHeaderView:headerView];
        
        UIView* footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 70)];
        UIImageView* imgView = [[UIImageView alloc]initWithImage:IMAGENAMED(@"gerenzhongxin-8")];
        imgView.frame = CGRectMake(WIDTH(footView)-30, HEIGHT(footView)/2-5, 20, 20);
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [footView addSubview:imgView];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settingAction:)]];
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
    
    self.items=array;
    
}
-(void)settingAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setting" object:nil];
}

-(void)menu:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil];
}
-(void)didSelectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didSelectRowAtIndexPath{
    _didSelectRowAtIndexPath = [didSelectRowAtIndexPath copy];
}
-(void)setItems:(NSArray *)items{
    _items = items;
    [self.tableView reloadData];
}


#pragma -mark tableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_didSelectRowAtIndexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        _didSelectRowAtIndexPath(cell,indexPath);
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* Identifier = @"MenuInfoViewCell";
    UserInfoTableViewCell *cell = (UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = (UserInfoTableViewCell*)[[UserInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), 44)];
    }
    
    NSInteger row =indexPath.row;
    NSDictionary* dic =self.items[row];
    if ([[dic valueForKey:@"isBedEnable"] isEqualToString:@"yes"]) {
        cell.isBedgesEnabled = YES;
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    [cell setImageWithName:[dic valueForKey:@"imageName"] setTitle:[dic valueForKey:@"title"]];
    return cell;
}


@end
