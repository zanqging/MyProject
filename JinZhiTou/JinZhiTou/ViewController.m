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
#import "NSString+SBJSON.h"
#import "UserLookForViewController.h"
@interface ViewController ()<WeiboTableViewCellDelegate>
{
    HttpUtils* httpUtils;
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
//    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction:)]];
    
    [self.navView.rightButton setImage:IMAGENAMED(@"feed_action_share_normal") forState:UIControlStateNormal];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publishAction:)]];
    [self.view addSubview:self.navView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
     httpUtils = [[HttpUtils alloc]init];
    
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
    NSString* serverUrl = [CYCLE_CONTENT_LIST stringByAppendingFormat:@"%d/",0];
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestData:)];
}



-(void)publishAction:(id)sender
{
    UIStoryboard* board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = [board instantiateViewControllerWithIdentifier:@"PublishViewController"];
    [self.navigationController pushViewController:controller animated:YES];
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
    [self.navigationController pushViewController:controller animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 700;
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
    //头像
    NSURL* url = [NSURL URLWithString:[dic valueForKey:@"photo"]];
    [cell.headerImgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember")];
    //姓名
    cell.nameLabel.text = [dic valueForKey:@"name"];
    //内容
    cell.contentLabel.text = [dic valueForKey:@"content"];
    cell.jobLabel.text = [[dic valueForKey:@"position"] objectAtIndex:0];
    
    cell.industryLabel.text = [dic valueForKey:@"city"];
    
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



#pragma ASIHttpRequest
-(void)requestData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            self.dataArray  = [dic valueForKey:@"data"];
        }else{
            
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}
@end
