//
//  WMPageController.m
//  WMPageController
//
//  Created by Mark on 15/6/11.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMPageController.h"
#import "WMPageConst.h"
#import "INSViewController.h"
#import "WMTableViewController.h"
#import "ThinkTankViewController.h"
#import "ComFinanceViewController.h"
#import "RoadShowDetailViewController.h"
#import "PersonalFinanceViewController.h"
#import "PreProjectDetailViewController.h"

static CGFloat kWMMarginToNavigationItem = 6.0;
@interface WMPageController ()<navViewDelegate,WMtableViewCellDelegate> {
    CGFloat _viewHeight, _viewWidth, _viewX, _viewY, _targetX, _superviewHeight;
    BOOL    _animate, _hasInited, _shouldNotScroll;
}
@property (nonatomic, strong, readwrite) UIViewController *currentViewController;
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

@property (nonatomic, readonly) NSInteger childControllersCount;

@property(assign,nonatomic)int menuSelectIndex;
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

- (instancetype)initWithViewControllerClasses:(NSArray<Class> *)classes andTheirTitles:(NSArray<NSString *> *)titles {
    if (self = [super init]) {
        NSParameterAssert(classes.count == titles.count);
        _viewControllerClasses = [NSArray arrayWithArray:classes];
        _titles = [NSArray arrayWithArray:titles];

        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
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

- (void)setSelectIndex:(int)selectIndex {
    _selectIndex = selectIndex;
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

- (void)reloadData {
    [self clearDatas];
    [self resetScrollView];
    [self.memCache removeAllObjects];
    [self viewDidLayoutSubviews];
    [self resetMenuView];
}

- (void)updateTitle:(NSString *)title atIndex:(NSInteger)index {
    [self.menuView updateTitle:title atIndex:index andWidth:NO];
}

- (void)updateTitle:(NSString *)title andWidth:(CGFloat)width atIndex:(NSInteger)index {
    if (self.itemsWidths && index < self.itemsWidths.count) {
        NSMutableArray *mutableWidths = [NSMutableArray arrayWithArray:self.itemsWidths];
        mutableWidths[index] = @(width);
        self.itemsWidths = [mutableWidths copy];
    } else {
        NSMutableArray *mutableWidths = [NSMutableArray array];
        for (int i = 0; i < self.childControllersCount; i++) {
            CGFloat itemWidth = (i == index) ? width : self.menuItemWidth;
            [mutableWidths addObject:@(itemWidth)];
        }
        self.itemsWidths = [mutableWidths copy];
    }
    [self.menuView updateTitle:title atIndex:index andWidth:YES];
}

#pragma mark - Delegate
- (NSDictionary *)infoWithIndex:(NSInteger)index {
    NSString *title = [self titleAtIndex:index];
    return @{@"title": title, @"index": @(index)};
}

- (void)willCachedController:(UIViewController *)vc atIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(pageController:willCachedViewController:withInfo:)]) {
        NSDictionary *info = [self infoWithIndex:index];
        [self.delegate pageController:self willCachedViewController:vc withInfo:info];
    }
}

- (void)willEnterController:(UIViewController *)vc atIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(pageController:willEnterViewController:withInfo:)]) {
        NSDictionary *info = [self infoWithIndex:index];
        [self.delegate pageController:self willEnterViewController:vc withInfo:info];
    }
}

- (void)didEnterController:(UIViewController *)vc atIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(pageController:didEnterViewController:withInfo:)]) {
        NSDictionary *info = [self infoWithIndex:index];
        [self.delegate pageController:self didEnterViewController:vc withInfo:info];
    }
}

#pragma mark - Data source
- (NSInteger)childControllersCount {
    if ([self.dataSource respondsToSelector:@selector(numbersOfChildControllersInPageController:)]) {
        return [self.dataSource numbersOfChildControllersInPageController:self];
    }
    return self.viewControllerClasses.count;
}

