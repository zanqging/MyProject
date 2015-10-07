//
//  NavView.h
//  WeiNI
//
//  Created by air on 15/1/24.
//  Copyright (c) 2015年 weini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavView : UIView
{
    UIButton* leftButton;
    UIButton* rightButton;
    UILabel* titleLable;
//    NSString* title;
    CGRect frameCurrent;
}

@property(assign,nonatomic)BOOL isLocation;
@property(retain,nonatomic)UIView* backView;
@property(retain,nonatomic)NSString* title;
@property(retain,nonatomic)UILabel* titleLable;
@property(retain,nonatomic)UIButton* leftButton;
@property(assign,nonatomic)BOOL isHasNewMessage;
@property(retain,nonatomic)UIButton* rightButton;
@property(retain,nonatomic)UIImageView* imageView;

//触摸感应区域
@property(retain,nonatomic)UIView* leftTouchView;
@property(retain,nonatomic)UIView* rightTouchView;

-(void)setNavAnimation:(NSString*)type offset:(CGPoint)offset;
@end
