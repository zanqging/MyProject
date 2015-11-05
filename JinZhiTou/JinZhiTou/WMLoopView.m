//
//  WMLoopView.m
//  WMLoopView
//
//  Created by Mark on 15/3/30.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMLoopView.h"
#import "UConstants.h"
#define kIdentifier @"WMLoopViewCellIdentifier"
#define kPageH 20
@interface WMLoopView()
@property (nonatomic, strong) NSMutableArray *currentImages;
@end

@implementation WMLoopView
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images autoPlay:(BOOL)isAuto delay:(NSTimeInterval)timeInterval {
    if (self = [super initWithFrame:frame]) {
        _autoPlay = isAuto;
        _timeInterval = timeInterval;
        _images = images;

        if (self.autoPlay == YES) {
            [self toPlay];
        }
    }
    return self;
}

#pragma mark - Public Methods
- (void)addPageControl {
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, height-kPageH, width, kPageH)];
    bgView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.2];
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, width, kPageH)];
    pageControl.numberOfPages = self.images.count;
    pageControl.currentPage = 0;
    pageControl.userInteractionEnabled = NO;
    [self addSubview:bgView];
}

#pragma mark - Private Methods
- (void)toPlay {
    [self performSelector:@selector(autoPlayToNextPage) withObject:nil afterDelay:_timeInterval];
}

- (void)autoPlayToNextPage {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoPlayToNextPage) object:nil];
    [self performSelector:@selector(autoPlayToNextPage) withObject:nil afterDelay:_timeInterval];
}


#pragma mark - delegate
- (void)singleTapped:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(loopViewDidSelectedImage:index:)]) {
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
}

@end
