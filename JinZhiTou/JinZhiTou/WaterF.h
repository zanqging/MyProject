//
//  WaterF.h
//  CollectionView
//
//  Created by d2space on 14-2-21.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "WaterFLayout.h"
#import "CycleScrollView.h"


@protocol WaterFDelegate <NSObject>

-(void)loadFinished;

@end
@interface WaterF : UICollectionViewController 

@property (nonatomic,strong) NSArray* imagesArr;
@property (nonatomic,strong) NSArray* textsArr;
@property (nonatomic,strong) NSArray* datesArr;
@property (nonatomic,assign) NSInteger sectionNum;
@property (nonatomic,assign)BOOL isEndOfPageSize;
@property (nonatomic) NSInteger imagewidth;
@property (nonatomic) CGFloat textViewHeight;
@property(retain,nonatomic)CycleScrollView* headerView;
@property(retain,nonatomic)id <WaterFDelegate> delegate;

-(void)refreshProject;

@end

