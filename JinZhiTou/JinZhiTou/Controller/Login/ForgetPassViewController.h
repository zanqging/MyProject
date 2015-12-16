//
//  ForgetPassViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "JKCountDownButton.h"
@interface ForgetPassViewController : RootViewController
@property(assign,nonatomic)int type;
@property(assign,nonatomic) BOOL isCountDown;
@property (retain, nonatomic) IBOutlet UILabel *proctoLabel;
@property (retain, nonatomic) IBOutlet UIButton *regietButton;
@property (retain, nonatomic) IBOutlet UITextField *passTextField;
@property (retain, nonatomic) IBOutlet UITextField *codeTextField;
@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;
@property (retain, nonatomic) IBOutlet JKCountDownButton *codeButton;
@property (retain, nonatomic) IBOutlet UITextField *passRepeatTextField;
@end
