//
//  UserCollecteTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/8/8.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface NewFinialTableViewCell : UITableViewCell
{
    UIView * view ;
}
@property (retain, nonatomic) NSString* source;
@property (retain, nonatomic) NSString* dateTime;
@property (strong, nonatomic) UILabel *desclabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *typeLabel;
@property (strong, nonatomic) UILabel *priseLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *imgview;
@property (strong, nonatomic) UILabel *colletcteLabel;
@property (strong, nonatomic) UIImageView *priseImage;
@property (strong, nonatomic) UIImageView *collecteImage;
@end
