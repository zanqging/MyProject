//
//  WMPageController.m
//  WMPageController
//
//  Created by Mark on 15/6/11.
//  Copyright (c) 2015年 yq. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WMPageController.h"
#import "WMPageConst.h"
#import "WMTableViewController.h"
#import "RoadShowDetailViewController.h"
@interface WMPageController () <WMMenuViewDelegate,UIScrollViewDelegate,navViewDelegate,WMtableViewCellDelegate> {
    CGFloat _viewHeight;
    CGFloat _viewWidth;
    CGFloat _viewX;
    CGFloat _viewY;
    CGFloat _targetX;
    BOOL    _animate;
}
// 用于记录子控制器view的frame，用于 scrollView 上的展示的位置
@property (nonatomic, strong) NSMutableArray *childViewFrames;
// 当前展示在屏幕上的控制器，方便在滚动的时候读取 (避免不必要计算)
@property (nonatomic, strong) NSMutableDictionary *displayVC;
// 用于记录销毁的viewController的位置 (如果它是某一种scrollView的Controller的话)
@property (nonatomic, strong) NSMutableDictionary *posRecords;
// 用于缓存加载过的控制器
@property (nonatomic, strong) NSCache *memCache;
// 收到内存警告的次数
@property (nonatomic, assign) int memoryWarningCount;
@end

@implementation WMPageController

#pragma mark - Lazy Loading
- (NSMutableDictionary *)posRecords {
    if (_posRecords == nil) {
        _posRecords = [[NSMutableDictionary alloc] init];
    }
    return _posRecords;
}

- (NSMutableDictionary *)displayVC {
    if (_displayVC == nil) {
        _displayVC = [[NSMutableDictionary alloc] init];
    }
    return _displayVC;
}

