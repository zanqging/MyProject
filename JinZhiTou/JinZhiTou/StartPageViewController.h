//
//  HomePageViewController.h
//  WeiNI
//
//  Created by air on 14/12/3.
//  Copyright (c) 2014年 weini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpUtils.h"
#import "SlideView.h"
#import "SlideViewStartPage.h"
@interface StartPageViewController : UIViewController
{
    UIScrollView* wnScrollView; //滚动视图
    UIPageControl* wnPageControl;  //分页控件
    
    SlideView* slidView1;
    SlideView* slidView2;
    SlideView* slidView3;
    SlideView* slidView4;
    SlideViewStartPage* startPage;
    
}

@property(assign)int currentPage;
@property(retain,nonatomic)UIScrollView* wnScrollView;
@property(retain,nonatomic)UIPageControl* wnPageControl;

@end
