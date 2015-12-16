//
//  FinialProctoTableViewCell.h
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinialProctoTableViewCell : UITableViewCell
{
    UIImageView* imgView;
    UILabel* label;
}
@property(retain,nonatomic)NSString* unSelectedImageName;
@property(retain,nonatomic)NSString* selectedImageName;
@property(assign,nonatomic)BOOL isSelected;
-(void)setImageWithName:(NSString*)name setText:(NSString*)text;
@end
