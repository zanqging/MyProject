//
//  RoadShowHomeHeaderView.m
//  JinZhiTou
//
//  Created by air on 15/11/4.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import "RoadShowHomeHeaderView.h"
#import "Banner.h"
#import "Platform.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "Announcement.h"
#import "INSViewController.h"
#import "BannerViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "RoadShowDetailViewController.h"
@implementation RoadShowHomeHeaderView

-(id)initWithFrame:(CGRect)frame withData:(NSDictionary *)data
{
    if (self = [self initWithFrame:frame]) {
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), 150)];
        view.backgroundColor = WriteColor;
        view.tag=1000;
        [self addSubview:view];
        
        self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectInset(view.frame, 1, 1) animationDuration:2];
        self.mainScorllView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        [view addSubview:self.mainScorllView];
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(view), WIDTH(self)/3,40)];
        view.backgroundColor = WriteColor;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notificationAction:)]];
        [self addSubview:view];
        
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-15,10,30,30)];
        imgView.image = IMAGENAMED(@"platform_notice");
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:imgView];
        
        //新手指南
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(view), WIDTH(view), 30)];
        label.tag=1001;
        label.font=SYSTEMFONT(14);
        label.userInteractionEnabled = YES;
        label.textColor  =FONT_COLOR_BLACK;
        label.backgroundColor  =WriteColor;
        label.userInteractionEnabled = YES;
        label.textAlignment =NSTextAlignmentCenter;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notificationAction:)]];
        [self addSubview:label];
        
        
        view = [[UIView alloc]initWithFrame:CGRectMake(POS_X(view)+1, Y(view), WIDTH(self)/3,HEIGHT(view))];
        view.backgroundColor = WriteColor;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notionAction:)]];
        [self addSubview:view];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-15,10,WIDTH(imgView),HEIGHT(imgView))];
        imgView.image = IMAGENAMED(@"annocumment");
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:imgView];
        
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)+1, Y(label), WIDTH(label), HEIGHT(label))];
        label.tag=1002;
        label.font=SYSTEMFONT(14);
        label.textColor  =FONT_COLOR_GRAY;
        label.backgroundColor  =WriteColor;
        label.userInteractionEnabled  =YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notionAction:)]];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        view = [[UIView alloc]initWithFrame:CGRectMake(POS_X(view)+1, Y(view), WIDTH(self)/3,HEIGHT(view))];
        view.backgroundColor = WriteColor;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(creditSearchAction:)]];
        [self addSubview:view];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-15,10,WIDTH(imgView),HEIGHT(imgView))];
        imgView.image = IMAGENAMED(@"credit");
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:imgView];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)+1, Y(label), WIDTH(label), HEIGHT(label))];
        label.tag=1003;
        label.text = @"征信查询";
        label.font=SYSTEMFONT(14);
        label.textColor  =FONT_COLOR_GRAY;
        label.backgroundColor  =WriteColor;
        label.userInteractionEnabled  =YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(creditSearchAction:)]];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        
        //精选项目
        view = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(self)-50, WIDTH(self), 50)];
        view.backgroundColor = WriteColor;
        [self addSubview:view];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self)/2-0.5, 30)];
        label.text = @"精选项目";
        label.font=SYSTEMFONT(16);
        label.textAlignment  =NSTextAlignmentCenter;
        label.textColor  =FONT_COLOR_GRAY;
        [view addSubview:label];
        
        //图标
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(label)+WIDTH(self)/4-10, POS_Y(label), 15, 15)];
        imgView.image = IMAGENAMED(@"project");
        [view addSubview:imgView];
        
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)+0.5, 0, WIDTH(label), HEIGHT(label))];
        label.text = @"客服电话";
        label.font=SYSTEMBOLDFONT(16);
        label.userInteractionEnabled  =YES;
        label.textAlignment = NSTextAlignmentCenter;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callService:)]];
        label.textColor  =AppColorTheme;
        [view addSubview:label];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(X(label)+WIDTH(self)/4-10, Y(imgView), 15, 15)];
        imgView.image = IMAGENAMED(@"tel");
        [view addSubview:imgView];
        
        self.backgroundColor = BackColor;
        
        [self loadOffLineData];
    }
    return self;
}

