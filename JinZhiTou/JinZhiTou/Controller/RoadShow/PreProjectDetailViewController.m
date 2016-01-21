//
//  RoadShowDetailViewController.m
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "PreProjectDetailViewController.h"
#import "FoldView.h"
#import "ShareView.h"
#import "MenuPopView.h"
#import "RoadShowFooter.h"
#import "RoadShowHeader.h"
#import "RoadShowBottom.h"
#import "VoteViewController.h"
#import "TeamShowViewController.h"
#import "RoadShowViewController.h"
#import "FinialApplyViewController.h"
#import "FinialPlanViewController.h"
#import "FinialSuccessViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "FinialPersonTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WeiboViewControlle.h"
#import "movieViewController.h"
#import "UserTraceViewController.h"
#define LIMIT_FONT_NUMBER 16
@interface PreProjectDetailViewController ()<RoadShowHeaderDelegate>
{
    UIScrollView* scrollView;
    NSString* checkIndex; //权限监测
    bool isPriseSelected;
    bool isCollectSelected;
    
    RoadShowHeader* header;
    RoadShowFooter* footer ;
    MenuPopView* menuPopView;
    RoadShowBottom* bottomView;
    
    NSDictionary* dataDic;
    NSMutableArray* contentArray;
    
    
    FoldView* mainbussinesView; //公司简介
    FoldView* bussinessModelView; //公司简介
    FoldView* companyIntroduceView; //公司简介
}
@property (nonatomic,strong) movieViewController * moviePlayer;//视频播放控制器
@end

@implementation PreProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"项目详情"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.title forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    
    scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-50)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = BackColor;
    [self.view addSubview:scrollView];
    
    self.view.backgroundColor = ColorTheme;
    
    bottomView = [[RoadShowBottom alloc]initWithFrame:CGRectMake(0, HEIGHT(self.view)-60, WIDTH(self.view), 60)];
    bottomView.isShowSingle = YES;
    [bottomView.btnFunction addTarget:self action:@selector(goRoadShow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomView];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLayout)
                                                 name:@"updateRoadShowLayout"
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

//-(void)actionMore:(id)sender
//{
//    if (!menuPopView) {
//        NSMutableArray* dataArray = [[NSMutableArray alloc]init];
//        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//        [dic setValue:@"share_normal" forKey:@"img"];
//        [dic setValue:@"分享" forKey:@"title"];
//        [dic setValue:@"1" forKey:@"action"];
//        [dataArray addObject:dic];
//        
////        dic = [[NSMutableDictionary alloc]init];
////        [dic setValue:@"toupiao_normal" forKey:@"img"];
////        [dic setValue:@"投票" forKey:@"title"];
////        [dic setValue:@"2" forKey:@"action"];
////        [dataArray addObject:dic];
//        
//        menuPopView = [[MenuPopView alloc]initWithFrame:CGRectMake(WIDTH(self.view)-75, POS_Y(self.navView), 70, 90)];
//        menuPopView.dataArray =dataArray;
//        menuPopView.delegate = self;
//    }
//    
//    if (!menuPopView.isSelected) {
//        [self.view addSubview:menuPopView];
//        menuPopView.isSelected = YES;
//    }else{
//        [menuPopView removeFromSuperview];
//        menuPopView.isSelected = NO;
//    }
//    
//}
//
///**
// *  代理方法 popMenu
// *
// *  @param button 触发事件UIButton
// *  @param data   数据信息
// */
//-(void)button:(UIButton *)button data:(NSDictionary*)data
//{
//    int index = [[data valueForKey:@"action"] intValue];
//    switch (index) {
//        case 1:
//            [self doShare];
//            break;
//        case 2:
//            [self doVote];
//            break;
//        default:
//            [self doShare];
//            break;
//    }
//}


