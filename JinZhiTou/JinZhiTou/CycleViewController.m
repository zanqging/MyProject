//
//  DemoVC9.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * 持续更新地址: https://github.com/gsdios/SDAutoLayout                              *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************

 */

#import "CycleViewController.h"
#import "MJRefresh.h"
#import "Demo9Model.h"
#import "DemoVC9Cell.h"
#import "DemoVC9HeaderView.h"
#import "ShareTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "PublishViewController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

#define kDemoVC9CellId @"demovc9cell"

@interface CycleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *modelsArray;

@end

@implementation CycleViewController
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    
    //==============================TabBarItem 设置==============================//
    UIImage* image=IMAGENAMED(@"btn-quanzi-cheng");
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setSelectedImage:image];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:AppColorTheme,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    //==============================TabBarItem 设置==============================//
    
    //==============================导航栏区域 设置==============================//
    [self.navView setTitle:@"金指投"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:IMAGENAMED(@"shuruphone") forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction:)]];
    
    [self.navView.rightButton setImage:IMAGENAMED(@"circle_publish") forState:UIControlStateNormal];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publishAction:)]];
    //==============================导航栏区域 设置==============================//
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView)-kBottomBarHeight-87)];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    [self creatModelsWithCount:10];
    
    
    DemoVC9HeaderView *headerView = [DemoVC9HeaderView new];
    headerView.frame = CGRectMake(0, 0, 0, 260);
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerClass:[DemoVC9Cell class] forCellReuseIdentifier:kDemoVC9CellId];
    
    //加载数据
    [self loadData];
}

/**
 *  加载数据
 */
-(void)loadData
{
    NSString* serverUrl = [CYCLE_CONTENT_LIST stringByAppendingFormat:@"%d/",curentPage];
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestData:)];
}

-(void)userInfoAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil];
}

-(void)publishAction:(id)sender
{
    UIStoryboard* board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PublishViewController* controller = [board instantiateViewControllerWithIdentifier:@"PublishViewController"];
    controller.controller = self;
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

- (void)creatModelsWithCount:(NSInteger)count
{
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray new];
    }
    
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic8.jpg"
                                     ];
    
    for (int i = 0; i < count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        Demo9Model *model = [Demo9Model new];
        model.iconName = iconImageNamesArray[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.content = textArray[contentRandomIndex];
        model.commentViewHeight = 213+i*20;
        model.commentHeaderViewHeight=33;
        
        
        
        // 模拟“随机图片”
        int random = arc4random_uniform(10);
        
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < random; i++) {
            int randomIndex = arc4random_uniform(9);
            [temp addObject:picImageNamesArray[randomIndex]];
        }
        if (temp.count) {
            model.picNamesArray = [temp copy];
        }
        
        [self.modelsArray addObject:model];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoVC9Cell *cell = [tableView dequeueReusableCellWithIdentifier:kDemoVC9CellId];
    if (!cell) {
        cell =[[DemoVC9Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDemoVC9CellId commentViewHeight:213 commentHeaderViewHeight:33];
    }
    
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    CGFloat h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
    NSLog(@"%ld-->%f",indexPath.row,h);
    return h;
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width
{
    
    if (!self.tableView.cellAutoHeightManager) {
        self.tableView.cellAutoHeightManager = [[SDCellAutoHeightManager alloc] init];
    }
    if (self.tableView.cellAutoHeightManager.contentViewWidth != width) {
        self.tableView.cellAutoHeightManager.contentViewWidth = width;
        [self.tableView.cellAutoHeightManager clearHeightCache];
    }
    UITableViewCell *cell = [self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:indexPath];
    self.tableView.cellAutoHeightManager.modelCell = cell;
    if (cell.contentView.width != width) {
        cell.contentView.width = width;
    }
    return [[self.tableView cellAutoHeightManager] cellHeightForIndexPath:indexPath model:nil keyPath:nil];
}


#pragma 设置数据
-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray && dataArray.count>0) {
        self->_dataArray = dataArray;
        [self.tableView reloadData];
    }
}


#pragma ASIHttpRequest
#pragma ASIHttpRequest
-(void)requestData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* code = [dic valueForKey:@"code"];
        if ([code integerValue]==0  || [code integerValue]==2) {
            NSArray* tempArray = [dic valueForKey:@"data"];
            NSMutableArray* modelArray=[NSMutableArray new];
            NSDictionary* dic;
            for (int i=0; i<tempArray.count; i++) {
                dic = [tempArray objectAtIndex:i];
                
                Demo9Model *model = [Demo9Model new];
                model.name = [dic valueForKey:@"name"];
                model.address = [dic valueForKey:@"addr"];
                model.iconName = [dic valueForKey:@"photo"];
                model.content = [dic valueForKey:@"content"];
                model.position = [dic valueForKey:@"position"];
                 model.dateTime = [dic valueForKey:@"datetime"];
                model.commentViewHeight = 213+i*20;
                model.commentHeaderViewHeight=33;
                
                //分享
                NSDictionary* dicShare =[dic valueForKey:@"share"];
                if (dicShare) {
                    model.shareDic=dicShare;
                }
                
                //图片
                NSArray* array = [dic valueForKey:@"pic"];
                if (array && array.count>0) {
                    model.picNamesArray =array;
                }
                
                //评论列表
                array = [dic valueForKey:@"comment"];
                if (array && array.count>0) {
                    model.commentArray =array;
                }
                
                //评论列表
                array = [dic valueForKey:@"like"];
                if (array && array.count>0) {
                    model.likersArray =array;
                }
                
                [modelArray addObject:model];
            }
            self.dataArray = modelArray;
            
            
            //保存数据
            if (isRefresh) {
                [self.tableView.header endRefreshing];
            }else{
                [self.tableView.footer endRefreshing];
            }
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
            //            self.startLoading = NO;
            //移除重新加载数据监听
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
        }else if([code intValue]==-1){
            //添加重新加载数据监听
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"reloadData" object:nil];
            //通知系统重新登录
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
        }else{
            self.isNetRequestError = YES;
        }
    }else{
        self.isNetRequestError = YES;
    }
}
@end
