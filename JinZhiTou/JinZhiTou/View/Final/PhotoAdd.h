//
//  PhotoAdd.h
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoAdd : UIView
{
    UIImageView* deleteView;
}
@property(assign,nonatomic)int index;
@property(retain,nonatomic)UIImage* image;
@property(retain,nonatomic)NSString* title;
@end