-(void)doShare
{
    ShareView* shareView =[[ShareView alloc]initWithFrame:self.view.frame];
    shareView.type = 0;
//    shareView.dic = self.dic;
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
-(void)collect
{
    NSInteger index = self.project.projectId;
    NSString* url = [UPLOAD_COLLECTE stringByAppendingFormat:@"%ld/",(long)index];
    index=0;
    if (isCollectSelected) {
        index = 1;
        isCollectSelected = NO;
    }else{
        index = 0;
        isCollectSelected = YES;
    }
    header.isCollect = isCollectSelected;
    url  =[url stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)index]];
    
    [self.httpUtil getDataFromAPIWithOps:url type:0 delegate:self sel:@selector(requestCollecte:) method:@"GET"];
}

//点赞
-(void)prise
{
    NSInteger index = self.project.projectId;
    NSString* url = [UPLOAD_PRISE stringByAppendingFormat:@"%ld/",(long)index];
    index=0;
    if (isPriseSelected) {
        index = 1;
        isPriseSelected = NO;
    }else{
        index = 0;
        isPriseSelected = YES;
    }
    header.isLike = isPriseSelected;
    url = [url stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)index]];
    [self.httpUtil getDataFromAPIWithOps:url  type:0 delegate:self sel:@selector(requestPrise:) method:@"GET"];
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
    

    self.startLoading  =YES;
    
    if (self.project) {
        NSString* url = [PRE_PROJECT_DETAIL stringByAppendingFormat:@"%ld/",self.project.projectId];
        [self.httpUtil getDataFromAPIWithOps:url type:0 delegate:self sel:@selector(requestProjectDetail:) method:@"GET"];
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
        
//        CGFloat height =[self tableView:tableView heightForRowAtIndexPath:indexPath];
        
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

-(void)roadShowHeader:(id)roadShowHeader tapTag:(int)tag
{
    if (tag==10001 || tag==10002) {
        [self FinancePlanViewController:nil];
    }else if(tag==10003 || tag==10004){
        [self FinanceListViewController:nil];
    }else if (tag==10004 || tag==10005){
        TeamShowViewController* controller = [[TeamShowViewController alloc]init];
        controller.projectId =  self.project.projectId;;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{
        [self doAction:nil];
    }
}

-(void)goRoadShow:(id)sender
{
    checkIndex=@"5";
    //监测是否是投资人
    [self.httpUtil getDataFromAPIWithOps:ISINVESTOR postParam:nil type:0 delegate:self sel:@selector(requestInvestCheck:)];
    self.startLoading = YES;
    self.isTransparent = YES;
}

-(void)doAction:(id)sender
{
    WeiboViewControlle* controller = [[WeiboViewControlle alloc]init];
    controller.titleStr = @"项目详情";
    controller.project_id = self.project.projectId;;
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)FinancePlanViewController:(id)sender
{
    checkIndex=@"1";
    //监测是否是投资人
    [self.httpUtil getDataFromAPIWithOps:ISINVESTOR postParam:nil type:0 delegate:self sel:@selector(requestInvestCheck:)];
    self.startLoading = YES;
    self.isTransparent = YES;

}


-(void)loadInvestCheck
{
     [self.httpUtil getDataFromAPIWithOps:ISINVESTOR postParam:nil type:0 delegate:self sel:@selector(requestInvestCheck:)];
}

-(void)FinanceListViewController:(id)sender
{
    checkIndex=@"2";
    //监测是否是投资人
    [self.httpUtil getDataFromAPIWithOps:ISINVESTOR postParam:nil type:0 delegate:self sel:@selector(requestInvestCheck:)];
    self.startLoading = YES;
    self.isTransparent = YES;
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
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0 || [code intValue] == 2) {
            dataDic = [jsonDic valueForKey:@"data"];
            
            NSDictionary* stageDic = [dataDic valueForKey:@"stage"];
            float height;
            if (self.type!=0) {
                height = 375;
            }else{
                height = 220;
            }
            header = [[RoadShowHeader alloc]initWithFrame:CGRectMake(0,0, WIDTH(self.view), height)];
            header.delegate = self;
            [header.introduceImgview setUserInteractionEnabled: YES];
            [header.introduceImgview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playMedia:)]];
            
            //公司简介项目图片
            [header setIntroduceImage:self.project.imgUrl];
            
            NSInteger colorHex = [[stageDic valueForKey:@"color"] integerValue];
            NSString* hexNumber = [TDUtil ToHex:colorHex];
            UIColor* color = [TDUtil colorWithHexString:hexNumber];
            header.tinColor = color;
            
            header.type = self.type;
            
            //点赞数
            [header setPriserNum:[[dataDic valueForKey:@"like"] integerValue]];
            //收藏数
            [header setCollecteNum:[[dataDic valueForKey:@"collect"] integerValue]];
            
            if ([[stageDic valueForKey:@"flag"] intValue]!=1) {
               
            }
            
            //融资中或者融资结束
            header.investAmout = [[dataDic valueForKey:@"planfinance"] stringValue];
            header.amout = [[dataDic valueForKey:@"invest"] stringValue];
            
            //状态
            NSString* mediaUrl = [dataDic valueForKey:@"vcr"];
            
            NSDictionary* dicStage = [stageDic valueForKey:@"start"];
            header.startDic = [stageDic valueForKey:@"start"];
            header.endDic = [stageDic valueForKey:@"end"];
            header.leftName = [dicStage valueForKey:@"name"];
            header.industry = [dicStage valueForKey:@"datetime"];
            
            dicStage = [stageDic valueForKey:@"end"];
            header.rightName = [dicStage valueForKey:@"name"];
            header.showTime = [dicStage valueForKey:@"datetime"];
            
            header.daysLeave = [[stageDic valueForKey:@"daysLeave"] integerValue];
            header.maxDays = [[stageDic valueForKey:@"daysTotal"] floatValue];
           
            
            bottomView.type = self.type;
            
            
            if (![TDUtil isValideTime:header.industry]) {
                bottomView.btnFunction.enabled = NO;
                bottomView.btnFunction.backgroundColor = BACKGROUND_LIGHT_GRAY_COLOR;
                [bottomView.btnFunction setTitle:@"尚未开始" forState:UIControlStateNormal];
                
            }
            float currentAmount = [[dataDic valueForKey:@"invest"] floatValue];
            float totalAmount = [[dataDic valueForKey:@"planfinance"] floatValue];
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
            header.status = [[dataDic valueForKey:@"stage"] valueForKey:@"code"];
            [scrollView addSubview:header];
            
            
            UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(header), WIDTH(self.view), 10)];
            v.backgroundColor = WriteColor;
            [scrollView addSubview:v];
            
            companyIntroduceView = [[FoldView alloc]initWithFrame:CGRectMake(0, POS_Y(header)+10, WIDTH(self.view), 150)];
            companyIntroduceView.imageView.image = IMAGENAMED(@"img1");
            companyIntroduceView.labelTitle.text = @"公司简介";
            companyIntroduceView.isStart  = YES;
            [scrollView addSubview:companyIntroduceView];
        
            
            mainbussinesView = [[FoldView alloc]initWithFrame:CGRectMake(0, POS_Y(companyIntroduceView)+1, WIDTH(self.view), 150)];
            mainbussinesView.imageView.image = IMAGENAMED(@"img2");
            mainbussinesView.labelTitle.text = @"主营业务";
            [scrollView addSubview:mainbussinesView];
            
            bussinessModelView = [[FoldView alloc]initWithFrame:CGRectMake(0, POS_Y(mainbussinesView)+1, WIDTH(self.view), 150)];
            bussinessModelView.isEnd  = YES;
            bussinessModelView.labelTitle.text = @"商业模式";
            bussinessModelView.imageView.image = IMAGENAMED(@"img4");
            [scrollView addSubview:bussinessModelView];
            
            NSString* event = [dataDic valueForKey:@"event"];
            if ([TDUtil isValidString:event]) {
                footer = [[RoadShowFooter alloc]initWithFrame:CGRectMake(0, POS_Y(bussinessModelView), WIDTH(self.view), 700)];
                //新闻名称
                //[footer.titleLabel  setText:[dic valueForKey:@"event_title"]];
                //日期
               // [footer.dateTimeLabel  setText:[dic valueForKey:@"event_date"]];
                //公司重大新闻
                [footer setContent:event];
                //底部
                [scrollView addSubview:footer];
            }
            //装配

            [companyIntroduceView.nextViews addObject:mainbussinesView];
            [companyIntroduceView.nextViews addObject:bussinessModelView];
            
            [mainbussinesView.nextViews addObject:bussinessModelView];
            if (footer) {
                [companyIntroduceView.nextViews addObject:footer];
                [mainbussinesView.nextViews addObject:footer];
                [bussinessModelView.nextViews addObject:footer];
            }
            
            NSString* content = [dataDic valueForKey:@"profile"];
            companyIntroduceView.content  =content;
            content = [dataDic valueForKey:@"business"];
            mainbussinesView.content = content;
            content = [dataDic valueForKey:@"model"];
            bussinessModelView.content =content;
            
            self.startLoading = NO;
            //更新布局
            [self updateLayout];
            //移除重新加载数据
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
        }else if ([code intValue]==-1){
            //添加重新加载数据监听
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadProjectDetail) name:@"reloadData" object:nil];
            //通知系统重新登录
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
            
        }else{
            self.isNetRequestError = YES;
        }
        
    }
    
}

