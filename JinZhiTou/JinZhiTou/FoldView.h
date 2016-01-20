//
//  FoldView.h
//  JinZhiTou
//
//  Created by air on 15/9/24.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FoldView : UIView
{
     UIImageView* imgView;
}
@property(assign,nonatomic)BOOL isStart;
@property(assign,nonatomic)BOOL isEnd;
@property(assign,nonatomic)BOOL isLimit;
@property(assign,nonatomic)BOOL isExpand;

@property(retain,nonatomic)NSString* content;
@property(retain,nonatomic)UILabel* labelTitle;
@property(retain,nonatomic)UILabel* labelContent;
@property(retain,nonatomic)UIImageView* imageView;
@property(retain,nonatomic)UIImageView* expandImgView;

@property(retain,nonatomic)NSMutableArray* nextViews;
@end
