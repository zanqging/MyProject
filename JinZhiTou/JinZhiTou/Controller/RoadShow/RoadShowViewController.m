//
//  RoadShowViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/23.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RoadShowViewController.h"
#import "APService.h"
#import "WaterFLayout.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import "CycleScrollView.h"
#import "UIImageView+WebCache.h"
#import "BannerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RoadShowHomeHeaderView.h"
#import "RoadShowHomeTableViewCell.h"
#import "RoadShowDetailViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface RoadShowViewController ()<LoadingViewDelegate,WaterFDelegate,UITableViewDataSource,UITableViewDelegate,RoadShowHomeDelegate>
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
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorTheme,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    //设置背景颜色
    self.view.backgroundColor=ColorTheme;
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    //设置标题
    self.navView.imageView.alpha=0;
    [self.navView setTitle:@"金指投"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:IMAGENAMED(@"top-caidan") forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction:)]];
    //==============================TabBarItem 设置==============================//

    //==============================tableView 设置==============================//
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-113)];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellAccessoryNone;
   [self.view addSubview:self.tableView];
    
    //头部
    headerView = [[RoadShowHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), HEIGHT(self.view)*0.618+30)];
   [self.tableView setTableHeaderView:headerView];
   [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    //加载Banner数据
    [self loadHomeData];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(RoadShowProject:) name:@"RoadShowProject" object:nil];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInteractionEnabled:) name:@"userInteractionEnabled" object:nil];
    //提示框
    dialogView = [[DialogView alloc]initWithFrame:self.view.frame];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewMessage:) name:@"updateMessageStatus" object:nil];
    
    [self updateNewMessage:nil];
    
//    [self.httpUtil getDataFromAPIWithOps:WECHAT_OPENID postParam:[NSDictionary dictionaryWithObject:@"weixichenshengzhu" forKey:@"openid"] type:0 delegate:self sel:@selector(requestFinished:)];
    //NSString* serverUrl = [WECHAT_OPENID stringByAppendingString:@"weixichenshengzhu/"];
//    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestFinished:)];
//    [self.httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:[NSDictionary dictionaryWithObject:@"weixichenshengzhu" forKey:@"openid"] type:0 delegate:self sel:@selector(requestFinished:)];
    
//    NSString* serverUrl = [SEND_MESSAGE_CODE stringByAppendingFormat:@"0/1/"];
//    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:[NSDictionary dictionaryWithObjectsAndKeys:@"18729342354",@"tel",@"weixichenshengzhu",@"openid", nil] type:0 delegate:self sel:@selector(requestFinished:)];
    

//    [self.httpUtil getDataFromAPIWithOps:USER_REGIST postParam:[NSDictionary dictionaryWithObjectsAndKeys:@"18729342354",@"tel",@"4070",@"code",@"陈生珠",@"nikename",@"weixichenshengzhu",@"openid", nil] type:0 delegate:self sel:@selector(requestFinished:)];
 
//    NSString* serverUrl = [USER_REGIST stringByAppendingFormat:@"1/"];
//    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:[NSDictionary dictionaryWithObjectsAndKeys:@"18729342354",@"tel",@"4070",@"code",@"陈生珠",@"nikename",@"weixichenshengzhu",@"openid",@"214325",@"regid",nil] file:STATIC_USER_HEADER_PIC postName:@"file" type:0  delegate:self sel:@selector(requestFinished:)];
    
//    [self.httpUtil getDataFromAPIWithOps:USER_LOGIN postParam:[NSDictionary dictionaryWithObjectsAndKeys:@"18729342354",@"tel",@"4070",@"code",@"陈生珠",@"nikename",@"weixichenshengzhu",@"openid",@"214325",@"regid",nil] type:0 delegate:self sel:@selector(requestFinished:)];
    
    //播放音效
    [self playSoundEffect:@"message.caf"];
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
    self.startLoading = YES;
//    [self.httpUtil getDataFromAPIWithOps:HOME_DATA postParam:nil type:0 delegate:self sel:@selector(requestHomeData:)];
    [self.httpUtil getDataFromAPIWithOps:HOME_DATA type:0 delegate:self sel:@selector(requestHomeData:) method:@"GET"];
}


-(void)loadFinished
{
    
}
-(void)RoadShowProject:(NSMutableDictionary*)dic
{
    NSMutableDictionary* dataDic = [[dic valueForKey:@"userInfo"] valueForKey:@"data"];
    RoadShowDetailViewController* controller=[[RoadShowDetailViewController alloc]init];
    controller.title = self.navView.title;
    controller.dic =dataDic;
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
            self.dataDic = [jsonDic valueForKey:@"data"];
            dataArray  = [self.dataDic valueForKey:@"project"];
            headerView.delegate = self;
            headerView.dataDic = self.dataDic;
            
            //刷新tableView
            [self.tableView reloadData];
        }
        self.startLoading = NO;
    }else{
        self.isNetRequestError  =YES;
    }
    
}


-(void)refresh
{
    [super refresh];
    [self loadHomeData];
}

//==============================RoadShowDelegate==============================//
-(void)roadShowHome:(id)roadShowHome controller:(UIViewController *)controller
{
    [self.navigationController pushViewController:controller animated:YES];
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
    return 100;
}
-(UITableViewCell*)tableView:(UITableView *)tableViewInstance cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    static NSString* RoadShowTableIdentifier=@"RoadShowHomeTableViewCell";
    //用TableDataIdentifier标记重用单元格
    RoadShowHomeTableViewCell* cellInstance=(RoadShowHomeTableViewCell*)[tableViewInstance dequeueReusableCellWithIdentifier:RoadShowTableIdentifier];
    if (!cellInstance) {
//        float height = [self tableView:tableViewInstance heightForRowAtIndexPath:indexPath];
//        cellInstance = [[RoadShowHomeTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
//        cellInstance.restorationIdentifier = RoadShowTableIdentifier;
        
        cellInstance  = [[RoadShowHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RoadShowTableIdentifier];
    }
    NSInteger row = indexPath.row;
    NSDictionary* dic = dataArray[row];
    [cellInstance setTime:[dic valueForKey:@"time"]];
    [cellInstance setImageName:[dic valueForKey:@"img"]];
    [cellInstance setProess:[dic valueForKey:@"process"]];
    [cellInstance setCompanyName:[dic valueForKey:@"company"]];
    cellInstance.selectionStyle = UITableViewCellSelectionStyleDefault;
    cellInstance.selectionStyle = UITableViewCellSelectionStyleNone;
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
@end
