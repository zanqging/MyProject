//
//  BedgesView.h
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BedgesView : UIView
{
    UIImageView* imageView;
    UILabel* label;
}
@property(retain,nonatomic)UIColor* tinColor;
@property(retain,nonatomic)NSString* title;
@property(retain,nonatomic)NSString* number;
@end
