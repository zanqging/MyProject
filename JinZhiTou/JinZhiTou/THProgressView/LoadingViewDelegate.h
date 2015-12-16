//
//  LoadingViewDelegate.h
//  JinZhiTou
//
//  Created by air on 15/8/19.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingViewDelegate : NSObject

@end

@protocol LoadingViewDelegate <NSObject>

-(void)refresh;
@end