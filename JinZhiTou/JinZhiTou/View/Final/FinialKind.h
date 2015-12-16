//
//  FinialKind.h
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinialKind : UIView
{
    
}
@property(retain,nonatomic)UILabel* label;
@property(assign,nonatomic)BOOL isSelected;
@property(retain,nonatomic)UIImageView* imgView;
-(void)setImageWithNmame:(NSString*)name setText:(NSString*)text;
@end
