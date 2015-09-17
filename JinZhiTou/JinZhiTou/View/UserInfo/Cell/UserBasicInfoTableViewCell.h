//
//  UserBasicInfoTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/8/7.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface UserBasicInfoTableViewCell : UITableViewCell
@property(assign,nonatomic)BOOL isShowImg;
@property(assign,nonatomic)BOOL isShowSwitch;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *rightLabel;
@property(retain,nonatomic)UIImageView* rightImgView;
-(void)setViewCellTitle:(NSString*)title setTitle:(NSString*)subTitle;
@end
