//
//  RoadShowDetailViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RoadShowDetailViewController.h"
#import "TDUtil.h"
#import "ShareView.h"
#import "HttpUtils.h"
#import "DialogUtil.h"
#import "MenuPopView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "RoadShowFooter.h"
#import "RoadShowHeader.h"
#import "NSString+SBJSON.h"
#import "RoadShowBottom.h"
#import "ASIFormDataRequest.h"
#import "VoteViewController.h"
#import "TeamShowViewController.h"
#import "RoadShowViewController.h"
#import "FinialApplyViewController.h"
#import "FinialPlanViewController.h"
#import "InteractionViewController.h"
#import "ShowCommentViewController.h"
#import "FinialSuccessViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "FinialPersonTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WeiboViewControlle.h"
#import "movieViewController.h"
#define LIMIT_FONT_NUMBER 16
@interface RoadShowDetailViewController ()<ASIHTTPRequestDelegate,btnActionDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString* checkIndex; //权限监测
    bool isPriseSelected;
    bool isCollectSelected;
    
    HttpUtils* httpUtils;
    RoadShowHeader* header;
    RoadShowFooter* footer ;
    MenuPopView* menuPopView;
    LoadingView * loadingView;
    RoadShowBottom* bottomView;
    
    
    NSDictionary* dataDic;
    NSMutableArray* contentArray;
}
@property (nonatomic,strong) movieViewController * moviePlayer;//视频播放控制器
@end

