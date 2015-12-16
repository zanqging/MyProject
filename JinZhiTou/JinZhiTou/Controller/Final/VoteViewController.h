//
//  VoteViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/30.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
@interface VoteViewController : UIViewController
@property(assign,nonatomic)NSInteger projectId;
@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic) IBOutlet NavView *navView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnVote;
@property (weak, nonatomic) IBOutlet UILabel *descpLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
