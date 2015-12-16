//
//  WaterFCell.h
//  CollectionView
//
//  Created by d2space on 14-2-26.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface WaterFCell : UICollectionViewCell
@property(retain,nonatomic)NSString* title;
@property(retain,nonatomic)UIColor * tinColor;
@property (nonatomic, strong) UIImageView* imageView;
@property(nonatomic,strong) UILabel* lblRoadShowTime;
@property (nonatomic, strong) UILabel* lblProjectName;

@end
