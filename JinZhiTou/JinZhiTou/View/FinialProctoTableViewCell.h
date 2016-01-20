//
//  FinialProctoTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SDAutoLayout.h"
@interface FinialProctoTableViewCell : UITableViewCell
{
    UILabel* label;  //内容
    UIImageView* imgView; //标题
}
@property(assign,nonatomic)BOOL isSelected;
@property(retain,nonatomic)NSString* selectedImageName;
@property(retain,nonatomic)NSString* unSelectedImageName;
-(void)setImageWithName:(NSString*)name setText:(NSString*)text;
@end
