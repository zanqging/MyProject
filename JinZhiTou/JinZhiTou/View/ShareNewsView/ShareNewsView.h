//
//  ShareNewsView.h
//  JinZhiTou
//
//  Created by air on 15/10/28.
//  Copyright © 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface ShareNewsView : UIView<UITextViewDelegate>
{
    UIView*  contentView;
    UIImageView* imgView;
    UILabel* titleLabel;
    UILabel* contentLabel;
    UITextView* textView;
}
@property(retain,nonatomic)NSDictionary* dic ;
@property(retain,nonatomic)UIButton* btnCancel;
@property(retain,nonatomic)UIButton* btnSure;
@end
