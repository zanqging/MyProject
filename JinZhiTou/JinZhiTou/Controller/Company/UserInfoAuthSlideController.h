//
//  FinialAuthViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "CustomImagePickerController.h"
@interface UserInfoAuthSlideController : RootViewController
@property(assign,nonatomic)int type;
@property(retain,nonatomic)NSString* titleStr;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)NSMutableArray* foundationSizeRange;
@property(retain,nonatomic)NSMutableArray* industoryList;
@property(retain,nonatomic)NSMutableArray* companyDataArray;
@property(retain,nonatomic)CustomImagePickerController* customPicker;
@end
