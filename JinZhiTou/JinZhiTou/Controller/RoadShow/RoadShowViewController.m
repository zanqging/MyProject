//
//  RoadShowViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/23.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RoadShowViewController.h"
#import "Project.h"
#import "APService.h"
#import "AnnounceView.h"
#import "WaterFLayout.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "CycleScrollView.h"
#import "UserInfoConfigView.h"
#import "UIImageView+WebCache.h"
#import "BannerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RoadShowHomeHeaderView.h"
#import "FinialAuthViewController.h"
#import "UserInfoConfigController.h"
#import "UserInfoConfigController.h"
#import "RoadShowHomeTableViewCell.h"
#import "RoadShowDetailViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#import "WeChatBindController.h"
@interface RoadShowViewController ()<LoadingViewDelegate,WaterFDelegate,UITableViewDataSource,UITableViewDelegate,RoadShowHomeDelegate,UserInfoConigDelegate>
{
    DialogView* dialogView;
    RoadShowHomeHeaderView* headerView;
    NSMutableArray* dataArray;
}
@property (nonatomic , retain) CycleScrollView *mainScorllView;
@property(retain,nonatomic)UIScrollView *scrollView;
@end

@implementation RoadShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //==============================TabBarItem 设置==============================//
    UIImage* image=IMAGENAMED(@"btn-weiluyan 1");
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setSelectedImage:image];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:AppColorTheme,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    //设置背景颜色
    self.view.backgroundColor=ColorTheme;
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    //设置标题
    self.navView.imageView.alpha=0;
    [self.navView setTitle:@"金指投"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:IMAGENAMED(@"home") forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction:)]];
    //==============================TabBarItem 设置==============================//

    //==============================tableView 设置==============================//
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-113) style:UITableViewStyleGrouped];
    self.tableView.bounces=NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellAccessoryNone;
   [self.view addSubview:self.tableView];
    
    //头部
    headerView = [[RoadShowHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), HEIGHT(self.view)*0.5-10)];
    headerView.delegate = self;
   [self.tableView setTableHeaderView:headerView];
   [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RoadShowProject:) name:@"RoadShowProject" object:nil];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInteractionEnabled:) name:@"userInteractionEnabled" object:nil];
    //提示框
    dialogView = [[DialogView alloc]initWithFrame:self.view.frame];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewMessage:) name:@"updateMessageStatus" object:nil];
    
    NSUserDefaults* dataDefaults = [NSUserDefaults standardUserDefaults];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAuthView:) name:@"showAuth" object:nil];

    if (![[dataDefaults valueForKey:@"info"] boolValue]) {
        [self announViewShow:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userinfoConfig:) name:@"userinfoConfig" object:nil];
    }
        //播放音效
//    [self playSoundEffect:@"message.caf"];
    //加载离线数据
    [self loadOfflineData];
    //加载数据
    [self loadData];
}

-(void)loadOfflineData
{
    //从本地获取离线数据
    Project* projectModel = [[Project alloc]init];
    
    dataArray = [projectModel selectData:100 andOffset:0];
    
    //刷新表格视图加载离线数据
    [self.tableView reloadData];
}

-(void)loadData
{
    //加载Banner数据
    [self loadHomeData];
    [self updateNewMessage:nil];
}

-(void)announViewShow:(id)sender
{
    AnnounceView* announceView =[[AnnounceView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), 40)];
    announceView.tag=60001;
    [announceView setAnnounContent:@"您还未完善信息" middleContent:@"立即完善" endContent:@""];
    [announceView.contentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userinfoConfig:)]];
    [self.view addSubview:announceView];
}

-(void)userinfoConfig:(id)sender
{
    int type=1;
    if ([sender isKindOfClass:NSNotification.class]) {
        type = [[[(NSNotification*)sender valueForKey:@"userInfo"] valueForKey:@"type"] intValue];
    }
    UserInfoConfigController* controller =[[UserInfoConfigController alloc]init];
    [self roadShowHome:nil controller:controller type:type];
   
}


-(void)showAuthView:(NSNotification*)sender
{
    NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
    if(![[dataStore valueForKey:@"info"] boolValue]){
        NSNotification* notification = [[NSNotification alloc]initWithName:@"auth" object:nil userInfo:[NSDictionary dictionaryWithObject:@"0" forKey:@"type"]];
        [self userinfoConfig:notification];
        [[DialogUtil sharedInstance]showDlg:[UIApplication sharedApplication].windows[0] textOnly:@"您还未完善信息先完善信息!"];
    }else{
        
        UIViewController* vController = [[sender valueForKey:@"userInfo"]valueForKey:@"viewController"];
        UserInfoConfigView* configView =[[UserInfoConfigView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(vController.view))];
        configView.viewController = vController;
        configView.delegate  =self;
//        [self.view addSubview:configView];
        
        
        int num = 0 ;
        for (UIView* instance in [UIApplication sharedApplication].windows[0].rootViewController.view.subviews) {
            if ([instance isKindOfClass:configView.class]) {
                num ++;
            }
        }
        if (num==0) {
            [[UIApplication sharedApplication].windows[0].rootViewController.view addSubview:configView];
        }
        
        UIView* view = [self.view viewWithTag:60001];
        if (view) {
            [view removeFromSuperview];
        }
    }
    
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放已完成....");
}


/**
 *  播放音效
 *
 *  @param fileName 音频文件名称
 */
