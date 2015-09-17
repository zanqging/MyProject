//
//  SwitchSelect.h
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchSelect : UIView
@property(assign,nonatomic)int type;
@property(assign,nonatomic)BOOL isSelected;
@property(retain,nonatomic)NSString* titleName;

-(id)initWithFrame:(CGRect)frame type:(int)type;
@end
