//
//  AuthTraceTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthTraceTableViewCell : UITableViewCell
{
    UIView* viewTrace;
    
}
@property(retain,nonatomic)NSString* title;
@property(assign,nonatomic)BOOL isFinished;
@end
