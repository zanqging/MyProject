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
@property(assign,nonatomic)BOOL isScuesssed;
@property(retain,nonatomic)UILabel* labelContent;
@property(retain,nonatomic)NSString* content;
@property(retain,nonatomic)NSString* createDateTime;
@property(retain,nonatomic)NSString* handleDateTime;
@property(retain,nonatomic)NSString* auditDateTime;
@end
