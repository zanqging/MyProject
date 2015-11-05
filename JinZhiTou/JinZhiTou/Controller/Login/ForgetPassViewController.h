//
//  ForgetPassViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "JKCountDownButton.h"
@interface ForgetPassViewController : UIViewController
@property(assign,nonatomic)int type;
@property(assign,nonatomic) BOOL isCountDown;
@property (strong, nonatomic) NavView *navView;
@property (strong, nonatomic) UIButton *configBtn;
@property (strong, nonatomic) UIView *subView;
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *passTextField;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) JKCountDownButton *codeButton;
@property (strong, nonatomic) UITextField *passRepeatTextField;
@end
