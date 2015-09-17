//
//  SignViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/14.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "SignViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "MZTimerLabel.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import <QuartzCore/QuartzCore.h>
@interface SignViewController ()<MZTimerLabelDelegate,UIScrollViewDelegate>
{
    UIScrollView* scrollView;
    HttpUtils* httpUtil;
    
    NSMutableDictionary* dataDic;
    
    CLLocation * currentLocation;
}

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"签到"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"首页" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    scrollView.scrollEnabled = YES;
    scrollView.bounces  = YES;
    scrollView.delegate = self;
    scrollView.backgroundColor = BackColor;
    scrollView.contentSize = CGSizeMake(WIDTH(self.view), HEIGHT(self.view)+180);
    [self.view addSubview:scrollView];
    
    
    //头部图片
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-1, -1, WIDTH(scrollView)+2, 170)];
    imageView.image = IMAGENAMED(@"beijing");
    [scrollView addSubview:imageView];
    
    UIView* viewTime = [[UIView alloc]initWithFrame:CGRectMake(40, HEIGHT(imageView)/2-HEIGHT(imageView)/4, WIDTH(imageView)-80, HEIGHT(imageView)/2)];
    
    viewTime.alpha = 0.7;
    viewTime.layer.borderWidth= 4;
    viewTime.backgroundColor = WriteColor;
    viewTime.layer.borderColor = ColorTheme.CGColor;
    [scrollView addSubview:viewTime];
    
    
    MZTimerLabel* timeLabel = [[MZTimerLabel alloc]initWithFrame:CGRectMake(X(viewTime), Y(viewTime)+10, WIDTH(viewTime), 25)];
    timeLabel.text = @"2015年08月18日 星期一";
    timeLabel.textColor = ColorTheme;
    timeLabel.font = SYSTEMFONT(14);
    timeLabel.textAlignment =NSTextAlignmentCenter;
    [scrollView addSubview:timeLabel];
    
    timeLabel = [[MZTimerLabel alloc]initWithFrame:CGRectMake(X(timeLabel), POS_Y(timeLabel), WIDTH(viewTime), 35)];
    timeLabel.delegate  = self;
    timeLabel.textColor = ColorTheme;
    timeLabel.font = SYSTEMFONT(45);
    timeLabel.textAlignment =NSTextAlignmentCenter;
    [scrollView addSubview:timeLabel];
    
    NSString* dateStr=[[TDUtil dateTimeWithOps:0] stringByAppendingString:@" 00:00:00"];
    NSString* date =[TDUtil CurrentDate];
    
    NSDateFormatter *dateFormator = [[NSDateFormatter alloc] init];
    dateFormator.dateFormat = @"yyyy-MM-dd  HH:mm:ss";
    NSDate* dateStart = [TDUtil dateFromString:dateStr format: @"yyyy-MM-dd  HH:mm:ss"];
    NSDate* dateEnd = [TDUtil dateFromString:date format: @"yyyy-MM-dd  HH:mm:ss"];
    NSTimeInterval interval = [dateEnd timeIntervalSinceDate:dateStart];
    [timeLabel setTimerType:MZTimerLabelTypeStopWatch];
    [timeLabel setCountDownTime:interval];
    [timeLabel start];
    
    
    UILabel * labelLocation =[[UILabel alloc]initWithFrame:CGRectMake(20, POS_Y(imageView)+30, WIDTH(self.view)-90, 60)];
    labelLocation.tag =20001;
    labelLocation.layer.cornerRadius =25;
    labelLocation.layer.borderWidth = 1;
    labelLocation.font = SYSTEMFONT(16);
    labelLocation.text = @"暂时没有课程";
    labelLocation.textAlignment = NSTextAlignmentCenter;
    labelLocation.layer.borderColor = ColorTheme.CGColor;
    [scrollView addSubview:labelLocation];
    
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(labelLocation)-30, Y(labelLocation)-2, 70, HEIGHT(labelLocation)+4)];
    imgView.image = IMAGENAMED(@"timeLabelLeft");
    [scrollView addSubview:imgView];
    
    
    labelLocation =[[UILabel alloc]initWithFrame:CGRectMake(X(imgView), Y(imgView), WIDTH(imgView), HEIGHT(imgView))];
    labelLocation.text = @"课程名称";
    labelLocation.font = SYSTEMFONT(14);
    labelLocation.textColor = WriteColor;
    labelLocation.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:labelLocation];
    
    
    labelLocation =[[UILabel alloc]initWithFrame:CGRectMake(60, POS_Y(labelLocation)+30, WIDTH(self.view)-90, 60)];
    labelLocation.tag =20002;
    labelLocation.layer.cornerRadius =25;
    labelLocation.layer.borderWidth = 1;
    labelLocation.font = SYSTEMFONT(16);
    labelLocation.text = @"点击定位您的当前位置";
    [labelLocation setUserInteractionEnabled:YES];
    [labelLocation addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getCurrentAddress:)]];
    labelLocation.textAlignment = NSTextAlignmentCenter;
    labelLocation.layer.borderColor = ColorTheme.CGColor;
    [scrollView addSubview:labelLocation];
    
    
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, Y(labelLocation)-2, 70, HEIGHT(labelLocation)+4)];
    imgView.image = IMAGENAMED(@"timeLabelRight");
    [scrollView addSubview:imgView];
    
    
    labelLocation =[[UILabel alloc]initWithFrame:CGRectMake(X(imgView), Y(imgView), WIDTH(imgView), HEIGHT(imgView))];
    labelLocation.text = @"当前位置";
    labelLocation.font = SYSTEMFONT(14);
    labelLocation.textColor = WriteColor;
    [labelLocation setUserInteractionEnabled:YES];
     [labelLocation addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getCurrentAddress:)]];
    labelLocation.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:labelLocation];
    
    
    labelLocation =[[UILabel alloc]initWithFrame:CGRectMake(20, POS_Y(labelLocation)+30, WIDTH(self.view)-90, 60)];
    labelLocation.tag =20003;
    labelLocation.layer.cornerRadius =25;
    labelLocation.layer.borderWidth = 1;
    labelLocation.text = @"尚未签到";
    labelLocation.font = SYSTEMFONT(16);
    [labelLocation setUserInteractionEnabled:YES];
    [labelLocation addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signAction:)]];
    labelLocation.textAlignment = NSTextAlignmentCenter;
    labelLocation.layer.borderColor = ColorTheme.CGColor;
    [scrollView addSubview:labelLocation];
    
    
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(labelLocation)-30, Y(labelLocation)-2, 70, HEIGHT(labelLocation)+4)];
    imgView.image = IMAGENAMED(@"timeLabelLeft");
    imageView.tag =30001;
    [scrollView addSubview:imgView];
    
    
    labelLocation =[[UILabel alloc]initWithFrame:CGRectMake(X(imgView), Y(imgView), WIDTH(imgView), HEIGHT(imgView))];
    labelLocation.text = @"签到";
    labelLocation.tag =30002;
    [labelLocation setUserInteractionEnabled:YES];
    [labelLocation addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(signAction:)]];
    labelLocation.font = SYSTEMFONT(14);
    labelLocation.textColor = WriteColor;
    labelLocation.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:labelLocation];
    
    //底部
    UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(20, POS_Y(labelLocation)+30, WIDTH(self.view)/2-20, 30)];
    label.text = @"00公里";
    label.tag =20004;
    label.font = SYSTEMFONT(25);
    label.textColor = ColorTheme;
    label.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:label];
    
    label =[[UILabel alloc]initWithFrame:CGRectMake(X(label), POS_Y(label)+5, WIDTH(self.view)/2-20, 30)];
    label.text = @"总距离";
    label.font = SYSTEMFONT(18);
    label.textColor = ColorTheme;
    label.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:label];
    
    //分割线
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(scrollView)/2, Y(label)-40, 1, 80)];
    imgView.backgroundColor = ColorTheme;
    [scrollView addSubview:imgView];
    
    MZTimerLabel* labelInstance =[[MZTimerLabel alloc]initWithFrame:CGRectMake(WIDTH(scrollView)/2, POS_Y(labelLocation)+30, WIDTH(self.view)/2-20, 30)];
    labelInstance.tag =20005;
    labelInstance.text = @"00:00";
    labelInstance.font = SYSTEMFONT(25);
    labelInstance.textColor = ColorTheme;
    labelInstance.timerType = MZTimerLabelTypeTimer;
    labelInstance.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:labelInstance];
    
    label =[[UILabel alloc]initWithFrame:CGRectMake(X(labelInstance), POS_Y(labelInstance)+5, WIDTH(self.view)/2-20, 30)];
    label.text = @"距离课程时间";
    label.font = SYSTEMFONT(18);
    label.textColor = ColorTheme;
    label.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:label];
    
    
    [self loadActivity];
    
    //获取地理位置信息
    [self getCurrentAddress:nil];
}