@implementation RoadShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //网络初始化
    httpUtils = [[HttpUtils alloc]init];
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"路演详情"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.title forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    [self.navView.rightButton setImage:IMAGENAMED(@"more") forState:UIControlStateNormal];
    [self.navView.rightButton addTarget:self action:@selector(actionMore:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.navView];
    
 self.tableViewCustom=[[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-kTopBarHeight-kStatusBarHeight-20)];
    self.tableViewCustom.bounces=NO;
    self.tableViewCustom.dataSource=self;
    self.tableViewCustom.delegate=self;
    self.tableViewCustom.allowsSelection=YES;
    self.tableViewCustom.delaysContentTouches=NO;
    self.tableViewCustom.showsVerticalScrollIndicator=NO;
    self.tableViewCustom.showsHorizontalScrollIndicator=NO;
    self.tableViewCustom.backgroundColor=[UIColor clearColor];
    self.tableViewCustom.contentSize = CGSizeMake(WIDTH(self.view), HEIGHT(self.view)+50);
    self.tableViewCustom.separatorStyle=UITableViewCellSeparatorStyleNone;

    
    [self.view addSubview:self.tableViewCustom];

    self.view.backgroundColor = ColorTheme;
    
    bottomView = [[RoadShowBottom alloc]initWithFrame:CGRectMake(0, HEIGHT(self.view)-50, WIDTH(self.view), 50)];
    [bottomView.btnFunction addTarget:self action:@selector(goRoadShow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(teamShowAction:) name:@"teamShow" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(collect:) name:@"collect" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(prise:) name:@"prise" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    //加载数据
    [self  loadProjectDetail];
}

-(void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    NSLog(@"%@",aNotification.userInfo);
    
//    MPMoviePlayerController *moviePlayer = (MPMoviePlayerController *)[aNotification object];
//    if (moviePlayer.fullscreen) {
//        moviePlayer.fullscreen = NO;
//    }
//    if (_moviePlayer.moviePlayer.playbackState==MPMoviePlaybackStateStopped) {
//        NSString* url  =header.mediaUrl;
//        [_moviePlayer.moviePlayer setContentURL:[NSURL URLWithString:url]];
//        [_moviePlayer.moviePlayer play];
//        [self.navigationController presentMoviePlayerViewControllerAnimated:_moviePlayer];
//    }
}

-(void)actionMore:(id)sender
{
    if (!menuPopView) {
        NSMutableArray* dataArray = [[NSMutableArray alloc]init];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:@"share_normal" forKey:@"img"];
        [dic setValue:@"分享" forKey:@"title"];
        [dic setValue:@"1" forKey:@"action"];
        [dataArray addObject:dic];
        
        dic = [[NSMutableDictionary alloc]init];
        [dic setValue:@"toupiao_normal" forKey:@"img"];
        [dic setValue:@"投票" forKey:@"title"];
        [dic setValue:@"2" forKey:@"action"];
        [dataArray addObject:dic];
        
        menuPopView = [[MenuPopView alloc]initWithFrame:CGRectMake(WIDTH(self.view)-75, POS_Y(self.navView), 70, 90)];
        menuPopView.dataArray =dataArray;
        menuPopView.delegate = self;
    }
    
    if (!menuPopView.isSelected) {
        [self.view addSubview:menuPopView];
        menuPopView.isSelected = YES;
    }else{
        [menuPopView removeFromSuperview];
        menuPopView.isSelected = NO;
    }
    
}

/**
 *  代理方法 popMenu
 *
 *  @param button 触发事件UIButton
 *  @param data   数据信息
 */
-(void)button:(UIButton *)button data:(NSDictionary*)data
{
    int index = [[data valueForKey:@"action"] intValue];
    switch (index) {
        case 1:
            [self doShare];
            break;
        case 2:
            [self doVote];
            break;
        default:
            [self doShare];
            break;
    }
}


-(void)doShare
{
    ShareView* shareView =[[ShareView alloc]initWithFrame:self.view.frame];
    shareView.type = 0;
    shareView.dic = self.dic;
    [self.view addSubview:shareView];
}

-(void)doVote
{
    UIStoryboard* board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    VoteViewController* controller =(VoteViewController *)[board instantiateViewControllerWithIdentifier:@"Vote"];
    [self.navigationController pushViewController:controller animated:YES];
}

/**
 *  屏幕旋转
 */
-(void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    CGRect frame1;
    CGRect frame2;
    if (isiPhone4) {
         frame1 = CGRectMake(-kTopBarHeight-kStatusBarHeight-16, kTopBarHeight+kStatusBarHeight+16, HEIGHT(self.view), WIDTH(self.view));
         frame2 = CGRectMake(0,0,WIDTH(self.view),HEIGHT(self.view));
    }else if (isiPhone5){
        frame1 = CGRectMake(-kTopBarHeight-kStatusBarHeight-60, kTopBarHeight+kStatusBarHeight+60, HEIGHT(self.view), WIDTH(self.view));
        frame2 = CGRectMake(0,0,WIDTH(self.view),HEIGHT(self.view));
    }else if (isiPhone6){
        frame1 = CGRectMake(-kTopBarHeight-kStatusBarHeight-60, kTopBarHeight+kStatusBarHeight+60, HEIGHT(self.view), WIDTH(self.view));
        frame2 = CGRectMake(0,0,WIDTH(self.view),HEIGHT(self.view));
    }else if (isiPhone6P){
        frame1 = CGRectMake(-kTopBarHeight-kStatusBarHeight-60, kTopBarHeight+kStatusBarHeight+60, HEIGHT(self.view), WIDTH(self.view));
        frame2 = CGRectMake(0,0,WIDTH(self.view),HEIGHT(self.view));    }
    
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [_moviePlayer.view setFrame:frame1];
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(- M_PI_2);
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
    }
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        [_moviePlayer.view setFrame:frame1];
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
    }
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        [_moviePlayer.view setFrame:frame1];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(0);
    }
    
    if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [_moviePlayer.view setFrame:frame2];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2*2);
    }
    
    
    if (orientation == UIInterfaceOrientationUnknown) {
        [_moviePlayer.view setFrame:frame2];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2*2);
    }
    
    if (orientation == UIInterfaceOrientationPortrait) {
        [_moviePlayer.view setFrame:frame2];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(0);
    }

    
}
-(void)playMedia:(id)sender
{
    
    NSString* str = header.mediaUrl;
    if (str && ![str isEqualToString:@""]) {
        NSURL* url = [NSURL URLWithString:str];
        _moviePlayer = [[movieViewController alloc]init];
        [_moviePlayer.moviePlayer setContentURL:url];
        [_moviePlayer.moviePlayer prepareToPlay];
        [self presentMoviePlayerViewControllerAnimated:_moviePlayer];
        
//        [self.moviePlayer.moviePlayer setContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"]]];
        self.moviePlayer.moviePlayer.fullscreen = YES;
        self.moviePlayer.moviePlayer.controlStyle =MPMovieControlStyleFullscreen;
        [self.moviePlayer.moviePlayer play];
    }
}
//收藏
-(void)collect:(NSDictionary*)dic
{
    NSInteger index = [[self.dic valueForKey:@"id"] integerValue];
    NSString* url = [COLLECTE stringByAppendingFormat:@"%ld/",(long)index];
    NSDictionary* dictionary = [[NSMutableDictionary alloc]init];
    index=0;
    if (isCollectSelected) {
        index = 0;
        isCollectSelected = NO;
    }else{
        index = 1;
        isCollectSelected = YES;
    }
    header.isCollect = isCollectSelected;
    [dictionary setValue:[NSString stringWithFormat:@"%ld",(long)index] forKey:@"action"];
    
    [httpUtils getDataFromAPIWithOps:url postParam:dictionary type:0 delegate:self sel:@selector(requestCollecte:)];
}

