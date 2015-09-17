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
@property (weak, nonatomic) UIButton *configBtn;
@property (weak, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *passTextField;
@property (strong, nonatomic) IBOutlet UITextField *codeTextField;
@property (strong, nonatomic) IBOutlet JKCountDownButton *codeButton;
@end
