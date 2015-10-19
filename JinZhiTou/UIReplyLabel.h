//
//  UIReplyLabel.h
//  JinZhiTou
//
//  Created by air on 15/10/19.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIReplyLabel : UILabel
@property(retain,nonatomic)UILabel* nameLabel;
@property(retain,nonatomic)UILabel* atLabel;
@property(retain,nonatomic)UILabel* atNameLabel;
@property(retain,nonatomic)UILabel* atSuffixLabel;
@property(retain,nonatomic)UILabel* contentLabel;

@property(retain,nonatomic)NSString* name;
@property(retain,nonatomic)NSString* atString;
@property(retain,nonatomic)NSString* atName;
@property(retain,nonatomic)NSString* suffix;
@property(retain,nonatomic)NSString* content;
@end
