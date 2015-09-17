//
//  DialogView.h
//  JinZhiTou
//
//  Created by air on 15/8/12.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DialogView : UIView
{
    UIImageView* imageView;
    UILabel* messageLabel;
    
}

@property(assign,nonatomic)int type;
@property(assign,nonatomic)BOOL status;
@property(retain,nonatomic)NSString* title;
@property(retain,nonatomic)UIButton* cancelButton;
@property(retain,nonatomic)UIButton* shureButton;
@end
