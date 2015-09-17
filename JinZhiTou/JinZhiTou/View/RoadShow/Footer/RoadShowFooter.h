//
//  RoadShowFooter.h
//  JinZhiTou
//
//  Created by air on 15/7/28.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoadShowFooter : UIView
@property(retain,nonatomic)UILabel* titleLabel;
@property(retain,nonatomic)UILabel* dateTimeLabel;
-(void)setContent:(NSString*)content;
@end
