//
//  loginViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
@interface loginViewController : UIViewController<UITextFieldDelegate>
@property(retain,nonatomic)NavView* navView;
@property (retain, nonatomic)  UIButton *loginButton;
@property (retain, nonatomic)  UITextField *phoneTextField;
@property (retain, nonatomic)  UITextField *passwordTextField;




@end