-(void)loadOffLineData
{
    //初始化Banner数据操作对象
    Banner* banner = [[Banner alloc]init];
    //获取离线数据
    self.bannerArray = [banner selectData:100 andOffset:0];
    
    [self resetBannerData];
    //新手指南
    Announcement* cement = [[Announcement alloc]init];
    NSArray* array = [cement selectData:100 andOffset:0];
    if(array && array.count>0){
        NSDictionary * dic = array[0];
        //公告
        UILabel* label = [self viewWithTag:1001];
        if ([TDUtil isValidString:DICVFK(dic, @"title")]) {
            label.text = [NSString stringWithFormat:@"%@",DICVFK(dic, @"title")];
        }
    }
    
    //融资播报
    Platform * platForm = [[Platform alloc]init];
    array = [platForm selectData:100 andOffset:0];
    if (array && array.count>0) {
        NSDictionary * dic = array[0];
        //播报
        UILabel * label = [self viewWithTag:1002];
        if ([TDUtil isValidString:DICVFK(dic, @"title")]) {
            label.text = [NSString stringWithFormat:@"%@",DICVFK(dic, @"title")];
        }
    }
}

-(void)resetBannerData
{
    //将数据保存至本地数据库
    if (self.bannerArray && self.bannerArray.count>0) {
        //适配数据
        self.viewsArray = [NSMutableArray new];
        
        //封装
        //NSMutableArray* bannerArray = [[NSMutableArray alloc]init];
        for (int  i =0; i<self.bannerArray.count; i++) {
            //<!-- 将banner数据缓存 -->
            NSDictionary * dic = self.bannerArray[i];
            //<!-- 将banner数据缓存 -->
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self.mainScorllView))];
            imageView.backgroundColor = WriteColor;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.layer.masksToBounds = YES;
            
            [self.viewsArray addObject:imageView];
            
            NSURL * url = [NSURL URLWithString:DICVFK(dic, @"img")];
            
            [imageView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage* image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.layer.masksToBounds = NO;
                if (i<self.bannerArray.count) {
                    [self.viewsArray replaceObjectAtIndex:i withObject:imageView];
                }
            }];
        }
        __block RoadShowHomeHeaderView *instance = self;
        self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            if (instance.viewsArray && instance.viewsArray.count>0) {
                return [instance.viewsArray objectAtIndex:pageIndex];
            }else{
                return 0;
            }
        };
        self.mainScorllView.totalPagesCount = ^NSInteger(void){
            return [instance.bannerArray count];
        };
        
        self.mainScorllView.TapActionBlock = ^(NSInteger pageIndex){
            if (pageIndex <= instance.bannerArray.count) {
                NSDictionary * dic = instance.bannerArray[pageIndex];
                NSString* projectId = STRING(@"%@", DICVFK(dic, @"project"));
                if (![TDUtil isValidString:projectId] && [projectId integerValue] != 0) {
                    //                NSString* urlStr =[dataArray[pageIndex] valueForKey:@"url"];
                    NSString* urlStr = DICVFK(dic, @"url");
                    if (urlStr && ![urlStr isEqualToString:@""]) {
                        BannerViewController* controller =[[BannerViewController alloc]init];
                        controller.titleStr = @"金指投";
                        controller.title = @"首页";
                        controller.url =[NSURL URLWithString:urlStr];
                        if ([instance.delegate respondsToSelector:@selector(roadShowHome:controller:type:)]) {
                            [instance.delegate roadShowHome:instance controller:controller type:0];
                        }
                    }else{
                        [[DialogUtil sharedInstance]showDlg:[UIApplication sharedApplication].windows[0] textOnly:@"暂无详情"];
                    }
                }else{
                    RoadShowDetailViewController* controller = [[RoadShowDetailViewController alloc]init];
                    controller.dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",projectId],@"id", nil];
                    controller.title =@"项目";
                    if ([instance.delegate respondsToSelector:@selector(roadShowHome:controller:type:)]) {
                        [instance.delegate roadShowHome:instance controller:controller type:0];
                    }
                }
                
            }
        };
    }
}
-(void)callService:(id)sender
{
    if (!httpUtil) {
        httpUtil = [[HttpUtils alloc]init];
    }
    if (!loadingView) {
        loadingView = [LoadingUtil shareinstance:self.superview];
    }
    [LoadingUtil show:loadingView];
    loadingView.isTransparent =YES;
    [httpUtil getDataFromAPIWithOps:CUSTOMSERVICE postParam:nil type:0 delegate:self sel:@selector(requestCallService:)];
}


