//
//  JKSideSlipView.h
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JKSlideSlipDelegate <NSObject>
-(void)slipView:(id*)slipView amiousLogin:(UIButton*)button;

@end
@interface JKSideSlipView : UIView
{
    BOOL isOpen;
    UITapGestureRecognizer *_tap;
    UISwipeGestureRecognizer *_leftSwipe, *_rightSwipe;
    UIImageView *_blurImageView;
    UIViewController *_sender;
    UIView *_contentView;
}
@property(assign,nonatomic)BOOL isShow;
@property(assign,nonatomic)BOOL  isAmious;
@property(retain,nonatomic)id <JKSlideSlipDelegate> delegate;
- (instancetype)initWithSender:(UIViewController*)sender;
-(void)show;
-(void)hide;
-(void)switchMenu;
-(void)setContentView:(UIView*)contentView;


@end