#pragma mark - Public Methods
- (instancetype)initWithViewControllerClasses:(NSArray *)classes andTheirTitles:(NSArray *)titles {
    if (self = [super init]) {
        NSAssert(classes.count == titles.count, @"classes.count != titles.count");
        _viewControllerClasses = [NSArray arrayWithArray:classes];
        _titles = [NSArray arrayWithArray:titles];

        [self setup];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setCachePolicy:(WMPageControllerCachePolicy)cachePolicy {
    _cachePolicy = cachePolicy;
    self.memCache.countLimit = _cachePolicy;
}

- (void)setItemsMargins:(NSArray *)itemsMargins {
    NSAssert(itemsMargins.count == self.viewControllerClasses.count + 1, @"item's margin's number must equal to viewControllers's count + 1");
    _itemsMargins = itemsMargins;
}

- (void)setItemsWidths:(NSArray *)itemsWidths {
    NSAssert(itemsWidths.count == self.titles.count, @"itemsWidths.count != self.titles.count");
    _itemsWidths = [itemsWidths copy];
}

- (void)setSelectIndex:(int)selectIndex {
    _selectIndex = selectIndex;
    [self refresh];
    self.isTransparent = YES;
    if (self.menuView) {
        [self.menuView selectItemAtIndex:selectIndex];
    }
}

- (void)setViewFrame:(CGRect)viewFrame {
    _viewFrame = viewFrame;
    if (self.menuView) {
        [self viewDidLayoutSubviews];
    }
}

#pragma mark - Private Methods

// 当子控制器init完成时发送通知
- (void)postAddToSuperViewNotificationWithIndex:(int)index {
    if (!self.postNotification) return;
    NSDictionary *info = @{
                           @"index":@(index),
                           @"title":self.titles[index]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidAddToSuperViewNotification
                                                        object:info];
}

// 当子控制器完全展示在user面前时发送通知
- (void)postFullyDisplayedNotificationWithCurrentIndex:(int)index {
    if (!self.postNotification) return;
    NSDictionary *info = @{
                           @"index":@(index),
                           @"title":self.titles[index]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidFullyDisplayedNotification
                                                        object:info];
}

// 初始化一些参数，在init中调用
- (void)setup {
    _titleSizeSelected  = WMTitleSizeSelected;
    _titleColorSelected = WMTitleColorSelected;
    _titleSizeNormal    = WMTitleSizeNormal;
    _titleColorNormal   = WMTitleColorNormal;
    
    _menuBGColor   = WMMenuBGColor;
    _menuHeight    = WMMenuHeight;
    _menuItemWidth = WMMenuItemWidth;
    
    _memCache = [[NSCache alloc] init];
}

// 包括宽高，子控制器视图 frame
- (void)calculateSize {
    if (CGRectEqualToRect(self.viewFrame, CGRectZero)) {
        _viewWidth = self.view.frame.size.width;
        _viewHeight = self.view.frame.size.height - self.menuHeight;
    } else {
        _viewWidth = self.viewFrame.size.width;
        _viewHeight = self.viewFrame.size.height - self.menuHeight;
    }
    _viewX = self.viewFrame.origin.x;
    _viewY = self.viewFrame.origin.y;
    // 重新计算各个控制器视图的宽高
    _childViewFrames = [NSMutableArray array];
    
    if (self.titles.count==0) {
        CGRect frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        [_childViewFrames addObject:[NSValue valueWithCGRect:frame]];
    }else{
        for (int i = 0; i < self.titles.count; i++) {
            CGRect frame = CGRectMake(i*_viewWidth, 0, _viewWidth, _viewHeight);
            [_childViewFrames addObject:[NSValue valueWithCGRect:frame]];
        }
    }
}

- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = self.bounces;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)addMenuView {
    if (self.titles.count>0) {
        CGRect frame = CGRectMake(_viewX, _viewY, _viewWidth, self.menuHeight);
        WMMenuView *menuView = [[WMMenuView alloc] initWithFrame:frame buttonItems:self.titles backgroundColor:self.menuBGColor norSize:self.titleSizeNormal selSize:self.titleSizeSelected norColor:self.titleColorNormal selColor:self.titleColorSelected];
        menuView.delegate = self;
        menuView.style = self.menuViewStyle;
        menuView.progressHeight = self.progressHeight;
        if (self.titleFontName) {
            menuView.fontName = self.titleFontName;
        }
        if (self.progressColor) {
            menuView.lineColor = self.progressColor;
        }
        [self.view addSubview:menuView];
        self.menuView = menuView;
        // 如果设置了初始选择的序号，那么选中该item
        if (self.selectIndex != 0) {
            [self.menuView selectItemAtIndex:self.selectIndex];
        }
        self.loadingViewFrame = CGRectMake(0, POS_Y(self.menuView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.menuView));
    }else{
        self.loadingViewFrame = CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view));
    }
    
    
    
}


- (void)layoutChildViewControllers {
    int currentPage = fabs(self.scrollView.contentOffset.x / _viewWidth);
    int start = currentPage == 0 ? currentPage : (currentPage - 1);
    int end = (currentPage == self.titles.count - 1) ? currentPage : (currentPage + 1);
    for (int i = start; i <= end; i++) {
        CGRect frame = [self.childViewFrames[i] CGRectValue];
        UIViewController *vc = [self.displayVC objectForKey:@(i)];
        if ([self isInScreen:frame]) {
            if (vc == nil) {
                // 先从 cache 中取
                vc = [self.memCache objectForKey:@(i)];
                if (vc) {
                    // cache 中存在，添加到 scrollView 上，并放入display
                    [self addCachedViewController:vc atIndex:i];
                } else {
                    // cache 中也不存在，创建并添加到display
                    [self addViewControllerAtIndex:i];
                }
                [self postAddToSuperViewNotificationWithIndex:i];
            }
        } else {
            if (vc) {
                // vc不在视野中且存在，移除他
                [self removeViewController:vc atIndex:i];
            }
        }
    }
}

