//
//  PublishViewController.h
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavView.h"
#import "MWPhotoBrowser.h"
#import "CycleViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface PublishViewController : UIViewController<UITextViewDelegate,MWPhotoBrowserDelegate>
@property (retain, nonatomic)UITextView *textView;
@property (retain, nonatomic)UIButton *btnSelect;
@property (retain, nonatomic)UIView *imgContentView;
@property(retain,nonatomic)NSMutableArray* imgSelectArray;
@property(retain,nonatomic)NSMutableArray* imgSelectAssetArray;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *assets;
@property(retain,nonatomic)MWPhotoBrowser *browser;
@property(assign,nonatomic)BOOL isSelectPic;

@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;
@property(retain,nonatomic)NavView* navView;
@property(retain,nonatomic)CycleViewController* controller;

- (void)loadAssets;

@end