-(void)updateLayout
{
    if (footer) {
        [scrollView setContentSize:CGSizeMake(WIDTH(self.view), POS_Y(footer)+20)];
    }else{
        [scrollView setContentSize:CGSizeMake(WIDTH(self.view), POS_Y(bussinessModelView)+60)];
    }
}

/**
 *  刷新
 */
-(void)refresh
{
    [super refresh];
    [self loadProjectDetail];
    self.startLoading = YES;
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
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSString* auth = [[jsonDic valueForKey:@"data"] valueForKey:@"auth"];
            
            if ([checkIndex isEqualToString:@"1"]) {
                
                if (![auth isKindOfClass:NSNull.class]) {
                    if (auth) {
                        if ([auth respondsToSelector:@selector(isEqualToString:)]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您还未进行投资人身份认证，请先认证",@"msg",@"取消",@"cancel",@"去认证",@"sure",@"0",@"type",self,@"vController", nil]];
                        }else{
                            if([auth boolValue]){
                                UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                FinialPlanViewController* controller = [board instantiateViewControllerWithIdentifier:@"FinancePlanViewController"];
                                controller.projectId =self.project.projectId;;
                                [self.navigationController pushViewController:controller animated:YES];
                            }else if(![auth boolValue]){
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您的投资人身份认证未审核通过，请先联系客服",@"msg",@"",@"cancel",@"确定",@"sure",@"4",@"type",self,@"vController", nil]];
                            }
                        }
                    }
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您的投资人身份认证正在审核中，请耐心等待",@"msg",@"",@"cancel",@"确定",@"sure",@"4",@"type",self,@"vController", nil]];
                }
            }else if ([checkIndex isEqualToString:@"2"]){
                if (![auth isKindOfClass:NSNull.class]) {
                    if (auth) {
                        if ([auth respondsToSelector:@selector(isEqualToString:)]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您还未进行投资人身份认证，请先认证",@"msg",@"取消",@"cancel",@"去认证",@"sure",@"0",@"type",self,@"vController", nil]];
                        }else{
                            if([auth boolValue]){
                                UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                FinialPersonTableViewController* controller = [board instantiateViewControllerWithIdentifier:@"FinanceListViewController"];
                                controller.projectId = self.project.projectId;
                                [self.navigationController pushViewController:controller animated:YES];
                            }else if(![auth boolValue]){
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您的投资人身份认证未审核通过，请先联系客服",@"msg",@"",@"cancel",@"确定",@"sure",@"4",@"type",self,@"vController", nil]];
                            }
                        }
                    }
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您的投资人身份认证正在审核中，请耐心等待",@"msg",@"",@"cancel",@"确定",@"sure",@"4",@"type",self,@"vController", nil]];
                }
                
            }else if([checkIndex isEqualToString:@"5"]){
                if (![auth isKindOfClass:NSNull.class]) {
                    if (auth) {
                        if ([auth respondsToSelector:@selector(isEqualToString:)]) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您还未进行投资人身份认证，请先认证",@"msg",@"取消",@"cancel",@"去认证",@"sure",@"0",@"type",self,@"vController", nil]];
                        }else{
                            if([auth boolValue]){
                                if (self.type ==1) {
                                    NSString* url = [JOIN_ROADSHOW stringByAppendingFormat:@"%ld/",self.project.projectId];
                                    [self.httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestJoinroadShow:)];
                                }else{
                                    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                                    FinialApplyViewController* controller = (FinialApplyViewController*)[storyBoard instantiateViewControllerWithIdentifier:@"FinialApply"];
                                    controller.titleStr = self.navView.title;
                                    controller.projectId = self.project.projectId;
                                    [self.navigationController pushViewController:controller animated:YES];
                                }
                            }else if(![auth boolValue]){
                                [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您的投资人身份认证未审核通过，请先联系客服",@"msg",@"",@"cancel",@"确定",@"sure",@"4",@"type",self,@"vController", nil]];
                            }
                        }
                    }
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"您的投资人身份认证正在审核中，请耐心等待",@"msg",@"",@"cancel",@"确定",@"sure",@"4",@"type",self,@"vController", nil]];
                }
            }else{
                UIStoryboard* board =[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                FinialPersonTableViewController* controller = [board instantiateViewControllerWithIdentifier:@"FinanceListViewController"];
                controller.projectId = self.project.projectId;
                [self.navigationController pushViewController:controller animated:YES];
            }
            
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
        }else{
            if ([code intValue]==1) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[jsonDic valueForKey:@"msg"],@"msg",@"",@"cancel",@"确认",@"sure",@"4",@"type",self,@"vController", nil]];
            }else if([code intValue]==-1){
                //添加监听
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadInvestCheck) name:@"reloadData" object:nil];
                //通知系统重新登录
                [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
            }
        }
    }else{
        [[DialogUtil sharedInstance] showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
    self.startLoading=NO;
}

//获取身份认证信息
-(void)requestJoinroadShow:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
//            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
//            FinialSuccessViewController * controller =[[FinialSuccessViewController alloc]init];
//            controller.titleStr =@"来现场报名";
//            controller.content = @"    尊敬的用户，您的来现场申请已提交，48小时内会有工作人员与您联系，您也可以在“个人中心”－－“进度查看”中查看到审核进度。";
//            [self.navigationController pushViewController:controller animated:YES];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[jsonDic valueForKey:@"msg"],@"msg",@"",@"cancel",@"确认",@"sure",@"4",@"type",self,@"vController", nil]];
        }else if([code intValue] == 1){
//            [[DialogUtil sharedInstance] showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
//            //[NSThread sleepForTimeInterval:2.0f];
//            //进度查看
//            double delayInSeconds = 1.0;
//            //__block RoadShowDetailViewController* bself = self;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                UserTraceViewController* controller = [[UserTraceViewController alloc]init];
//                //来现场
//                controller.titleStr = self.navView.title;
//                controller.currentSelected = 1001;
//                [self.navigationController pushViewController:controller animated:YES];
//
//            
//            });
            [[NSNotificationCenter defaultCenter]postNotificationName:@"alert" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[jsonDic valueForKey:@"msg"],@"msg",@"",@"cancel",@"确认",@"sure",@"4",@"type",self,@"vController", nil]];
            
        }
        self.startLoading  =NO;
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