//点赞
-(void)prise:(NSDictionary*)dic
{
    NSInteger index = [[self.dic valueForKey:@"id"] integerValue];
    NSString* url = [PRISE stringByAppendingFormat:@"%ld/",(long)index];
    NSDictionary* dictionary = [[NSMutableDictionary alloc]init];
    index=0;
    if (isPriseSelected) {
        index = 0;
        isPriseSelected = NO;
    }else{
        index = 1;
        isPriseSelected = YES;
    }
    header.isLike = isPriseSelected;
    [dictionary setValue:[NSString stringWithFormat:@"%ld",(long)index] forKey:@"action"];
    [httpUtils getDataFromAPIWithOps:url postParam:dictionary type:0 delegate:self sel:@selector(requestPrise:)];
}
-(void)loadProjectDetail
{
    contentArray = [[NSMutableArray alloc]init];
    NSMutableDictionary* dic;
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"img1" forKey:@"img"];
    [dic setValue:@"公司简介" forKey:@"title"];
    [contentArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"img2" forKey:@"img"];
    [dic setValue:@"主营业务" forKey:@"title"];
    [contentArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"img4" forKey:@"img"];
    [dic setValue:@"商业模式" forKey:@"title"];
    [contentArray addObject:dic];
    
    loadingView = [LoadingUtil shareinstance:self.view];
    
    if (self.dic) {
        NSString* url = [PROJECT_DETAIL stringByAppendingFormat:@"%ld/",(long)[[self.dic valueForKey:@"id"] integerValue]];
        [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestProjectDetail:)];
        
        [LoadingUtil showLoadingView:self.view withLoadingView:loadingView];
    }
   
}
-(void)setBackTitle:(NSString *)backTitle
{
    self->_backTitle = backTitle;
    [self.navView.leftButton setTitle:backTitle forState:UIControlStateNormal];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    RoadShowTableViewCell* prototypeCell = (RoadShowTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSString* flag;
    if (prototypeCell.isExpand) {
        flag = @"false";
    }else{
        flag = @"true";
    }
    
    switch (row) {
        case 0:
            [dataDic setValue:flag forKey:@"company_profile_lines_flag"];
            break;
        case 1:
            [dataDic setValue:flag forKey:@"business_lines_flag"];
            break;
        case 2:
            [dataDic setValue:flag forKey:@"business_model_lines_flag"];
            break;
        default:
            break;
    }
    [self.tableViewCustom reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataDic) {
        CGFloat height;
        NSInteger lines;
        BOOL flag;
        switch (indexPath.row) {
            case 0:
                flag = [[dataDic valueForKey:@"company_profile_lines_flag"] boolValue];
                lines = [[dataDic valueForKey:@"company_profile_lines"] integerValue];
                break;
            case 1:
                flag = [[dataDic valueForKey:@"business_lines_flag"] boolValue];
                lines = [[dataDic valueForKey:@"business_lines"] integerValue];
                break;
            case 2:
                flag = [[dataDic valueForKey:@"business_model_lines_flag"] boolValue];
                lines = [[dataDic valueForKey:@"business_model_lines"] integerValue];
                break;
            default:
                lines = 1;
                break;
        }
        
        if (!flag) {
            if (lines==0) {
                lines = 1;
            }else if (lines>4){
                lines =4;
            }
        }
        
        
        if (height>4 && !flag) {
            height = 80;
        }else{
            height = lines*20+30;
        }
        return height;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (dataDic) {
        //声明静态字符串对象，用来标记重用单元格
        static NSString* RoadTableDataIdentifier=@"C1dsfds";
        //用TableDataIdentifier标记重用单元格
        RoadShowTableViewCell* prototypeCell=(RoadShowTableViewCell*)[tableView dequeueReusableCellWithIdentifier:RoadTableDataIdentifier];
        //如果单元格未创建，则需要新建
        if (!prototypeCell) {
            prototypeCell = [[RoadShowTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RoadTableDataIdentifier];
        }
        
         CGFloat height =[self tableView:tableView heightForRowAtIndexPath:indexPath];
        [prototypeCell lauyoutResetLayout:CGRectMake(0, 0, WIDTH(self.tableViewCustom), height)];
        
        NSInteger row = indexPath.row;
        
        NSDictionary* dic = contentArray[row];
        prototypeCell.titleLabel.text= [dic valueForKey:@"title"];
        prototypeCell.titleImgView.image = IMAGENAMED([dic valueForKey:@"img"]);
        NSString* content=@"";
        switch (row) {
            case 0:
                content = [dataDic valueForKey:@"company_profile"];
                break;
            case 1:
                content = [dataDic valueForKey:@"business"];
                break;
            case 2:
                content = [dataDic valueForKey:@"business_model"];
                break;
            default:
                break;
        }
        
        NSInteger lines;
        switch (indexPath.row) {
            case 0:
                lines = [[dataDic valueForKey:@"company_profile_lines"] integerValue];
                break;
            case 1:
                lines = [[dataDic valueForKey:@"business_lines"] integerValue];
                break;
            case 2:
                lines = [[dataDic valueForKey:@"business_model_lines"] integerValue];
                break;
            default:
                lines = 0;
                break;
        }
        
        if (lines<4) {
            prototypeCell.isLimit = YES;
            prototypeCell.userInteractionEnabled = NO;
        }
        
        prototypeCell.content = content;
        prototypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return prototypeCell;
    }else{
        return [UITableViewCell new];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contentArray.count;
}

-(void)teamShowAction:(NSDictionary*)dic
{
    NSInteger tag =[[[dic valueForKey:@"userInfo"]valueForKey:@"tag"] integerValue];
    if (tag==10001 || tag==10002) {
        [self FinancePlanViewController:nil];
    }else if(tag==10003 || tag==10004){
        [self FinanceListViewController:nil];
    }else if (tag==10004 || tag==10005){
        NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
        BOOL isAnimous = [[data valueForKey:@"isAnimous"] boolValue];
        if (isAnimous) {
           [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您还未登录，请先登录",@"msg",@"取消",@"cancel",@"去登录",@"sure",@"3",@"type", nil]];
        }else{
            TeamShowViewController* controller = [[TeamShowViewController alloc]init];
            controller.projectId =  [[self.dic valueForKey:@"id"] integerValue];
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }else{
        [self doAction:nil];
    }
}

-(void)goRoadShow:(id)sender
{
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    BOOL isAnimous = [[data valueForKey:@"isAnimous"] boolValue];
    if (isAnimous) {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您还未登录，请先登录",@"msg",@"取消",@"cancel",@"去登录",@"sure",@"3",@"type", nil]];
    }else{
        loadingView.isTransparent = YES;
        [LoadingUtil show:loadingView];
        [httpUtils getDataFromAPIWithOps:ISINVESTOR postParam:nil type:0 delegate:self sel:@selector(requestIsInvestor:)];
    }
    
    
}

-(void)doAction:(id)sender
{
    WeiboViewControlle* controller = [[WeiboViewControlle alloc]init];
    controller.project_id = [[self.dic valueForKey:@"id"] integerValue];
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)FinancePlanViewController:(id)sender
{
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    BOOL isAnimous = [[data valueForKey:@"isAnimous"] boolValue];
    if (isAnimous) {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您还未登录，请先登录",@"msg",@"取消",@"cancel",@"去登录",@"sure",@"3",@"type", nil]];
    }else{
        checkIndex=@"1";
        //监测是否是投资人
        [httpUtils getDataFromAPIWithOps:ISINVESTOR postParam:nil type:0 delegate:self sel:@selector(requestInvestCheck:)];
    }
}



-(void)FinanceListViewController:(id)sender
{
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    BOOL isAnimous = [[data valueForKey:@"isAnimous"] boolValue];
    if (isAnimous) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您还未登录，请先登录",@"msg",@"取消",@"cancel",@"去登录",@"sure",@"3",@"type", nil]];
    }else{
         checkIndex=@"2";
        //监测是否是投资人
        [httpUtils getDataFromAPIWithOps:ISINVESTOR postParam:nil type:0 delegate:self sel:@selector(requestInvestCheck:)];
        }
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma ASIHttpRequester
//===========================================================网络请求=====================================
/**
 *  获取项目信息
 *
 *  @param request 网络请求对象
 */
-(void)requestProjectDetail:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            dataDic = [jsonDic valueForKey:@"data"];
            NSString* content = [dataDic valueForKey:@"company_profile"];
            NSInteger length = [TDUtil convertToInt:content];
            
            [dataDic setValue:[NSString stringWithFormat:@"%ld",length/LIMIT_FONT_NUMBER] forKey:@"company_profile_lines"];
            content = [dataDic valueForKey:@"business"];
            length = [TDUtil convertToInt:content];
            [dataDic setValue:[NSString stringWithFormat:@"%ld",length/LIMIT_FONT_NUMBER] forKey:@"business_lines"];
            content = [dataDic valueForKey:@"business_model"];
            length = [TDUtil convertToInt:content];
            [dataDic setValue:[NSString stringWithFormat:@"%ld",length/LIMIT_FONT_NUMBER] forKey:@"business_model_lines"];
            
            NSDictionary* dic = [dataDic valueForKey:@"project_event"];
            NSString* event = [dic valueForKey:@"event_detail"];
            if (event.class != NSNull.class) {
                footer = [[RoadShowFooter alloc]initWithFrame:CGRectMake(0, 5, WIDTH(self.view), 700)];
                //新闻名称
                [footer.titleLabel  setText:[dic valueForKey:@"event_title"]];
                //日期
                [footer.dateTimeLabel  setText:[dic valueForKey:@"event_date"]];
                //公司重大新闻
                [footer setContent:[dic valueForKey:@"event_detail"]];
                
                [self.tableViewCustom setTableFooterView:footer];
            }
            
            NSDictionary* stageDic = [dataDic valueForKey:@"stage"];
            int index;
            if ([[stageDic valueForKey:@"flag"] intValue]!=1) {
                index =1;
            }else{
                index =0;
            }
            self.type =[[stageDic valueForKey:@"flag"] intValue];
            float height;
            if (index!=0) {
                height = 430;
            }else{
                height = 350;
            }
            header = [[RoadShowHeader alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), height)];
            [self.tableViewCustom setTableHeaderView:header];
            [header.introduceImgview setUserInteractionEnabled: YES];
            [header.introduceImgview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playMedia:)]];
           
            //公司简介项目图片
            [header setIntroduceImage:[dataDic valueForKey:@"project_img"]];
            
            NSInteger colorHex = [[self.dic valueForKey:@"color"] integerValue];
            NSString* hexNumber = [TDUtil ToHex:colorHex];
            UIColor* color = [TDUtil colorWithHexString:hexNumber];
            header.tinColor = color;
            
            
            header.type = index;
            
            //点赞数
            [header setPriserNum:[[dataDic valueForKey:@"like_sum"] integerValue]];
            //收藏数
            [header setCollecteNum:[[dataDic valueForKey:@"collect_sum"] integerValue]];
            
            [header setLeftNum:[dataDic valueForKey:@"participator2plan"]];
            if ([[stageDic valueForKey:@"flag"] intValue]!=1) {
                //融资中或者融资结束
                header.investAmout = [[dataDic valueForKey:@"invest_amount_sum"] stringValue];
                header.amout = [[dataDic valueForKey:@"plan_finance"] stringValue];
            }
            
            //状态
            NSString* mediaUrl = [dataDic valueForKey:@"project_video"];
            
            NSDictionary* dicStage = [stageDic valueForKey:@"start"];
            
            header.leftName = [dicStage valueForKey:@"name"];
            header.industry = [dicStage valueForKey:@"datetime"];
            
            dicStage = [stageDic valueForKey:@"end"];
            header.rightName = [dicStage valueForKey:@"name"];
            header.showTime = [dicStage valueForKey:@"datetime"];
            
            
            bottomView.type = self.type;
            
            float currentAmount = [[dataDic valueForKey:@"invest_amount_sum"] floatValue];
            float totalAmount = [[dataDic valueForKey:@"plan_finance"] floatValue];
            if (totalAmount>0) {
                float process = currentAmount/totalAmount;
                header.process = process;
            }else{
                header.process = 0;
            }
            
            //点赞，收藏
            BOOL isLike = [[dataDic valueForKey:@"is_like"] boolValue];
            BOOL isCollect = [[dataDic valueForKey:@"is_collect"]boolValue];
            
            isPriseSelected = isLike;
            isCollectSelected = isCollect;
            
            header.isLike = isLike;
            header.mediaUrl = mediaUrl;
            header.isCollect = isCollect;
            header.status = [stageDic valueForKey:@"status"];
            [LoadingUtil closeLoadingView:loadingView];
            
            [self.tableViewCustom reloadData];
        }
        
    }
    
}


