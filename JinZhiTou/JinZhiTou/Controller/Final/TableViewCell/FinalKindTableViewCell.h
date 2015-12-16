//
//  FinalKindTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/7/27.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinalKindTableViewCell : UITableViewCell
@property (retain, nonatomic)UILabel *lblFunName;
@property(assign,nonatomic)BOOL isSelected;

@property(retain,nonatomic)NSString* content;
@end
