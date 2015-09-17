//
//  MenuView.h
//  JinZhiTou
//
//  Created by air on 15/8/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol btnActionDelegate <NSObject>
@required
-(void)button:(UIButton *)button data:(NSDictionary*)data;
@end

@interface MenuPopView : UIView
@property(assign,nonatomic)BOOL isSelected;
@property(retain,nonatomic)id <btnActionDelegate> delegate;
@property(retain,nonatomic)NSMutableArray* dataArray;
@end


