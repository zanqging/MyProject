//
//  LoadingUtil.m
//  JinZhiTou
//
//  Created by air on 15/8/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "LoadingUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation LoadingUtil
/**
 *  实例化 加载页面视图
 *
 *  @return 实例化
 */
+(LoadingView*)shareinstance:(UIView*)view
{
    LoadingView* loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, kTopBarHeight+kStatusBarHeight, WIDTH(view), HEIGHT(view)-kTopBarHeight-kStatusBarHeight)];
    loadingView.view = view;
    return loadingView;
}
/**
 *  根据设定rect大小定制加载视图
 *
 *  @param view  要将加载页面添加的父视图
 *  @param frame 要定制的视图大小
 *
 *  @return 加载页面实例
 */
+(LoadingView*)shareinstance:(UIView *)view frame:(CGRect)frame
{
    LoadingView* loadingView = [[LoadingView alloc]initWithFrame:frame];
    loadingView.view = view;
    return loadingView;
}

/**
 *  当前视图显示加载页视图
 *
 *  @param view
 */
+(void)showLoadingView:(UIView *)view
{
    
    LoadingView * loadingView = [self shareinstance:view];
    [loadingView setFrame:CGRectMake(0, kTopBarHeight+kStatusBarHeight, WIDTH(view), HEIGHT(view)-kTopBarHeight-kStatusBarHeight)];
    [view addSubview:loadingView];
    [loadingView startAnimation];
}

/**
 *  在view中显示加载页视图
 *
 *  @param view        目标视图
 *  @param loadingView 加载页视图
 */
+(void)showLoadingView:(UIView *)view withLoadingView:(LoadingView *)loadingView
{
    [loadingView setFrame:CGRectMake(0, kTopBarHeight+kStatusBarHeight, WIDTH(view), HEIGHT(view)-kTopBarHeight-kStatusBarHeight)];
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
    [loadingView startAnimation];
}

/**
 *  关闭隐藏加载页视图
 *
 *  @param loadingView
 */
+(void)closeLoadingView:(LoadingView *)loadingView
{
    [UIView animateKeyframesWithDuration:0 delay:2 options:UIViewKeyframeAnimationOptionAutoreverse animations:^(){
        
    }completion:^(BOOL isFinished){
        [loadingView removeFromSuperview];
    }];
    
}

+(void)show:(LoadingView *)loadingView
{
    UIView* view = loadingView.view;
    
    BOOL flag = false;
    for (UIView* v in view.subviews) {
        if ([v isKindOfClass:loadingView.class]) {
            flag = YES;
        }
    }
    
    if (!flag) {
        if (![view.subviews containsObject:loadingView]) {
            [view addSubview:loadingView];
            [view bringSubviewToFront:loadingView];
            [loadingView startAnimation];
        }
    }
    
}

+(void)close:(LoadingView *)loadingView
{
    [loadingView removeFromSuperview];
}
@end
