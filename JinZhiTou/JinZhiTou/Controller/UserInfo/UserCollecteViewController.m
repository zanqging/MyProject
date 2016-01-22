//
//  UserCollecteViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/8.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserCollecteViewController.h"
#import "MJRefresh.h"
#import "SwitchSelect.h"
#import "ThinkTankTableViewCell.h"
#import "FinalingTableViewCell.h"
#import "FinalContentTableViewCell.h"
#import "UserCollecteTableViewCell.h"
#import "RoadShowDetailViewController.h"
@interface UserCollecteViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,LoadingViewDelegate>
{
    bool isRefresh;
    BOOL isLastPage;
    NSInteger currentPage;
    NSInteger currentSelected;
    UIScrollView* scrollView;
}
@end

@implementation UserCollecteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"我的收藏"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    //头部
    [self addSwitchView];
    
    self.tableView=[[UITableViewCustomView alloc]initWithFrame:CGRectMake(0, POS_Y(scrollView), WIDTH(self.view), HEIGHT(self.view)-HEIGHT(scrollView)-HEIGHT(self.navView)) style:UITableViewStylePlain];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=BackColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    
    self.startLoading = YES;
    
    //加载数据
    [self loadCollecteData];
}

-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    switch (currentSelected) {
        case 1000:
            [self loadCollecteData];
            break;
        case 1001:
            [self loadFinacingData];
            break;
        case 1002:
            [self loadFinacedData];
            break;
        case 1003:
            [self loadThinkTankData];
            break;
        default:
            [self loadCollecteData];
            break;
    }
    
}

-(void)loadProject
{
    isRefresh =NO;
    if (!self.isEndOfPageSize) {
        currentPage++;
        switch (currentSelected) {
            case 1000:
                [self loadCollecteData];
                break;
            case 1001:
                [self loadFinacingData];
                break;
            case 1002:
                [self loadFinacedData];
                break;
            case 1003:
                [self loadThinkTankData];
                break;
            default:
                [self loadCollecteData];
                break;
        }
        
    }else{
        [self.tableView.footer endRefreshing];
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"已加载全部内容"];
    }
}


-(void)loadCollecteData
{
    NSString* url = [MY_COLLECTE_ROADSHOW stringByAppendingFormat:@"%ld/",(long)currentPage];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestCollectData:)];
}
-(void)loadThinkTankData
{
    NSString* url = [MY_COLLECTE_THINKTANK stringByAppendingFormat:@"%ld/",(long)currentPage];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestCollectData:)];
}
-(void)loadFinacingData
{
    NSString* url = [MY_COLLECTE_FINANCING stringByAppendingFormat:@"%ld/",(long)currentPage];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestCollectData:)];
}
-(void)loadFinacedData
{
    NSString* url = [MY_COLLECTE_FINANCED stringByAppendingFormat:@"%ld/",(long)currentPage];
    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestCollectData:)];
}

-(void)addSwitchView
{
    NSMutableArray* array=[NSMutableArray arrayWithObjects: @"待融资",@"融资中",@"已融资",@"预选", nil];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), 40)];
     scrollView.backgroundColor =WriteColor;
    UITapGestureRecognizer* recognizer;
    float w =WIDTH(self.view)/array.count;
    for (int i =  0; i<array.count; i++) {
        recognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        //自然投资人
        SwitchSelect* switchView = [[SwitchSelect alloc]initWithFrame:CGRectMake(w*i, 0,w, 40)];
        switchView.tag =1000+i;
        if (i==0) {
            switchView.isSelected = YES;
        }
        
        switchView.titleName = array[i];
        switchView.backgroundColor = BackColor;
        [switchView addGestureRecognizer:recognizer];
        [scrollView setContentSize:CGSizeMake(w*i, HEIGHT(scrollView))];
        [scrollView addSubview:switchView];
    }
   
   [self.view addSubview:scrollView];
}

