//
//  FinalContentTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/7/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface FinalingTableViewCell : UITableViewCell
{
    UIView* view;
    UILabel* itemLabel;
    UILabel* itemValueLabel;
}
@property (retain,nonatomic) UIImageView *imgView;
@property (retain, nonatomic)UILabel *titleLabel;

@property(retain,nonatomic)NSString* title;
@property(retain,nonatomic)NSString* progress; //融资进度
@property(retain,nonatomic)NSString* assist; //支持人数
@property(retain,nonatomic)NSString* hasFinanceAccount;  //已筹总额

@end