-(void)playSoundEffect:(NSString*)fileName
{
    //取得播放视频文件在系统中的路径
    NSString* audioFile = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    //NSUrl 格式化
    NSURL* url = [NSURL URLWithString:audioFile];
    //获得系统声音播放ID
    SystemSoundID soundID = 0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    //回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //播放音频
    AudioServicesPlaySystemSound(soundID);
//    AudioServicesPlayAlertSound(soundID);
}

-(void)updateNewMessage:(NSDictionary*)dic
{
    NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
    NSInteger newMessageCount = [[dataStore valueForKey:@"NewMessageCount"] integerValue];
    NSInteger systemMessageCount = [[dataStore valueForKey:@"SystemMessageCount"] integerValue];
    if (newMessageCount+systemMessageCount>0) {
        [self.navView setIsHasNewMessage:YES];
    }else{
        [self.navView setIsHasNewMessage:NO];
    }

}


-(void)userInteractionEnabled:(NSDictionary*)dic
{
    BOOL isUserInteractionEnabled = [[[dic valueForKey:@"userInfo"] valueForKey:@"userInteractionEnabled"] boolValue];
    self.view.userInteractionEnabled = isUserInteractionEnabled;
}
-(void)loadHomeData
{
    //加载页面
//    self.startLoading = YES;
//    [self.httpUtil getDataFromAPIWithOps:HOME_DATA postParam:nil type:0 delegate:self sel:@selector(requestHomeData:)];
    [self.httpUtil getDataFromAPIWithOps:HOME_DATA type:0 delegate:self sel:@selector(requestHomeData:) method:@"GET"];
}


-(void)loadFinished
{
    
}
-(void)RoadShowProject:(NSNotification*)notification
{
    NSMutableDictionary* dic = [[notification valueForKey:@"userInfo"] valueForKey:@"data"];
    RoadShowDetailViewController* controller=[[RoadShowDetailViewController alloc]init];
    controller.title = self.navView.title;
    controller.dic = dic;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)userInfoAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil];
}



#pragma ASIHttpRequester
//===========================================================网络请求=====================================
-(void)requestHomeData:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            self.dataDic = jsonDic;
            headerView.dataDic = [self.dataDic valueForKey:@"data"];
            dataArray  = [[self.dataDic valueForKey:@"data"] valueForKey:@"project"];
            
            //保存离线数据
//            NSMutableArray* projectArray = [[NSMutableArray alloc]init];

            Project* projectModel;
            projectModel = [[Project alloc]init];
            //移除缓存数据
            [projectModel  deleteData];
            //替换本地数据
            projectModel = [[Project alloc]init];
            //缓存离线数据
            [projectModel insertCoreData:dataArray];
            //刷新tableView
            [self.tableView reloadData];
//            self.startLoading = NO;
            
            //移除重新加载数据监听
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
        }else if ([code intValue]==-1){
            //添加监听
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"reloadData" object:nil];
            //通知系统重新登录
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
        }else{
            self.isNetRequestError  =YES;
        }
    }else{
        self.isNetRequestError  =YES;
    }
    
}


-(void)refresh
{
    [super refresh];
    [self loadHomeData];
}


-(void)userInfoConfigView:(id)userInfoConfigView target:(UIViewController *)c selectedIndex:(int)index data:(NSDictionary *)data
{
    FinialAuthViewController* controller = [[FinialAuthViewController alloc]init];
    controller.type = index;
    controller.titleStr = @"首页";
    if (![c isKindOfClass:UserInfoConfigController.class]) {
        [c.navigationController pushViewController:controller animated:YES];
    }else{
    
//        [self.navigationController pushViewController:controller animated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushController" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:controller,@"viewController", nil]];
    }
}

//==============================RoadShowDelegate==============================//
-(void)roadShowHome:(id)roadShowHome controller:(UIViewController *)controller type:(int)type
{
    if (type==0) {
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}
//==============================RoadShowDelegate==============================//

//==============================TableView区域开始==============================//
-(void)tableView:(UITableView *)tableViewInstance didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoadShowDetailViewController* controller = [[RoadShowDetailViewController alloc]init];
    controller.type=1;
    controller.title = self.navView.title;
    controller.dic = dataArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableViewInstance heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}
-(UITableViewCell*)tableView:(UITableView *)tableViewInstance cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    static NSString* RoadShowTableIdentifier=@"RoadShowHomeTableViewCellIdentifier";
    //用TableDataIdentifier标记重用单元格
    RoadShowHomeTableViewCell* cellInstance=(RoadShowHomeTableViewCell*)[tableViewInstance dequeueReusableCellWithIdentifier:RoadShowTableIdentifier];
    if (cellInstance==nil) {
        cellInstance  = [[RoadShowHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RoadShowTableIdentifier];
    }
    
    NSInteger row = indexPath.row;
    NSDictionary * dic = [dataArray objectAtIndex:row];
    
    [cellInstance setImageName:DICVFK(dic, @"img")];
    [cellInstance setDateTime:DICVFK(dic, @"date")];
    [cellInstance setIndustory:DICVFK(dic, @"tag")];
    [cellInstance setHasFinance:DICVFK(dic, @"invest")];
    [cellInstance setCompanyName:DICVFK(dic, @"abbrevcompany")];
    
    cellInstance.selectionStyle = UITableViewCellSelectionStyleDefault;
    [self.tableView setContentSize:CGSizeMake(WIDTH(tableViewInstance), dataArray.count*115+HEIGHT(headerView)+5)];
    return cellInstance;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableViewInstance numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
//==============================TableView区域结束==============================//

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //取消tableViewCell选中状态
    NSIndexPath *selected = [self.tableView indexPathForSelectedRow];
    if(selected) [self.tableView deselectRowAtIndexPath:selected animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