- (UIViewController *)initializeViewControllerAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(pageController:viewControllerAtIndex:)]) {
        return [self.dataSource pageController:self viewControllerAtIndex:index];
    }
    return [[self.viewControllerClasses[index] alloc] init];
}

- (NSString *)titleAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(pageController:titleAtIndex:)]) {
        return [self.dataSource pageController:self titleAtIndex:index];
    }
    return self.titles[index];
}

#pragma mark - Private Methods

- (void)resetScrollView {
    if (self.scrollView) {
        [self.scrollView removeFromSuperview];
    }
    [self addScrollView];
    [self addViewControllerAtIndex:self.selectIndex];
    self.currentViewController = self.displayVC[@(self.selectIndex)];
}

- (void)clearDatas {
    _hasInited = NO;
    NSArray *displayingViewControllers = self.displayVC.allValues;
    for (UIViewController *vc in displayingViewControllers) {
        [vc.view removeFromSuperview];
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
    self.memoryWarningCount = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyAfterMemoryWarning) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyToHigh) object:nil];
    self.currentViewController = nil;
    [self.posRecords removeAllObjects];
    [self.displayVC removeAllObjects];
}

// 当子控制器init完成时发送通知
- (void)postAddToSuperViewNotificationWithIndex:(int)index {
    if (!self.postNotification) { return; }
    NSDictionary *info = @{
                           @"index":@(index),
                           @"menuIndex":@(self.menuSelectIndex),
                           @"title":[self titleAtIndex:index]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidAddToSuperViewNotification object:nil userInfo:info];
}

// 当子控制器完全展示在user面前时发送通知
- (void)postFullyDisplayedNotificationWithCurrentIndex:(int)index {
    if (!self.postNotification) { return; }
    NSDictionary *info = @{
                           @"index":@(index),
                           @"menuIndex":@(self.menuSelectIndex),
                           @"title":[self titleAtIndex:index]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidFullyDisplayedNotification object:nil userInfo:info];
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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.delegate = self;
    self.dataSource = self;
}

// 包括宽高，子控制器视图 frame
- (void)calculateSize {
    if (CGRectEqualToRect(self.viewFrame, CGRectZero)) {
        _viewWidth = self.view.frame.size.width;
        _viewHeight = self.view.frame.size.height - self.menuHeight - self.menuViewBottom;
    } else {
        _viewWidth = self.viewFrame.size.width;
        _viewHeight = self.viewFrame.size.height - self.menuHeight - self.menuViewBottom;
    }
    if (self.showOnNavigationBar && self.navigationController.navigationBar) {
        _viewHeight += self.menuHeight;
    }
    _viewX = self.viewFrame.origin.x;
    _viewY = self.viewFrame.origin.y;
    // 重新计算各个控制器视图的宽高
    _childViewFrames = [NSMutableArray array];
    for (int i = 0; i < self.childControllersCount; i++) {
        CGRect frame = CGRectMake(i*_viewWidth, 0, _viewWidth, _viewHeight);
        [_childViewFrames addObject:[NSValue valueWithCGRect:frame]];
    }
}

- (void)addScrollView {
    WMScrollView *scrollView = [[WMScrollView alloc] init];
    scrollView.scrollsToTop = NO;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = self.bounces;
    scrollView.otherGestureRecognizerSimultaneously = self.otherGestureRecognizerSimultaneously;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)addMenuView {
    CGRect frame = CGRectMake(_viewX, _viewY, _viewWidth, self.menuHeight);
    WMMenuView *menuView = [[WMMenuView alloc] initWithFrame:frame];
    menuView.backgroundColor = self.menuBGColor;
    menuView.delegate = self;
    menuView.dataSource = self;
    menuView.style = self.menuViewStyle;
    menuView.progressHeight = self.progressHeight;
    if (self.titleFontName) {
        menuView.fontName = self.titleFontName;
    }
    if (self.progressColor) {
        menuView.lineColor = self.progressColor;
    }
    if (self.showOnNavigationBar && self.navigationController.navigationBar) {
        self.navigationItem.titleView = menuView;
    } else {
        [self.view addSubview:menuView];
    }
    self.menuView = menuView;
    // 如果设置了初始选择的序号，那么选中该item
    if (self.selectIndex != 0) {
        [self.menuView selectItemAtIndex:self.selectIndex];
    }
}

