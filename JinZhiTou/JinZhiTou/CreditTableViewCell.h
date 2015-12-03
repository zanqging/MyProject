//
//  CreditTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/11/12.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditTableViewCell : UITableViewCell
{
    UIView* v;
    UILabel* titleLabel;
    UILabel* contentLabel;
}

@property(retain,nonatomic)NSDictionary* dataDic;
@end