-(void)loadActivity
{
    httpUtil = [[HttpUtils alloc]init];
    [httpUtil getDataFromAPIWithOps:ACTIVITY postParam:nil type:0 delegate:self sel:@selector(requestActivity:)];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)signAction:(id)sender
{
    if (dataDic) {
        NSString* str = [SIGNIN stringByAppendingFormat:@"%@/",[dataDic valueForKey:@"id"]];
        [httpUtil getDataFromAPIWithOps:str postParam:nil type:0 delegate:self sel:@selector(requestSignin:)];
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"暂时无法签到"];
    }
    
}

-(void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime
{
    //NSLog(@"%f",countTime);
}

-(void)timerLabel:(MZTimerLabel *)timerLabel countingTo:(NSTimeInterval)time timertype:(MZTimerLabelType)timerType
{
    //NSLog(@"%f",time);
}

#pragma location
-(void)getCurrentAddress:(id)sender
{
    if ([CLLocationManager locationServicesEnabled]) {
        if (_locationManager==nil) {
            _locationManager=[[CLLocationManager alloc]init];
            _locationManager.distanceFilter=1;
            _locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
            _locationManager.delegate=self;
        }
        if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        
        [_locationManager startUpdatingLocation];
        NSLog(@"GPS可以使用");
    }else{
        //位置不可用
        NSLog(@"GPS被禁");
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code==kCLErrorDenied) {
        NSLog(@"地理位置信息服务获取被用户拒绝!");
    }
}

-(float)dinstance
{
    
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:[[dataDic valueForKey:@"latitude"]floatValue] longitude:[[dataDic valueForKey:@"longitude"]floatValue]];
    
    CLLocationDistance kilometers=[dist distanceFromLocation:currentLocation];  //米
    NSLog(@"距离:%f",kilometers);
    return kilometers/1000;
}



// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation = newLocation;
    // 获取经纬度
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    
    NSLog(@"目标纬度:%f",[[dataDic valueForKey:@"latitude"]floatValue]);
    NSLog(@"目标经度:%f",[[dataDic valueForKey:@"longitude"]floatValue]);
    
    
    UILabel* label = (UILabel*)[scrollView viewWithTag:20004];
    label.text = [NSString stringWithFormat:@"%.fkm",[self dinstance]];
    
    // 停止位置更新
    //[manager stopUpdatingLocation];
    NSTimeInterval eventInterval=[newLocation.timestamp timeIntervalSinceNow];
    if (abs(eventInterval<30.0f)) {
        if (newLocation.horizontalAccuracy<0) {
            return;
        }
        
        if (_geocoder==nil) {
            _geocoder=[[CLGeocoder alloc]init];
            
        }
        
        if ([_geocoder isGeocoding]) {
            [_geocoder cancelGeocode];
        }
    }
    
    [_geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray* placemarks,NSError* error){
        if ([placemarks count]>0) {
            CLPlacemark* foundPlacemark=[placemarks objectAtIndex:0];
            NSDictionary* dic=foundPlacemark.addressDictionary;
            locationDic=dic;
            //定位成功
            [self locationed];
            islocationed=YES;
            //通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"locationed" object:nil];
        }else if(error.code==kCLErrorGeocodeFoundNoResult){
            NSLog(@"该地区地理位置信息未定位...");
        }else if (error.code==kCLErrorGeocodeCanceled){
            NSLog(@"定位已取消...");
        }else if(error.code==kCLErrorGeocodeFoundPartialResult){
            NSLog(@"Partial geocode result!");
        }else{
            NSLog(@"未知错误:%@",error.description);
        }
        //        thread=nil;
        //        //[loadingViewController.ImageAnimation removeFromSuperview];
        //        //获取当前文件路劲
        //        thread=[[NSThread alloc]initWithTarget:self selector:@selector(getWeatherAndAirInfo) object:nil];
        //        [thread start];
    }];
}

-(void)locationed
{
    //定位信息
    NSString* city=[locationDic valueForKey:@"City"];
    NSString* state=[locationDic valueForKey:@"State"];
    NSString* subLocality=[locationDic valueForKey:@"SubLocality"];
    
    UILabel* label = (UILabel*)[scrollView viewWithTag:20002];
    label.text = [NSString stringWithFormat:@"%@%@%@",state,city,subLocality];
}

#pragma ASIHttpRequester
//===========================================================网络请求=====================================

/**
 *  活动信息请求
 *
 *  @param request request
 */
-(void)requestActivity:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        
        if ([status integerValue] == 0) {
            dataDic = [jsonDic valueForKey:@"data"];
            UILabel* label = (UILabel*)[scrollView viewWithTag:20001];
            label.text = [NSString stringWithFormat:@"%@",[dataDic valueForKey:@"coordinate"]];
            
            MZTimerLabel* labelInstance =(MZTimerLabel*)[scrollView viewWithTag:20005];
            float interval = [[dataDic valueForKey:@"seconds"] floatValue];
            if (interval<0) {
                interval = -interval;
            }
            [labelInstance setCountDownTime:interval];
            [labelInstance start];
            
        }else{
             UILabel* label = (UILabel*)[scrollView viewWithTag:30002];
            label.userInteractionEnabled = NO;
            label = (UILabel*)[scrollView viewWithTag:20003];
            label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
            label.text = @"未开始签到";
        }
    }
}

-(void)requestSignin:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        
        if ([status integerValue] == 0) {
            //[[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            
            UILabel* label = (UILabel*)[scrollView viewWithTag:20003];
            label.text = [ jsonDic valueForKey:@"msg"];
        }else{
            UILabel* label = (UILabel*)[scrollView viewWithTag:30002];
            label.enabled = YES;
            
            label = (UILabel*)[scrollView viewWithTag:20003];
            label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
            label.text = [ jsonDic valueForKey:@"msg"];
        }
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
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
