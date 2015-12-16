//
//  LoadingView.h
//  JinZhiTou
//
//  Created by air on 15/8/12.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewDelegate.h"
@interface LoadingView : UIView
{
    UILabel* labelMessage;
    UIImageView* imageView;
    UIButton* refreshButton;
}
@property(retain,nonatomic)UIView* view;
@property(assign,nonatomic)BOOL isError;
@property(retain,nonatomic)NSString* content;
@property(assign,nonatomic)BOOL isTransparent;
@property(retain,nonatomic)id <LoadingViewDelegate> delegate;
-(void)startAnimation;
-(void)stopAnitmation;
@end