- (void)layoutChildViewControllers {
    int currentPage = (int)self.scrollView.contentOffset.x / _viewWidth;
    int start = currentPage == 0 ? currentPage : (currentPage - 1);
    int end = (currentPage == self.childControllersCount - 1) ? currentPage : (currentPage + 1);
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

- (void)removeSuperfluousViewControllersIfNeeded {
    [self.displayVC enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIViewController * _Nonnull vc, BOOL * _Nonnull stop) {
        NSInteger index = key.integerValue;
        CGRect frame = [self.childViewFrames[index] CGRectValue];
        if (![self isInScreen:frame]) {
            [self removeViewController:vc atIndex:index];
        }
    }];
}

- (void)addCachedViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrames[index] CGRectValue];
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self willEnterController:viewController atIndex:index];
    [self.displayVC setObject:viewController forKey:@(index)];
}

// 添加子控制器
- (void)addViewControllerAtIndex:(int)index {
    UIViewController *viewController = [self initializeViewControllerAtIndex:index];
    if ([viewController isKindOfClass:WMTableViewController.class]) {
        ((WMTableViewController*)viewController).delegate = self;
    }
    
    if (self.values.count == self.childControllersCount && self.keys.count == self.childControllersCount) {
        [viewController setValue:self.values[index] forKey:self.keys[index]];
    }
    [self addChildViewController:viewController];
    CGRect frame = self.childViewFrames.count ? [self.childViewFrames[index] CGRectValue] : self.view.frame;
    viewController.view.frame = frame;
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self willEnterController:viewController atIndex:index];
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
        [self willCachedController:viewController atIndex:index];
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

#pragma mark - Adjust Frame
- (void)adjustScrollViewFrame {
    // While rotate at last page, set scroll frame will call `-scrollViewDidScroll:` delegate
    // It's not my expectation, so I use `_shouldNotScroll` to lock it.
    // Wait for a better solution.
    _shouldNotScroll = YES;
    CGRect scrollFrame = CGRectMake(_viewX, _viewY + self.menuHeight + self.menuViewBottom, _viewWidth, _viewHeight);
    scrollFrame.origin.y -= self.showOnNavigationBar && self.navigationController.navigationBar ? self.menuHeight : 0;
    self.scrollView.frame = scrollFrame;
    self.scrollView.contentSize = CGSizeMake(self.childControllersCount * _viewWidth, 0);
    [self.scrollView setContentOffset:CGPointMake(self.selectIndex * _viewWidth, 0)];
    _shouldNotScroll = NO;
}

