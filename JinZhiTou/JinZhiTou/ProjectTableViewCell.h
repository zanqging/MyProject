//
//  ThinkTankTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/9/22.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectTableViewCell : UITableViewCell
@property(retain,nonatomic)NSString* title;
@property(retain,nonatomic)NSString* content;
@property (retain, nonatomic)UILabel *typeLabel;
@property (retain, nonatomic)UILabel *titleLabel;
@property (retain,nonatomic) UIImageView *imgView;
@property (retain, nonatomic)UILabel *contentLabel;
@property(retain,nonatomic)NSString* typeDescription;
@end
