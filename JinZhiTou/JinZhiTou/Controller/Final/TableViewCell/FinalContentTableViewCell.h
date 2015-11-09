//
//  FinalContentTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/7/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface FinalContentTableViewCell : UITableViewCell
{
    UIView* view;
    UILabel* itemLabel;
    UILabel* itemValueLabel;
}
@property (retain,nonatomic) UIImageView *imgView;
@property (retain, nonatomic)UILabel *titleLabel;

@property(retain,nonatomic)NSString* title;
//@property(retain,nonatomic)NSString* content;
@property(retain,nonatomic)NSString* roadShowTime;
@property(retain,nonatomic)NSString* typeDescription;
//@property(retain,nonatomic)NSDictionary* start;
//@property(retain,nonatomic)NSDictionary* end;

@end