- (void)adjustMenuViewFrame {
    // 根据是否在导航栏上展示调整frame
    CGFloat menuHeight = self.menuHeight;
    __block CGFloat menuX = _viewX;
    __block CGFloat rightWidth = 0;
    if (self.showOnNavigationBar && self.navigationController.navigationBar) {
        [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
            if (![obj isKindOfClass:[WMMenuView class]] && ![obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")] && obj.alpha != 0 && obj.hidden == NO) {
                CGFloat maxX = CGRectGetMaxX(obj.frame);
                if (maxX < _viewWidth / 2) {
                    CGFloat leftWidth = maxX + kWMMarginToNavigationItem;
                    menuX = menuX > leftWidth ? menuX : leftWidth;
                }
                CGFloat minX = CGRectGetMinX(obj.frame);
                if (minX > _viewWidth / 2) {
                    CGFloat width = (_viewWidth - minX) + kWMMarginToNavigationItem;
                    rightWidth = rightWidth > width ? rightWidth : width;
                }
            }
        }];
        CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
        menuHeight = self.menuHeight > navHeight ? navHeight : self.menuHeight;
    }
    CGFloat menuWidth = _viewWidth - menuX - rightWidth;
    self.menuView.frame = CGRectMake(menuX, _viewY, menuWidth, menuHeight);
    [self.menuView resetFrames];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = ColorTheme;
    //TabBarItem 设置
    UIImage* image=IMAGENAMED(@"btn_tourongzi_selected");
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setSelectedImage:image];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:AppColorTheme,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    //设置标题
    [self.navView setTitle:@"金指投"];
    NSArray* menuArray = @[@"项目库",@"投资人"];
    self.navView.delegate  = self;
    self.navView.menuArray  =[NSMutableArray arrayWithArray:menuArray];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:IMAGENAMED(@"home") forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction:)]];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction:)]];
    [self.navView.rightButton setImage:IMAGENAMED(@"sousuobai") forState:UIControlStateNormal];
    

    _titles = @[@"待融资",@"融资中",@"已融资",@"预选项目"];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < _titles.count; i++) {
        Class vcClass;
        vcClass = [WMTableViewController class];
        [viewControllers addObject:vcClass];
    }
    _viewControllerClasses = [NSArray arrayWithArray:viewControllers];
    NSParameterAssert(viewControllers.count == _titles.count);
    
    self.viewFrame = CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView));
    self.postNotification = YES;
    self.itemMargin = 1;
    self.menuHeight = 40;
    self.pageAnimatable = YES;
    self.titleSizeSelected = 16;
    self.titleSizeNormal = 14;
//    self.rememberLocation = YES;
//    self.otherGestureRecognizerSimultaneously=YES;
    self.menuBGColor = WriteColor;
    self.progressColor  = AppColorTheme;
    self.titleColorSelected = AppColorTheme;
    self.titleColorNormal = FONT_COLOR_GRAY;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.itemsWidths = @[@(70),@(70),@(70),@(70)]; // 这里可以设置不同的宽度
    
    
    self.title = @"投融资";
    
    if (!self.childControllersCount) return;
    
    [self addScrollView];
    
    [self addViewControllerAtIndex:self.selectIndex];
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    
    [self addMenuView];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewMessage:) name:@"updateMessageStatus" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInteractionEnabled:) name:@"userInteractionEnabled" object:nil];
    
    [self updateNewMessage:nil];
}

-(void)userInteractionEnabled:(NSDictionary*)dic

{
    
    BOOL isUserInteractionEnabled = [[[dic valueForKey:@"userInfo"] valueForKey:@"userInteractionEnabled"] boolValue];
    
    self.view.userInteractionEnabled = isUserInteractionEnabled;
    
}

/**
 *  消息提示
 *
 *  @param dic 通知数据
 */
-(void)updateNewMessage:(NSDictionary*)dic
{
    NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
    NSInteger newMessageCount = [[dataStore valueForKey:@"NewMessageCount"] integerValue];
    NSInteger systemMessageCount = [[dataStore valueForKey:@"SystemMessageCount"] integerValue];
    if (newMessageCount+systemMessageCount>0) {
        [self.navView setIsHasNewMessage:YES];
    }
    
}

-(void)userInfoAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil];
}


