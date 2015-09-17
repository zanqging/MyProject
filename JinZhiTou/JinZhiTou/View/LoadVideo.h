//
//  LoadVideo.h
//  JinZhiTou
//
//  Created by air on 15/8/15.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadingView.h"
@interface LoadVideo : UIView
{
    UploadingView* loadingView;
}

@property(assign,nonatomic)BOOL isLoaded;
@property(assign,nonatomic)float progress;
@property(assign,nonatomic)BOOL isComplete;
@property(assign,nonatomic)BOOL uploadStart;
@property(retain,nonatomic)UIImage* imgage;
@property(retain,nonatomic)UILabel* descLabel;
@property(retain,nonatomic)UILabel* titleLabel;
@property(retain,nonatomic)UIImageView* imgView;
@property(retain,nonatomic)UIImageView* thumailView;
@property(retain,nonatomic)UIImageView* deleteImgView;
@end