-(void)setDataDic:(NSMutableDictionary *)dataDic
{
    self->_dataDic = dataDic;
    NSMutableArray* dataArray = [self.dataDic valueForKey:@"banner"];
    if (dataArray) {
        //                self.viewsArray = [NSMutableArray new];
        
        //封装
        Banner* bannerModel;
        bannerModel = [[Banner alloc]init];
        //删除本地数据
        [bannerModel deleteData];
        //设置本地数据
        self.bannerArray = dataArray;
        [self resetBannerData];
        
        bannerModel = [[Banner alloc]init];
        //将数据保存至本地数据库
        [bannerModel insertCoreData:dataArray];
        
        Announcement* cement =[[Announcement alloc]init];
        //移除旧数据
        [cement deleteData];
        
        //缓存新数据
        cement =[[Announcement alloc]init];
        cement.title = [[self.dataDic valueForKey:@"announcement"] valueForKey:@"title"];
        cement.url = [[self.dataDic valueForKey:@"announcement"] valueForKey:@"url"];
        
        [cement save];
        
        //公告
        UILabel* label = [self viewWithTag:1001];
        NSString* announcement = [[self.dataDic valueForKey:@"announcement"] valueForKey:@"title"];
        if ([TDUtil isValidString:announcement]) {
            label.text = [NSString stringWithFormat:@"%@",announcement];
        }
        
        //平台信息
        label =[self viewWithTag:1002];
        NSDictionary * platDic =[self.dataDic valueForKey:@"platform"];
        label.text = [platDic valueForKey:@"title"];
        
        //缓存融资播报信息
        Platform * platForm = [[Platform alloc] init];
        //删除缓存数据
        [platForm deleteData];
        
        //保存数据
        [platForm insertCoreData:[NSMutableArray arrayWithObject:platDic]];
        
    }
}

/**
 *  融资播报
 *
 *  @param sender 触发实例
 */
-(void)notionAction:(id)sender
{
    BannerViewController* controller =[[BannerViewController alloc]init];
    controller.title = @"首页";
    
    //融资播报
    Platform * platForm = [[Platform alloc]init];
    NSMutableArray * array = [platForm selectData:100 andOffset:0];
    if (array && array.count>0) {
        NSDictionary * dic = array[0];
        //播报
        if ([TDUtil isValidString:DICVFK(dic, @"title")]) {
            controller.titleStr = [dic valueForKey:@"title"];
            controller.url = [NSURL URLWithString:[dic valueForKey:@"url"]];
            if ([_delegate respondsToSelector:@selector(roadShowHome:controller:type:)]) {
                [_delegate roadShowHome:self controller:controller type:0];
            }
        }
    }
}

/**
 *  新手指南
 *
 *  @param sender 触发实例
 */
-(void)notificationAction:(id)sender
{
    BannerViewController* controller =[[BannerViewController alloc]init];
    controller.title = @"首页";
    
    //新手指南
    Announcement* cement = [[Announcement alloc]init];
    NSArray* array = [cement selectData:100 andOffset:0];
    if(array && array.count>0){
        NSDictionary * dic = array[0];
        controller.url = [NSURL URLWithString:DICVFK(dic, @"url")];
        controller.titleStr = DICVFK(dic, @"title");
        if ([_delegate respondsToSelector:@selector(roadShowHome:controller:type:)]) {
            [_delegate roadShowHome:self controller:controller type:0];
        }
    }
    
    
}



/**
 *  企业征信查询
 *
 *  @param sender sender
 */
-(void)creditSearchAction:(id)sender
{
    INSViewController* controller =[[INSViewController alloc]init];
    controller.type = 3;
    controller.title = @"首页";
    controller.titleContent = @"企业征信查询";
    if ([_delegate respondsToSelector:@selector(roadShowHome:controller:type:)]) {
        [_delegate roadShowHome:self controller:controller type:0];
    }
}



-(void)requestCallService:(ASIHTTPRequest*)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            NSMutableArray* array =[jsonDic valueForKey:@"data"];
            NSDictionary* dic  = [array objectAtIndex:0];
            
            //获取第一个电话号码
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[dic valueForKey:@"value"]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self addSubview:callWebview];
        }
    }
    
    [LoadingUtil close:loadingView];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    [[DialogUtil sharedInstance]showDlg:self.superview textOnly:@"客服忙，请稍后再联系!"];
    [LoadingUtil close:loadingView];
}
@end
