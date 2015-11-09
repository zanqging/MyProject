//
//  loginViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface loginViewController : RootViewController<UITextFieldDelegate>
@property (retain, nonatomic)  UIButton *loginButton;
@property (retain, nonatomic)  UITextField *phoneTextField;
@property (retain, nonatomic)  UITextField *passwordTextField;




@end
