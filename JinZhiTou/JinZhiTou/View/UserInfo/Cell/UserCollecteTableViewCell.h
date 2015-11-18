//
//  UserCollecteTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/8/8.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface UserCollecteTableViewCell : UITableViewCell
{
    UIView * view ;
}
@property (retain, nonatomic) UIImageView *imgview;
@property (retain, nonatomic) UILabel *titleLabel;
@property(retain,nonatomic)UILabel* desclabel;
@property(retain,nonatomic)NSString* start;
@property(retain,nonatomic)NSString* end;
@end
