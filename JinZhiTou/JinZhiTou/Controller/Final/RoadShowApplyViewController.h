//
//  FinialApplyViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PECropViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface RoadShowApplyViewController : UIViewController
@property (strong ,nonatomic) AVPlayer *player;//播放器，用于录制完视频后播放视频
@property(retain,nonatomic)UIImagePickerController* imagePicker;
//播放器视图控制器
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;

-(void)loadCompanyData;
@end
