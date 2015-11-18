
//
//  RegisteViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface ResetPasswordViewController : RootViewController
@property(assign,nonatomic) BOOL isCountDown;
@property (retain, nonatomic) IBOutlet UILabel *proctoLabel;
@property (retain, nonatomic) IBOutlet UIButton *regietButton;
@property (retain, nonatomic) IBOutlet UITextField *passTextField;
@property (retain, nonatomic) IBOutlet UITextField *codeTextField;
@property (retain, nonatomic) IBOutlet UITextField *passRepeatTextField;
@end
