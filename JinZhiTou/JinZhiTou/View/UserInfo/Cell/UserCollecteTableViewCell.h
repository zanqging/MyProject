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
@property (strong, nonatomic) UIImageView *imgview;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *desclabel;
@property (strong, nonatomic) UILabel *typeLabel;
@end
