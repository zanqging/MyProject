//
//  FinialSubmmitViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/2.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
@interface FinialSubmmitViewController : UIViewController
@property (strong, nonatomic)NavView *navView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmmit;
@property (weak, nonatomic) IBOutlet UIView *personView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
