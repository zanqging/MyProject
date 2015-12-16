//
//  NavView.h
//  WeiNI
//
//  Created by air on 15/1/24.
//  Copyright (c) 2015年 weini. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol navViewDelegate <NSObject>

-(void)navView:(id)navView tapIndex:(int)index;

@end


@interface NavView : UIView
{
    UIButton* leftButton;
    UIButton* rightButton;
    UILabel* titleLable;
//    NSString* title;
    CGRect frameCurrent;
}
@property(retain,nonatomic)id <navViewDelegate> delegate;
@property(assign,nonatomic)BOOL isLocation;
@property(retain,nonatomic)UIView* backView;
@property(retain,nonatomic)NSString* title;
@property(retain,nonatomic)UILabel* titleLable;
@property(retain,nonatomic)UIButton* leftButton;
@property(assign,nonatomic)BOOL isHasNewMessage;
@property(retain,nonatomic)UIButton* rightButton;
@property(retain,nonatomic)UIImageView* imageView;
@property(retain,nonatomic)NSMutableArray* menuArray;

//触摸感应区域
@property(retain,nonatomic)UIView* leftTouchView;
@property(retain,nonatomic)UIView* rightTouchView;
@property(assign,nonatomic)int currentSelectedIndex;

-(void)setNavAnimation:(NSString*)type offset:(CGPoint)offset;
@end