/**
 *  收藏
 *
 *  @param request
 */
-(void)requestCollecte:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            
        }
        
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        
    }
    
}

/**
 *  点赞
 *
 *  @param request
 */
-(void)requestPrise:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            
        }
        
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
    
}
/**
 *  是否已认证
 *
 *  @param request
 */
-(void)requestIsInvestor:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            if (self.type ==0) {
                NSString* url = [JOIN_ROADSHOW stringByAppendingFormat:@"%ld/",(long)[[self.dic valueForKey:@"id"] integerValue]];
                [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestJoinroadShow:)];
            }else{
                UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                FinialApplyViewController* controller = (FinialApplyViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"FinialApply"];
                controller.titleStr = self.navView.title;
                controller.projectId = [[self.dic valueForKey:@"id"] integerValue];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            [LoadingUtil close:loadingView];
            if ([status intValue] == -9) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[jsonDic valueForKey:@"msg"],@"msg",@"取消",@"cancel",@"去认证",@"sure",checkIndex,@"type", nil]];
            }else{
                [[DialogUtil sharedInstance] showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            }
        }
    }
}

/**
 *  权限检测
 *
 *  @param request
 */
-(void)requestInvestCheck:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            if ([checkIndex isEqualToString:@"1"]) {
                UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                FinialPlanViewController* controller = [board instantiateViewControllerWithIdentifier:@"FinancePlanViewController"];
                controller.projectId =[[self.dic valueForKey:@"id"] integerValue];
                [self.navigationController pushViewController:controller animated:YES];

            }else{
                UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                FinialPersonTableViewController* controller = [board instantiateViewControllerWithIdentifier:@"FinanceListViewController"];
                controller.projectId = [[self.dic valueForKey:@"id"] integerValue];
                [self.navigationController pushViewController:controller animated:YES];
            }
                   }else{
            if ([status intValue] == -9) {
               
                [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[jsonDic valueForKey:@"msg"],@"msg",@"取消",@"cancel",@"去认证",@"sure",checkIndex,@"type", nil]];
            }else{
                [[DialogUtil sharedInstance] showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            }
        }
    }
}

//获取身份认证信息
-(void)requestJoinroadShow:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            FinialSuccessViewController * controller =[[FinialSuccessViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        [LoadingUtil close:loadingView];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    
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
@end
