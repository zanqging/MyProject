//
//  ProgressTraceView.h
//  JinZhiTou
//
//  Created by air on 15/8/16.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressTraceView : UIView
{
    UIImageView* progressBackView; //进度条背景
    UIImageView* progressView ; //进度
    UIImageView* currentImgView;
    
    UILabel*  leftTitleLabel; 
    UILabel*  righttitleLabel;
}


@property(assign,nonatomic)float progress;
@end