-(void)searchAction:(id)sender
{
    INSViewController* controller =[[INSViewController alloc]init];
    controller.title = self.navView.title;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!self.childControllersCount) return;
    
    CGFloat oldSuperviewHeight = _superviewHeight;
    _superviewHeight = self.view.frame.size.height;

    if (_hasInited && _superviewHeight == oldSuperviewHeight) return;

    // 计算宽高及子控制器的视图frame
    [self calculateSize];
    
    [self adjustScrollViewFrame];
    
    [self adjustMenuViewFrame];
    
    [self removeSuperfluousViewControllersIfNeeded];
    self.currentViewController.view.frame = [self.childViewFrames[self.selectIndex] CGRectValue];
    _hasInited = YES;
    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
    [self didEnterController:self.currentViewController atIndex:self.selectIndex];
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

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_shouldNotScroll) { return; }
    
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
    
    // fix scrollView.contentOffset.y -> (-20) unexpectedly.
    if (scrollView.contentOffset.y == 0) { return; }
    CGPoint contentOffset = scrollView.contentOffset;
    contentOffset.y = 0.0;
    scrollView.contentOffset = contentOffset;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _animate = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _selectIndex = (int)scrollView.contentOffset.x / _viewWidth;
    [self removeSuperfluousViewControllersIfNeeded];
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
    [self didEnterController:self.currentViewController atIndex:self.selectIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self removeSuperfluousViewControllersIfNeeded];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
    [self didEnterController:self.currentViewController atIndex:self.selectIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat rate = _targetX / _viewWidth;
        [self removeSuperfluousViewControllersIfNeeded];
        [self.menuView slideMenuAtProgress:rate];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    _targetX = targetContentOffset->x;
}

#pragma mark - WMMenuView Delegate
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    NSInteger gap = (NSInteger)labs(index - currentIndex);
    _selectIndex = (int)index;
    _animate = NO;
    CGPoint targetP = CGPointMake(_viewWidth*index, 0);
    
    [self.scrollView setContentOffset:targetP animated:gap > 1 ? NO : self.pageAnimatable];
    if (gap > 1 || !self.pageAnimatable) {
        // 由于不触发 -scrollViewDidScroll: 手动处理控制器
        UIViewController *currentViewController = self.displayVC[@(currentIndex)];
        // 最好判断一下，因为在做某个项目时，currentViewController = nil
        if (currentViewController) {
            [self removeViewController:currentViewController atIndex:currentIndex];
        }
        [self layoutChildViewControllers];
        self.currentViewController = self.displayVC[@(self.selectIndex)];
        [self postFullyDisplayedNotificationWithCurrentIndex:(int)index];
        [self didEnterController:self.currentViewController atIndex:currentIndex];
    }
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    if (self.itemsWidths.count == self.childControllersCount) {
        return [self.itemsWidths[index] floatValue];
    }
    return self.menuItemWidth;
}

