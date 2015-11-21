//
//  FinialAuthViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKCountDownButton.h"
#import "RootViewController.h"
#import "MMDrawerController.h"
#import "CustomImagePickerController.h"
@interface WeChatBindController : RootViewController
@property(assign,nonatomic)int type;
@property(retain,nonatomic)NSString* openId;
@property(assign,nonatomic) BOOL isCountDown;
@property(retain,nonatomic)NSString* titleStr;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)UITextField* nameTextField;
@property(retain,nonatomic)JKCountDownButton* codeButton;
@property(retain,nonatomic)NSMutableArray* industoryList;
@property(retain,nonatomic)NSMutableArray* companyDataArray;
@property(retain,nonatomic)NSMutableArray* foundationSizeRange;
@property(retain,nonatomic)MMDrawerController* drawerController;
@property(retain,nonatomic)CustomImagePickerController* customPicker;
@end