- (void)addCachedViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrames[index] CGRectValue];
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self.displayVC setObject:viewController forKey:@(index)];
}

// 添加子控制器
- (void)addViewControllerAtIndex:(int)index {
    Class vcClass = self.viewControllerClasses[0];
    UIViewController *viewController = [[vcClass alloc] init];
//    if (self.values && self.keys) {
//        [viewController setValue:self.values[index] forKey:self.keys[index]];
//    }
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrames[index] CGRectValue];
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self.displayVC setObject:viewController forKey:@(index)];
    
    [self backToPositionIfNeeded:viewController atIndex:index];
}

// 移除控制器，且从display中移除
- (void)removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self rememberPositionIfNeeded:viewController atIndex:index];
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.displayVC removeObjectForKey:@(index)];
    
    // 放入缓存
    if (![self.memCache objectForKey:@(index)]) {
        [self.memCache setObject:viewController forKey:@(index)];
    }
}

- (void)backToPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) return;
#pragma clang diagnostic pop
    if ([self.memCache objectForKey:@(index)]) return;
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        NSValue *pointValue = self.posRecords[@(index)];
        if (pointValue) {
            CGPoint pos = [pointValue CGPointValue];
            // 奇怪的现象，我发现 collectionView 的 contentSize 是 {0, 0};
            [scrollView setContentOffset:pos];
        }
    }
}

- (void)rememberPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) return;
#pragma clang diagnostic pop
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        CGPoint pos = scrollView.contentOffset;
        self.posRecords[@(index)] = [NSValue valueWithCGPoint:pos];
    }
}

- (UIScrollView *)isKindOfScrollViewController:(UIViewController *)controller {
    UIScrollView *scrollView = nil;
    if ([controller.view isKindOfClass:[UIScrollView class]]) {
        // Controller的view是scrollView的子类(UITableViewController/UIViewController替换view为scrollView)
        scrollView = (UIScrollView *)controller.view;
    } else if (controller.view.subviews.count >= 1) {
        // Controller的view的subViews[0]存在且是scrollView的子类，并且frame等与view得frame(UICollectionViewController/UIViewController添加UIScrollView)
        UIView *view = controller.view.subviews[0];
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
        }
    }
    return scrollView;
}

- (BOOL)isInScreen:(CGRect)frame {
    CGFloat x = frame.origin.x;
    CGFloat ScreenWidth = self.scrollView.frame.size.width;
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    if (CGRectGetMaxX(frame) > contentOffsetX && x-contentOffsetX < ScreenWidth) {
        return YES;
    } else {
        return NO;
    }
}

- (void)resetMenuView {
    WMMenuView *oldMenuView = self.menuView;
    [self addMenuView];
    [oldMenuView removeFromSuperview];
}

- (void)growCachePolicyAfterMemoryWarning {
    self.cachePolicy = WMPageControllerCachePolicyBalanced;
    [self performSelector:@selector(growCachePolicyToHigh) withObject:nil afterDelay:2.0 inModes:@[NSRunLoopCommonModes]];
}

