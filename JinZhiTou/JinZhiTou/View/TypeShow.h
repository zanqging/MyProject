//
//  TypeShow.h
//  JinZhiTou
//
//  Created by air on 15/9/7.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TypeShow;
@protocol TypeShowDelegate <NSObject>

-(void)typeShow:(TypeShow*)typeShow selectedIndex:(NSInteger)selectedIndex didSelectedString:(NSString*)resultString;

@end

@interface TypeShow : UIView
{
    UIScrollView* scrollView;
}

@property(retain,nonatomic)NSMutableArray* dataArray;
@property(retain,nonatomic)id <TypeShowDelegate> delegate;
@property(retain,nonatomic)NSDictionary* currentSelectedDic;

-(id)initWithFrame:(CGRect)frame data:(NSMutableArray*)dataArray;

@end
