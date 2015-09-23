//
//  FinialSuccessViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/14.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinialSuccessViewController : UIViewController
{
    UILabel* label;
}
@property(retain,nonatomic)NSString* titleStr;
@property(retain,nonatomic)NSString* content;
@property(assign,nonatomic)int type; //0:来现场报名,1:投资报名
@end

