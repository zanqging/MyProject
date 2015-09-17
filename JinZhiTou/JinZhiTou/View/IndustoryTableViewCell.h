//
//  IndustoryTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/9/9.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndustoryTableViewCell;

@protocol IndustorySelectedDelegate <NSObject>

@optional
-(void)IndustoryTableViewCell:(IndustoryTableViewCell*)industoryTableViewCell data:(NSDictionary*)dic;

@required
-(void)IndustoryTableViewCell:(IndustoryTableViewCell*)industoryTableViewCell finished:(BOOL)isFinished;

@end

@interface IndustoryTableViewCell : UITableViewCell

@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)id <IndustorySelectedDelegate> delegate;

@end


