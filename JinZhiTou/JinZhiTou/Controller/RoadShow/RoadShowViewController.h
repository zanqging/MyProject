//
//  RoadShowViewController.h
//  JinZhiTou
//
//  Created by air on 15/7/23.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterF.h"
@interface RoadShowViewController : UIViewController
@property (nonatomic,strong) NSArray* texts;
@property (nonatomic,strong) NSArray* dates;
@property (nonatomic,strong) WaterF* waterfall;
@property (nonatomic,strong) NSMutableArray* images;
@property(retain,nonatomic)NSMutableArray *viewsArray;
@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)NSMutableArray* bannerArray;
@end
