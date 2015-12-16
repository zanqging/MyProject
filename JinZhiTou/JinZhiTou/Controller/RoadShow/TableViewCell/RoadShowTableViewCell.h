//
//  RoadShowTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoadShowTableViewCell : UITableViewCell
@property(retain,nonatomic)UIImageView* imgView;
@property(retain,nonatomic)NSString* content;
@property (retain, nonatomic) UILabel *textView;
@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UIImageView *titleImgView;
@property (retain, nonatomic) UIImageView *expandImgView;
@property(assign,nonatomic)BOOL isLimit;
@property(assign,nonatomic)BOOL isExpand;

-(void)lauyoutResetLayout:(CGRect)frame;
@end
