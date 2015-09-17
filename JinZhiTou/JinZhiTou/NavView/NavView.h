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
@property(retain,nonatomic)NSString* title;
@property(retain,nonatomic)UILabel* titleLable;
@property(retain,nonatomic)UIButton* leftButton;
@property(retain,nonatomic)UIButton* rightButton;
@property(retain,nonatomic)UIImageView* imageView;

-(void)setNavAnimation:(NSString*)type offset:(CGPoint)offset;
@end
