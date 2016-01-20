//
//  RoadShowHomeHeaderView.h
//  JinZhiTou
//
//  Created by air on 15/11/4.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpUtils.h"
//#import "WMLoopView.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "CycleScrollView.h"
@protocol RoadShowHomeDelegate <NSObject>

-(void)roadShowHome:(id)roadShowHome controller:(UIViewController*)controller type:(int)type;
@end

@interface RoadShowHomeHeaderView : UIView
{
    HttpUtils* httpUtil;
//    WMLoopView* loopView;
    LoadingView* loadingView;
}
@property(retain,nonatomic)id <RoadShowHomeDelegate> delegate;
@property(retain,nonatomic)NSMutableDictionary* dataDic;
@property(retain,nonatomic)NSMutableArray* bannerArray;
@property(retain,nonatomic)NSMutableArray* viewsArray;
@property(retain,nonatomic)CycleScrollView* mainScorllView;//Banner

-(id)initWithFrame:(CGRect)frame withData:(NSDictionary*)data;
@end

