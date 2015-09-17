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
@property (retain,nonatomic) UIImageView *imgView;
@property (retain, nonatomic)UILabel *titleLabel;
@property (retain, nonatomic)UILabel *contentLabel;

@property (retain, nonatomic)UILabel *typeLabel;
@property (retain, nonatomic)UILabel *collectDataLabelView;
@property (retain, nonatomic)UILabel *priseDataLabel;

@property (retain, nonatomic)UILabel *voteDataLabel;

@property (retain, nonatomic)UIButton *collecteImgView;

@property (retain, nonatomic)UIButton *priseImgView;
@property (retain, nonatomic)UIButton *voteImgView;
@property(retain,nonatomic)NSString* title;
@property(retain,nonatomic)NSString* content;
@property(retain,nonatomic)NSString* typeDescription;
@property(assign,nonatomic)NSInteger collectionData;
@property(assign,nonatomic)NSInteger priseData;
@property(assign,nonatomic)NSInteger  voteData;
@end

