//
//  LoadingUtil.h
//  JinZhiTou
//
//  Created by air on 15/8/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
@interface LoadingUtil : UIView
//单例
+(LoadingView*)shareinstance:(UIView*)view;
//显示
+(void)showLoadingView:(UIView*)view;
//使用实例显示
+(void)showLoadingView:(UIView *)view withLoadingView:(LoadingView*)loadingView;
//关闭加载页
+(void)closeLoadingView:(LoadingView*)loadingView;
/**
 *  关闭加载视图
 *
 *  @param loadingView loadingInstance
 */
+(void)show:(LoadingView*)loadingView;
/**
 *  关闭
 *
 *  @param loadingView loadingInstance
 */
+(void)close:(LoadingView*)loadingView;
@end
