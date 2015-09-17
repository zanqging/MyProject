//
//  TeamShowViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "TeamShowViewController.h"
#import "Cell.h"
#import "TDUtil.h"
#import "NavView.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "LineLayout.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "TeamDetailViewController.h"
@interface TeamShowViewController ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout,ASIHTTPRequestDelegate>
{
    BOOL isResetPosition;
    HttpUtils* httpUtils;
    NavView * navView;
    NSString* _identify;
    UICollectionView* collectionView ;
}

@end

@implementation TeamShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:@"核心团队"];
    navView.titleLable.textColor=WriteColor;
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"路演详情" forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:navView];
    
    //图片浏览
    LineLayout * layOut=[[LineLayout alloc]init];
    layOut.lineSpacing=50;
    layOut.direction=1;
    layOut.size=CGSizeMake(200, 300);
    collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)) collectionViewLayout:layOut];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor =BackColor;
    
    //注册单元格
    _identify = @"PhotoCell";
    [collectionView registerClass:[Cell class] forCellWithReuseIdentifier:_identify];
    [self.view addSubview:collectionView];
    
    //初始化网络对象
    httpUtils = [[HttpUtils alloc]init];
    //加载数据啊
    [self loadData];
}


-(void)loadData
{
    NSString* url = [COREMEMBER stringByAppendingFormat:@"%d/",self.projectId];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestCoreMember:)];
}
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:_identify forIndexPath:indexPath];
    NSInteger row = indexPath.item;
    NSDictionary* dic = self.dataArray[row];
    cell.title = [dic  valueForKey:@"name"];
    cell.desc = [dic valueForKey:@"title"];
    NSURL* url = [NSURL URLWithString:[dic valueForKey:@"img"]];
    [cell.imageView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember")];
    if (row>0 && !isResetPosition) {
        NSIndexPath* index = [NSIndexPath indexPathForRow:1 inSection:0];
        [collectionView selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        isResetPosition = YES;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TeamDetailViewController* controller  = [[TeamDetailViewController alloc ]init];
    NSInteger row = indexPath.row;
    NSDictionary* dic = self.dataArray[row];
    controller.dataDic = dic;
    controller.person_id = [[dic valueForKey:@"id"] integerValue];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    [collectionView reloadData];
}
#pragma ASIHttpRequest
-(void)requestCoreMember:(ASIHTTPRequest *)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableArray* jsonDic = [jsonString JSONValue];
    
    if (jsonDic) {
        int status = [[jsonDic valueForKey:@"status"] intValue];
        if (status==0 || status == -1) {
            self.dataArray = [jsonDic valueForKey:@"data"];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