- (void)growCachePolicyToHigh {
    self.cachePolicy = WMPageControllerCachePolicyHigh;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景颜色
    self.view.backgroundColor=ColorTheme;
    
    //TabBarItem 设置
    UIImage* image=IMAGENAMED(@"btn_tourongzi_selected");
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setSelectedImage:image];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorTheme,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    //设置标题
    [self.navView setTitle:@"金指投"];
    NSMutableArray* menuArray = @[@"项目库",@"智囊团",@"投资人"];
    self.navView.delegate  = self;
    self.navView.menuArray  =menuArray;
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:IMAGENAMED(@"top-caidan") forState:UIControlStateNormal];
//    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction:)]];
//    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction:)]];
    [self.navView.rightButton setImage:IMAGENAMED(@"sousuobai") forState:UIControlStateNormal];
    
    
    NSArray *viewControllers = @[[WMTableViewController class]];
    NSArray *titles = @[@"待融资",@"融资中", @"已融资", @"预选项目"];
    
    _viewControllerClasses = [NSArray arrayWithArray:viewControllers];
    _titles = [NSArray arrayWithArray:titles];
    
    [self setup];
    
    self.titleSizeSelected = 15;
    self.pageAnimatable = YES;
    self.menuViewStyle = WMMenuViewStyleFoold;
    self.titleColorSelected = [UIColor whiteColor];
    self.titleColorNormal = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    self.progressColor = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    self.itemsWidths = @[@(70),@(70),@(70),@(70)]; // 这里可以设置不同的宽度
    
    
    self.title = @"投融资";

    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addScrollView];
    
    [self addViewControllerAtIndex:self.selectIndex];
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    
    [self setViewFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-110)];
    self.loadingViewFrame = CGRectMake(0, POS_Y(self.navView)+self.menuHeight, WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView)-self.menuHeight-kBottomBarHeight);
    [self refresh];
}

-(void)refresh
{
    //网络请求
    self.startLoading  =YES;
    NSString* srverUrl = [NSString stringWithFormat:@"project/%d/%d/",self.selectIndex+1,0];
    [self.httpUtil getDataFromAPIWithOps:srverUrl  type:0 delegate:self sel:@selector(requestFinished:) method:@"GET"];
}

-(void)thinkTank
{
    //网络请求
    self.startLoading  =YES;
    NSString* srverUrl = [THINKTANK stringByAppendingFormat:@"%d/",0];
    [self.httpUtil getDataFromAPIWithOps:srverUrl  type:0 delegate:self sel:@selector(requestFinished:) method:@"GET"];
}


