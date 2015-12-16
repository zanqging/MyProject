//
//  UploadingView.h
//  JinZhiTou
//
//  Created by air on 15/8/15.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THProgressView.h"
@interface UploadingView : UIView
{
    THProgressView * progressView;
}
@property(assign,nonatomic)BOOL isTransparent;
@property(retain,nonatomic)UILabel* progressLabel;
@property(retain,nonatomic)UIImageView * imgView;
@property (nonatomic, strong) NSArray *progressViews;
-(void)startAnimation;
-(void)stopAnitmation;

-(void)setProgress:(float)progress;
@end