-(void)tapAction:(UITapGestureRecognizer*)sender
{
    SwitchSelect* switchView = (SwitchSelect*)sender.view;
    switchView.isSelected =YES;
   
    for ( UIView *  v in scrollView.subviews) {
        if (v.class == SwitchSelect.class) {
            if (v.tag != switchView.tag) {
                ((SwitchSelect*)v).isSelected=NO;
            }
        }
    }
    
    if (currentSelected !=switchView.tag) {
         currentSelected = switchView.tag;
        currentPage = 0;
        self.isEndOfPageSize= NO;
        isLastPage = false;
        switch (currentSelected) {
            case 1000:
                [self loadCollecteData];
                break;
            case 1001:
                [self loadFinacingData];
                break;
            case 1002:
                [self loadFinacedData];
                break;
            case 1003:
                [self loadThinkTankData];
                break;
            default:
                [self loadCollecteData];
                break;
        }
    }
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoadShowDetailViewController* controller =[[RoadShowDetailViewController alloc]init];
    controller.title =self.navView.title;
    NSDictionary* dic = self.dataArray[indexPath.row];
//    Project* project = [[Project alloc]init];
//    project = [[Project alloc]init];
//    project.imgUrl = [dic valueForKey:@"img"];
//    project.tag = [dic valueForKey:@"tag"];
//    project.company = [dic valueForKey:@"company"];
//    project.projectId = [[dic valueForKey:@"id"] integerValue];
//    project.invest = [NSString stringWithFormat:@"%@",[dic valueForKey:@"invest"]];
//    project.planfinance = [NSString stringWithFormat:@"%@",[dic valueForKey:@"planfinance"]];
    
    controller.dic = dic;

    [self.navigationController pushViewController:controller animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    static NSString *reuseIdetify = @"FinialListView";
    NSInteger row = indexPath.row;
    if (currentSelected !=1003) {
        //声明静态字符串对象，用来标记重用单元格
        static  NSString* TableDataIdentifier=@"UserCollecteViewCell";
        //用TableDataIdentifier标记重用单元格
        UserCollecteTableViewCell* cell=(UserCollecteTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
        //如果单元格未创建，则需要新建
        if (cell==nil) {
            cell =[[UserCollecteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
        }

        NSDictionary* dic = self.dataArray[indexPath.row];

        [cell.imgview sd_setImageWithURL:[dic valueForKey:@"img"] placeholderImage:IMAGENAMED(@"loading")];
        cell.titleLabel.text = [dic valueForKey:@"company"];
        cell.start = [dic valueForKey:@"start"];
        cell.end = [dic valueForKey:@"stop"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        tableView.contentSize = CGSizeMake(WIDTH(tableView), 190*self.dataArray.count+100);
        return cell;
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
        
        cellInstance.title = [dic valueForKey:@"abbrevcompany"];
        cellInstance.content = [dic valueForKey:@"company"];
        cellInstance.typeDescription =  [NSString stringWithFormat:@"上传时间:%@",[dic valueForKey:@"date"]];
        cellInstance.selectionStyle=UITableViewCellSelectionStyleDefault;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cellInstance;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    if (self.dataArray.count<=0) {
        self.tableView.isNone = YES;
    }else{
        self.tableView.isNone = NO;
    }
    [self.tableView reloadData];
}

#pragma LoadingView
-(void)refresh
{
    [super refresh];
    [self loadCollecteData];
}

#pragma ASIHttpquest
//待融资
-(void)requestCollectData:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSDictionary* jsonDic = [jsonString JSONValue];
    if (jsonDic!=nil) {
        NSString* status =[jsonDic valueForKey:@"status"];
        if([status intValue] == 0 || [status intValue] ==-1){
            self.dataArray = [jsonDic valueForKey:@"data"];
            if ([status integerValue] == -1) {
                isLastPage = YES;
                self.isEndOfPageSize = YES;
            }
            self.startLoading =NO;
        }else{
            self.isNetRequestError  = YES;
        }
        self.tableView.content = [jsonDic valueForKey:@"msg"];
    }else{
        self.isNetRequestError = YES;
    }
    
    if (isRefresh) {
        [self.tableView.header endRefreshing];
    }else{
        [self.tableView.footer endRefreshing];
    }
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

@end
