//
//  FeedBackViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/7.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
@interface FeedBackViewController : UIViewController
@property (strong, nonatomic) NavView *navView;

@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) UITextView *textView;

@end
