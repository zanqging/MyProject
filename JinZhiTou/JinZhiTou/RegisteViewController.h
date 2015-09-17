
//
//  RegisteViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/3.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "HttpUtils.h"
#import "JKCountDownButton.h"
#import "ASIFormDataRequest.h"
@interface RegisteViewController : UIViewController<ASIHTTPRequestDelegate>
@property (retain, nonatomic) IBOutlet NavView *navView;
@property (retain, nonatomic) IBOutlet UILabel *proctoLabel;
@property (retain, nonatomic) IBOutlet UIButton *regietButton;
@property (retain, nonatomic) IBOutlet UITextField *codeTextField;
@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;
@property (retain, nonatomic) IBOutlet UITextField *passTextField;
@property(assign,nonatomic) BOOL isCountDown;
@property (retain, nonatomic) IBOutlet JKCountDownButton *codeButton;
@property (retain, nonatomic) IBOutlet UITextField *passRepeatTextField;
@end
