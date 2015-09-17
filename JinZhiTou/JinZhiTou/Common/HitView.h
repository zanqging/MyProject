//
//  HitView.h
//  测试滑动删除Cell
//
//  Created by lin on 14-8-12.
//  Copyright (c) 2014年 lin. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

@protocol HitViewDelegate <NSObject>

-(UIView *)hitViewHitTest:(CGPoint)point withEvent:(UIEvent *)event TouchView:(UIView *)aView;

@end
@interface HitView : UIView

@property (nonatomic,assign) id<HitViewDelegate> delegate;
@end