- (CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index {
    if (self.itemsMargins.count == self.childControllersCount + 1) {
        return [self.itemsMargins[index] floatValue];
    }
    return self.itemMargin;
}

- (CGFloat)menuView:(WMMenuView *)menu titleSizeForState:(WMMenuItemState)state {
    switch (state) {
        case WMMenuItemStateSelected: {
            return self.titleSizeSelected;
            break;
        }
        case WMMenuItemStateNormal: {
            return self.titleSizeNormal;
            break;
        }
    }
}

- (UIColor *)menuView:(WMMenuView *)menu titleColorForState:(WMMenuItemState)state {
    switch (state) {
        case WMMenuItemStateSelected: {
            return self.titleColorSelected;
            break;
        }
        case WMMenuItemStateNormal: {
            return self.titleColorNormal;
            break;
        }
    }
}

#pragma mark - WMMenuViewDataSource
- (NSInteger)numbersOfTitlesInMenuView:(WMMenuView *)menu {
    return self.childControllersCount;
}

- (NSString *)menuView:(WMMenuView *)menu titleAtIndex:(NSInteger)index {
    return [self titleAtIndex:index];
}

#pragma navViewDelegate
-(void)navView:(id)navView tapIndex:(int)index
{
    if (self.menuSelectIndex!=index) {
        NSLog(@"点击:%d",index);
        self.menuSelectIndex = index;
        self.selectIndex = 0;
        NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
        switch (self.menuSelectIndex) {
            case 0:
                _titles = @[@"待融资",@"融资中",@"已融资",@"预选项目"];
                for (int i = 0; i < _titles.count; i++) {
                    Class vcClass;
                    vcClass = [WMTableViewController class];
                    [viewControllers addObject:vcClass];
                }
                _viewControllerClasses = [NSArray arrayWithArray:viewControllers];
                NSParameterAssert(viewControllers.count == _titles.count);
                self.itemsWidths=@[@(70),@(70),@(70),@(70)];
                self.navView.rightButton.alpha= 1 ;
                self.navView.rightTouchView.userInteractionEnabled = YES;
                break;
            case 1:
                _titles = @[@"个人投资人",@"机构投资人",@"智囊团"];
                for (int i = 0; i < _titles.count; i++) {
                    Class vcClass;
                    vcClass = [WMTableViewController class];
                    [viewControllers addObject:vcClass];
                }
                _viewControllerClasses = [NSArray arrayWithArray:viewControllers];
                NSParameterAssert(viewControllers.count == _titles.count);
                self.itemsWidths=@[@(100),@(100),@(100)];
                self.navView.rightButton.alpha = 0;
                self.navView.rightTouchView.userInteractionEnabled = NO;
                break;
            default:
                _titles = @[@"待融资",@"融资中",@"已融资",@"预选项目"];
                for (int i = 0; i < _titles.count; i++) {
                    Class vcClass;
                    vcClass = [WMTableViewController class];
                    [viewControllers addObject:vcClass];
                }
                _viewControllerClasses = [NSArray arrayWithArray:viewControllers];
                NSParameterAssert(viewControllers.count == _titles.count);
                self.itemsWidths=@[@(70),@(70),@(70),@(70)];
                self.navView.rightButton.alpha=1;
                self.navView.rightTouchView.userInteractionEnabled = YES;
                break;
        }
        
        [self reloadData];
        [self postFullyDisplayedNotificationWithCurrentIndex:0];
    }
}



#pragma WMTableViewController
- (void)wmTableViewController:(id)wmTableViewController tapIndexPath:(NSIndexPath *)indexPath atSelectedIndex:(int)selectedIndex data:(NSDictionary *)dic
{
    if (selectedIndex!=3) {
        RoadShowDetailViewController* controller = [[RoadShowDetailViewController alloc]init];
        
//        Project* project = [[Project alloc]init];
//        project = [[Project alloc]init];
//        project.imgUrl = [dic valueForKey:@"img"];
//        project.tag = [dic valueForKey:@"tag"];
//        project.company = [dic valueForKey:@"company"];
//        project.projectId = [[dic valueForKey:@"id"] integerValue];
//        project.invest = [NSString stringWithFormat:@"%@",[dic valueForKey:@"invest"]];
//        project.planfinance = [NSString stringWithFormat:@"%@",[dic valueForKey:@"planfinance"]];
        
        controller.dic = dic;
        controller.type=1;
        controller.title = self.navView.title;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        //预选项目
        PreProjectDetailViewController* controller = [[PreProjectDetailViewController alloc]init];
        
        Project* project = [[Project alloc]init];
        project = [[Project alloc]init];
        project.imgUrl = [dic valueForKey:@"img"];
        project.projectId = [[dic valueForKey:@"id"] integerValue];
        
        controller.project = project;
        controller.type=0;
        controller.title = self.navView.title;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

-(void)wmTableViewController:(id)wmTableViewController thinkTankDetailData:(NSDictionary *)dic
{
    ThinkTankViewController* controller = [[ThinkTankViewController alloc]init];
    controller.dic = dic;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)wmTableViewController:(id)wmTableViewController personalFincance:(NSDictionary *)dic
{
    PersonalFinanceViewController* controller = [[PersonalFinanceViewController alloc]init];
    controller.dic = dic;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)wmTableViewController:(id)wmTableViewController comFincance:(NSDictionary *)dic
{
    ComFinanceViewController* controller = [[ComFinanceViewController alloc]init];
    controller.dic = dic;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)wmTableViewController:(id)wmTableViewController refresh:(id)sender
{
    
}

-(void)wmTableViewController:(id)wmTableViewController loadMore:(id)sender
{
    
}
-(void)wmTableViewController:(id)wmTableViewController playMedia:(BOOL)playMedia data:(NSDictionary *)dic
{
//    [self playMedia:[dic valueForKey:@"vcr"]];
}
@end