-(void)finialCommicuteList
{
    //网络请求
    self.startLoading  =YES;
    NSString* srverUrl = [INVEST_LIST stringByAppendingFormat:@"%d/",0];
    [self.httpUtil getDataFromAPIWithOps:srverUrl  type:0 delegate:self sel:@selector(requestFinished:) method:@"GET"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 计算宽高及子控制器的视图frame
    [self calculateSize];
    CGRect scrollFrame;
    if (self.titles.count>0) {
        scrollFrame = CGRectMake(_viewX, _viewY + self.menuHeight, _viewWidth, _viewHeight);
    }else{
        scrollFrame = CGRectMake(_viewX, _viewY, _viewWidth, _viewHeight);
    }
    self.scrollView.frame = scrollFrame;
    if (self.titles.count>0) {
        self.scrollView.contentSize = CGSizeMake(self.titles.count*_viewWidth, _viewHeight-self.menuHeight);
    }else{
        self.scrollView.contentSize = CGSizeMake(self.titles.count*_viewWidth, _viewHeight);
    }
    
    [self.scrollView setContentOffset:CGPointMake(self.selectIndex*_viewWidth, 0)];

    self.currentViewController.view.frame = [self.childViewFrames[self.selectIndex] CGRectValue];
    [self resetMenuView];

    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.memoryWarningCount++;
    self.cachePolicy = WMPageControllerCachePolicyLowMemory;
    // 取消正在增长的 cache 操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyAfterMemoryWarning) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyToHigh) object:nil];
    
    [self.memCache removeAllObjects];
    [self.posRecords removeAllObjects];
    self.posRecords = nil;
    
    // 如果收到内存警告次数小于 3，一段时间后切换到模式 Balanced
    if (self.memoryWarningCount < 3) {
        [self performSelector:@selector(growCachePolicyAfterMemoryWarning) withObject:nil afterDelay:3.0 inModes:@[NSRunLoopCommonModes]];
    }
}

#pragma NavViewDelegate
-(void)navView:(id)navView tapIndex:(int)index
{
    NSLog(@"点击:%d",index);
    self.menuSelectIndex = index;
    self.selectIndex = 0;
    switch (self.menuSelectIndex) {
        case 0:
            _titles  =@[@"待融资",@"融资中", @"已融资", @"预选项目"];
            self.itemsWidths =  @[@(70),@(70),@(70),@(70)];
            self.menuView.items = _titles;
            [self resetMenuView];
            [self refresh];
            break;
        case 1:
            _titles  =@[];
            self.itemsWidths =  @[];
            self.menuView.items = _titles;
            [self resetMenuView];
            [self thinkTank];
            break;
        case 2:
            _titles  =@[@"个人投资人",@"机构投资人"];
            self.itemsWidths = @[@(100),@(100)]; // 这里可以设置不同的宽度
            self.menuView.items = _titles;
            [self resetMenuView];
            [self thinkTank];
            break;
        default:
            break;
    }
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutChildViewControllers];
    if (_animate) {
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        if (contentOffsetX < 0) {
            contentOffsetX = 0;
        }
        if (contentOffsetX > scrollView.contentSize.width - _viewWidth) {
            contentOffsetX = scrollView.contentSize.width - _viewWidth;
        }
        CGFloat rate = contentOffsetX / _viewWidth;
        [self.menuView slideMenuAtProgress:rate];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _animate = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _selectIndex = (int)scrollView.contentOffset.x / _viewWidth;
    switch (self.menuSelectIndex) {
        case 0:
            [self refresh];
            break;
        case 1:
            [self thinkTank];
            break;
        case 2:
            [self thinkTank];
            break;
        default:
            break;
    }
    self.isTransparent = YES;
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat rate = _targetX / _viewWidth;
        [self.menuView slideMenuAtProgress:rate];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    _targetX = targetContentOffset->x;
}
#pragma WMTableViewController
- (void)wmTableViewController:(id)wmTableViewController tapIndexPath:(NSIndexPath *)indexPath data:(NSDictionary *)dic
{
    RoadShowDetailViewController* controller = [[RoadShowDetailViewController alloc]init];
    controller.dic = [NSMutableDictionary dictionaryWithDictionary:dic];
    controller.type=1;
    controller.title = self.navView.title;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - WMMenuView Delegate
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    NSInteger gap = (NSInteger)labs(index - currentIndex);
    if (_selectIndex != (int)index) {
//        _selectIndex = (int)index;
        self.selectIndex = (int)index;
    }
    _animate = NO;
    CGPoint targetP = CGPointMake(_viewWidth*index, 0);
    [self.scrollView setContentOffset:targetP animated:gap > 1 ? NO : self.pageAnimatable];
    if (gap > 1 || !self.pageAnimatable) {
        // 由于不触发 -scrollViewDidScroll: 手动处理控制器
        [self layoutChildViewControllers];
        self.currentViewController = self.displayVC[@(self.selectIndex)];
        [self postFullyDisplayedNotificationWithCurrentIndex:(int)index];
    }
    
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    if (self.itemsWidths) {
        return [self.itemsWidths[index] floatValue];
    }
    return self.menuItemWidth;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index {
    if (self.itemsMargins) {
        return [self.itemsMargins[index] floatValue];
    }
    return self.itemMargin;
}


-(void)setDataDic:(NSMutableDictionary *)dataDic
{
    [super setDataDic:dataDic];
    if (self.menuSelectIndex==0) {
        self.currentViewController.dataArray = (NSMutableArray*)self.dataDic;
    }else if (self.menuSelectIndex==1){
        self.currentViewController.dataArray = (NSMutableArray*)self.dataDic;
    }else{
        self.currentViewController.dataArray = (NSMutableArray*)self.dataDic;
    }
    self.currentViewController.type = self.menuSelectIndex;
    if (!self.currentViewController.delegate) {
        self.currentViewController.delegate  = self;
    }
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
        
    if(jsonDic!=nil)
    {
        self.dataDic = [jsonDic valueForKey:@"data"];
        self.startLoading  =NO;
        
    }else{
        self.isNetRequestError = YES;
    }
}

@end
