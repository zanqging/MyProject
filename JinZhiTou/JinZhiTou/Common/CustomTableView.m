//
//  CustomTableView.m
//  
//
//  Created by klbest1 on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CustomTableView.h"

@interface CustomTableView ()
{
    SlideTableViewCell *slidedCell;
    HitView            *hitView;
}

@property (nonatomic,assign) BOOL canCustomEdit;

@end

@implementation CustomTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (_homeTableView == nil) {
            frame.size.height-=frame.origin.y;
            frame.origin.y=0;
            _homeTableView = [[UITableViewCustomView alloc] initWithFrame:frame];
            _homeTableView.delegate = self;
            _homeTableView.dataSource = self;
            [_homeTableView setBackgroundColor:[UIColor clearColor]];
        }
        if (_tableInfoArray == Nil) {
            _tableInfoArray = [[NSMutableArray alloc] init];
        }
        [self addSubview:_homeTableView];
    }
    return self;
}

-(void)setCanCustomEdit:(BOOL)canCustomEdit{
    if (_canCustomEdit != canCustomEdit) {
        _canCustomEdit = canCustomEdit;
        if (_canCustomEdit) {
            if (hitView == nil) {
                hitView = [[HitView alloc] init];
                hitView.delegate = self;
                hitView.frame = self.frame;
                NSString *vRectStr = NSStringFromCGRect(self.frame);
                NSLog(@"%@",vRectStr);
            }
            hitView.frame = self.frame;
            [self addSubview:hitView];
            
            self.homeTableView.scrollEnabled = NO;
        }else{
            slidedCell = nil;
            [hitView removeFromSuperview];
            self.homeTableView.scrollEnabled = YES;
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_delegate respondsToSelector:@selector(numberOfRowsInTableView:InSection:FromView:)]) {
       NSInteger vRows = [_dataSource numberOfRowsInTableView:tableView InSection:section FromView:self];
        mRowCount = vRows;
        if (mRowCount==0) {
            [self.homeTableView setIsNone:YES];
            return 0;
        }
        [self.homeTableView setIsNone:NO];
        return mRowCount ;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_delegate respondsToSelector:@selector(heightForRowAthIndexPath:IndexPath:FromView:)]) {
        float vRowHeight = [_delegate heightForRowAthIndexPath:tableView IndexPath:indexPath FromView:self];
        return vRowHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_dataSource respondsToSelector:@selector(cellForRowInTableView:IndexPath:FromView:)]) {
        SlideTableViewCell *vCell = [_dataSource cellForRowInTableView:tableView IndexPath:indexPath FromView:self];
        vCell.delegate = self;
        return vCell;
    }
    return Nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_delegate respondsToSelector:@selector(didSelectedRowAthIndexPath:IndexPath: FromView:)]) {
        [_delegate didSelectedRowAthIndexPath:tableView IndexPath:indexPath FromView:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if (slidedCell == [tableView cellForRowAtIndexPath:indexPath]) {
        [slidedCell hideMenuView:YES Animated:YES ];
        return NO;
    }
    return YES;
}

#pragma mark Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
    if ([_delegate respondsToSelector:@selector(refreshData: FromView:)]) {
        [_delegate refreshData:^{
            [self doneLoadingTableViewData];
        } FromView:self];
    }else{
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    }
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
    [self.homeTableView reloadData];
}




#pragma mark SlideTableViewCellDelegate
-(void)didCellWillShow:(id)aSender{
    slidedCell = aSender;
    self.canCustomEdit = YES;
}

-(void)didCellWillHide:(id)aSender{
    slidedCell = nil;
    self.canCustomEdit = NO;
}

-(void)didCellHided:(id)aSender{
    slidedCell = nil;
    self.canCustomEdit = NO;
}

-(void)didCellShowed:(id)aSender{
    slidedCell = aSender;
    self.canCustomEdit = YES;
    NSLog(@"调用Delegate");
}

#pragma mark HitViewDelegate
-(UIView *)hitViewHitTest:(CGPoint)point withEvent:(UIEvent *)event TouchView:(UIView *)aView{
    BOOL vCloudReceiveTouch = NO;
//    CGPoint vTouchPoint = [self convertPoint:point fromView:self.homeTableView];
    CGRect vSlidedCellRect = [self convertRect:slidedCell.frame fromView:self.homeTableView];
    vCloudReceiveTouch = CGRectContainsPoint(vSlidedCellRect, point);
    if (!vCloudReceiveTouch) {
        [slidedCell hideMenuView:YES Animated:YES];
    }
    return vCloudReceiveTouch ? [slidedCell hitTest:point withEvent:event] : aView;
}

#pragma mark 点击删除
-(void)didCellClickedDeleteButton:(UITableViewCell *)aSender{
    self.canCustomEdit = NO;
    NSIndexPath *vIndex = [self.homeTableView indexPathForCell:aSender];
    if ([_delegate respondsToSelector:@selector(didDeleteCellAtIndexpath:IndexPath:FromView:)]) {
        [_delegate didDeleteCellAtIndexpath:self.homeTableView IndexPath:vIndex FromView:self];
    }
    [self.homeTableView deleteRowsAtIndexPaths:@[vIndex,] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 点击更多
-(void)didCellClickedMoreButton:(id)aSender{
}

@end
