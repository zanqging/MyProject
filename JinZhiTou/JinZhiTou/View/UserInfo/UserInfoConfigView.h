//
//  UserInfoConfig.h
//  JinZhiTou
//
//  Created by air on 15/11/7.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UserInfoConigDelegate <NSObject>

-(void)userInfoConfigView:(id)userInfoConfigView target:(UIViewController*)controller selectedIndex:(int)index data:(NSDictionary*)data;

@end

@interface UserInfoConfigView : UIView
{
    UIView* view;
}
@property(retain,nonatomic)id <UserInfoConigDelegate>delegate;
@property(retain,nonatomic)UIView* personalView;
@property(retain,nonatomic)UIView* instituteView;
@property(retain,nonatomic)UIViewController* viewController;
@end


