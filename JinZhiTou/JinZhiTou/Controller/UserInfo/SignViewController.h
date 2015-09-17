//
//  SignViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/14.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import <CoreLocation/CoreLocation.h>
@interface SignViewController : UIViewController<CLLocationManagerDelegate>
{
    //定位
    CLGeocoder* _geocoder;
    NSString* currentState; // 当前城市
    NSDictionary* locationDic;  //保存地理位置信息
    CLLocation *checkinLocation;
    CLLocationManager* _locationManager;
    
    BOOL islocationed;
    int locationCount;
}
@property(retain,nonatomic)NavView* navView;
@property(nonatomic,strong)NSThread* thread;
@property(retain,nonatomic)NSString* location;
@property(retain,nonatomic)NSString* locationStr;
@end
