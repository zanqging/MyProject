//
//  WMPageController.m
//  WMPageController
//
//  Created by Mark on 15/6/11.
//  Copyright (c) 2015年 yq. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WMPageConst.h"
#import "WMPageController_bak.h"
#import "INSViewController.h"
#import "movieViewController.h"
#import "WMTableViewController.h"
#import "ThinkTankViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RoadShowDetailViewController.h"
@interface WMPageController_bak () <WMMenuViewDelegate,UIScrollViewDelegate,navViewDelegate,WMtableViewCellDelegate> {
    CGFloat _viewHeight;
    CGFloat _viewWidth;
    CGFloat _viewX;
    CGFloat _viewY;
    CGFloat _targetX;
    BOOL    _animate;
    BOOL isRefresh;
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
@property (nonatomic,strong) movieViewController * moviePlayer;//视频播放控制器
@property(retain,nonatomic)NSMutableArray* financingData; //融资中缓存数据
@property(retain,nonatomic)NSMutableArray* waitFinanceData; //待融资缓存数据
@property(retain,nonatomic)NSMutableArray* financedData; //已融资缓存数据
@property(retain,nonatomic)NSMutableArray* projectData; //预选项目缓存数据

@property(retain,nonatomic)NSMutableArray* personData; //个人投资人缓存数据
@property(retain,nonatomic)NSMutableArray* comData; //机构投资人缓存数据
@property(retain,nonatomic)NSMutableArray* thinkTankData; //智囊团缓存数据
@end

@implementation WMPageController_bak
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景颜色
    self.view.backgroundColor=ColorTheme;
    
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
    [self.navView.leftButton setImage:IMAGENAMED(@"shuruphone") forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction:)]];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction:)]];
    [self.navView.rightButton setImage:IMAGENAMED(@"sousuobai") forState:UIControlStateNormal];
    
    
    NSArray *viewControllers = @[[WMTableViewController class]];
    NSArray *titles = @[@"待融资",@"融资中", @"已融资", @"预选项目"];
    
    _viewControllerClasses = [NSArray arrayWithArray:viewControllers];
    _titles = [NSArray arrayWithArray:titles];
    
    [self setup];
    
    self.itemMargin = 1;
    self.menuHeight = 40;
    self.pageAnimatable = YES;
    self.titleSizeSelected = 16;
    self.titleSizeNormal = 14;
    self.menuBGColor = WriteColor;
    self.progressColor  = AppColorTheme;
    self.titleColorSelected = AppColorTheme;
    self.titleColorNormal = FONT_COLOR_GRAY;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.itemsWidths = @[@(70),@(70),@(70),@(70)]; // 这里可以设置不同的宽度
    
    
    self.title = @"投融资";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self addScrollView];
    
    [self addViewControllerAtIndex:self.selectIndex];
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    
    [self setViewFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-110)];
    self.loadingViewFrame = CGRectMake(0, POS_Y(self.navView)+self.menuHeight, WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView)-self.menuHeight-kBottomBarHeight);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewMessage:) name:@"updateMessageStatus" object:nil];
    
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //加载数据
    [self loadData];
    
    isRefresh =YES;
    self.currentPage=0;
}

-(void)loadData
{
    [self updateNewMessage:nil];
    [self refresh];
}


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
    if (isRefresh) {
        self.isTransparent = NO;
        switch (self.menuSelectIndex) {
            case 0:
                [self refresh];
                break;
            case 1:
                [self finialCommicuteList];
                break;
            default:
                [self refresh];
                break;
        }
    }
    
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
    scrollView.bounces  =NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.bounces = self.bounces;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

//- (void)addMenuView {
//    if (self.titles.count>0) {
//        CGRect frame = CGRectMake(_viewX, _viewY, _viewWidth, self.menuHeight);
//        WMMenuView *menuView = [[WMMenuView alloc] initWithFrame:frame buttonItems:self.titles backgroundColor:self.menuBGColor norSize:self.titleSizeNormal selSize:self.titleSizeSelected norColor:self.titleColorNormal selColor:self.titleColorSelected];
//        menuView.delegate = self;
//        menuView.style = self.menuViewStyle;
//        menuView.progressHeight = self.progressHeight;
//        if (self.titleFontName) {
//            menuView.fontName = self.titleFontName;
//        }
//        if (self.progressColor) {
//            menuView.lineColor = self.progressColor;
//        }
//        [self.view addSubview:menuView];
//        self.menuView = menuView;
//        // 如果设置了初始选择的序号，那么选中该item
//        if (self.selectIndex != 0) {
//            [self.menuView selectItemAtIndex:self.selectIndex];
//        }
//        self.loadingViewFrame = CGRectMake(0, POS_Y(self.menuView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.menuView));
//    }else{
//        self.loadingViewFrame = CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view));
//    }
//    
//    
//    
//}


- (void)layoutChildViewControllers {
    int currentPage = fabs(self.scrollView.contentOffset.x / _viewWidth);
    int start = currentPage == 0 ? currentPage : (currentPage - 1);
    int end;
    if ( self.titles.count!=0) {
        end = (currentPage == self.titles.count - 1) ? currentPage : (currentPage + 1);
    }else{
        end=0;
    }
    for (int i = start; i <= end; i++) {

        CGRect frame;
        frame = [self.childViewFrames[i] CGRectValue];
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
//    [self addMenuView];
    [oldMenuView removeFromSuperview];
}

- (void)growCachePolicyAfterMemoryWarning {
    self.cachePolicy = WMPageControllerCachePolicyBalanced;
    [self performSelector:@selector(growCachePolicyToHigh) withObject:nil afterDelay:2.0 inModes:@[NSRunLoopCommonModes]];
}

- (void)growCachePolicyToHigh {
    self.cachePolicy = WMPageControllerCachePolicyHigh;
}

/**
 *  屏幕旋转
 */
-(void)onDeviceOrientationChange
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    CGRect frame1;
    CGRect frame2;
    if (isiPhone4) {
        frame1 = CGRectMake(-kTopBarHeight-kStatusBarHeight-16, kTopBarHeight+kStatusBarHeight+16, HEIGHT(self.view), WIDTH(self.view));
        frame2 = CGRectMake(0,0,WIDTH(self.view),HEIGHT(self.view));
    }else if (isiPhone5){
        frame1 = CGRectMake(-kTopBarHeight-kStatusBarHeight-60, kTopBarHeight+kStatusBarHeight+60, HEIGHT(self.view), WIDTH(self.view));
        frame2 = CGRectMake(0,0,WIDTH(self.view),HEIGHT(self.view));
    }else if (isiPhone6){
        frame1 = CGRectMake(-kTopBarHeight-kStatusBarHeight-60, kTopBarHeight+kStatusBarHeight+60, HEIGHT(self.view), WIDTH(self.view));
        frame2 = CGRectMake(0,0,WIDTH(self.view),HEIGHT(self.view));
    }else if (isiPhone6P){
        frame1 = CGRectMake(-kTopBarHeight-kStatusBarHeight-60, kTopBarHeight+kStatusBarHeight+60, HEIGHT(self.view), WIDTH(self.view));
        frame2 = CGRectMake(0,0,WIDTH(self.view),HEIGHT(self.view));    }
    
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        [_moviePlayer.view setFrame:frame1];
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(- M_PI_2);
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
    }
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        [_moviePlayer.view setFrame:frame1];
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
    }
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        [_moviePlayer.view setFrame:frame1];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(0);
    }
    
    if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        [_moviePlayer.view setFrame:frame2];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2*2);
    }
    
    
    if (orientation == UIInterfaceOrientationUnknown) {
        [_moviePlayer.view setFrame:frame2];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2*2);
    }
    
    if (orientation == UIInterfaceOrientationPortrait) {
        [_moviePlayer.view setFrame:frame2];
        _moviePlayer.moviePlayer.controlStyle  =MPMovieControlStyleFullscreen;
        _moviePlayer.view.transform = CGAffineTransformMakeRotation(0);
    }
    
    
}
-(void)playMedia:(NSString*)urlStr
{
    
    NSString* str = urlStr;
    if (str && ![str isEqualToString:@""]) {
        NSURL* url = [NSURL URLWithString:str];
        _moviePlayer = [[movieViewController alloc]init];
        [_moviePlayer.moviePlayer setContentURL:url];
        [_moviePlayer.moviePlayer prepareToPlay];
        [self presentMoviePlayerViewControllerAnimated:_moviePlayer];
        
        //        [self.moviePlayer.moviePlayer setContentURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"mp4"]]];
        self.moviePlayer.moviePlayer.fullscreen = YES;
        self.moviePlayer.moviePlayer.controlStyle =MPMovieControlStyleFullscreen;
        [self.moviePlayer.moviePlayer play];
    }
}

-(void)updateNewMessage:(NSDictionary*)dic
{
    NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
    NSInteger newMessageCount = [[dataStore valueForKey:@"NewMessageCount"] integerValue];
    NSInteger systemMessageCount = [[dataStore valueForKey:@"SystemMessageCount"] integerValue];
    if (newMessageCount+systemMessageCount>0) {
        [self.navView setIsHasNewMessage:YES];
    }else{
        [self.navView setIsHasNewMessage:NO];
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

-(void)refresh
{
    if (self.menuSelectIndex==0) {
        //网络请求
        self.startLoading  =YES;
        NSString* srverUrl = [NSString stringWithFormat:@"project/%d/%ld/",self.selectIndex+1,self.currentPage];
        [self.httpUtil getDataFromAPIWithOps:srverUrl  type:0 delegate:self sel:@selector(requestFinished:) method:@"GET"];        
    }else{
        self.startLoading = YES;
        switch (self.selectIndex) {
            case 2:
                [self thinkTank];
            default:
                [self finialCommicuteList];
                break;
        }
    }
}

-(void)thinkTank
{
    if (self.menuSelectIndex==1) {
        //网络请求
        self.startLoading  =YES;
        NSString* srverUrl = [THINKTANK stringByAppendingFormat:@"%ld/",self.currentPage];
        [self.httpUtil getDataFromAPIWithOps:srverUrl  type:0 delegate:self sel:@selector(requestFinished:) method:@"GET"];
    }
}


-(void)finialCommicuteList
{
    if (self.menuSelectIndex==1) {
        //网络请求
        self.startLoading  =YES;
        
        if (self.selectIndex<2) {
            NSString* srverUrl = [FINIAL_COMM stringByAppendingFormat:@"%d/%ld/",self.selectIndex+1,self.currentPage];
            [self.httpUtil getDataFromAPIWithOps:srverUrl  type:0 delegate:self sel:@selector(requestFinished:) method:@"GET"];
        }else{
            [self thinkTank];
        }
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 计算宽高及子控制器的视图frame
    [self calculateSize];
    CGRect scrollFrame;
    if (self.titles.count>0) {
        scrollFrame = CGRectMake(_viewX, _viewY + self.menuHeight, _viewWidth, _viewHeight);
    }else{
        scrollFrame = CGRectMake(_viewX, _viewY, _viewWidth, _viewHeight+self.menuHeight);
    }
    self.scrollView.frame = scrollFrame;
    if (self.titles.count>0) {
        self.scrollView.contentSize = CGSizeMake(self.titles.count*_viewWidth, _viewHeight-self.menuHeight);
    }else{
        self.scrollView.contentSize = CGSizeMake(_viewWidth, _viewHeight);
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
//-(void)navView:(id)navView tapIndex:(int)index
//{
//    if (self.menuSelectIndex!=index) {
//        NSLog(@"点击:%d",index);
//        isRefresh  =YES;
//        self.menuSelectIndex = index;
//        self.selectIndex = 0;
//        switch (self.menuSelectIndex) {
//            case 0:
//                _titles  =@[@"待融资",@"融资中", @"已融资", @"预选项目"];
//                self.itemsWidths =  @[@(70),@(70),@(70),@(70)];
//                self.menuView.items = _titles;
//                [self resetMenuView];
//                break;
//            case 1:
//                _titles  =@[@"个人投资人",@"机构投资人",@"智囊团"];
//                self.itemsWidths = @[@(100),@(100),@(100)]; // 这里可以设置不同的宽度
//                self.menuView.items = _titles;
//                [self resetMenuView];
//                break;
//            default:
//                break;
//        }
//    }
//}
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
    
    CGPoint point =scrollView.contentOffset;
    if (point.x<0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _animate = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _selectIndex = (int)scrollView.contentOffset.x / _viewWidth;
    if (self.menuSelectIndex==0) {
        isRefresh = NO;
        switch (self.selectIndex) {
            case 0:
                if (!self.waitFinanceData || self.waitFinanceData.count==0) {
                    isRefresh = YES;
                }
                break;
            case 1:
                if (!self.financingData || self.financingData.count==0) {
                    isRefresh = YES;
                }
                break;
            case 2:
                if (!self.financedData || self.financedData.count==0) {
                    isRefresh = YES;
                }
                break;
            case 3:
                if (!self.projectData || self.projectData.count==0) {
                    isRefresh = YES;
                }
                break;
                
            default:
                break;
        }
    }else{
        switch (self.selectIndex) {
            case 0:
                if (!self.personData || self.personData.count==0) {
                    isRefresh = YES;
                }
                break;
            case 1:
                if (!self.comData || self.comData.count==0) {
                    isRefresh = YES;
                }
                break;
            case 2:
                if (!self.thinkTankData || self.thinkTankData.count==0) {
                    isRefresh = YES;
                }
                break;
            default:
                break;
        }
    }
    
    if (isRefresh) {
        self.currentPage=0;
        if (self.menuSelectIndex==0) {
            [self refresh];
        }else{
            switch (self.selectIndex) {
                case 0:
                    [self finialCommicuteList];
                    break;
                case 1:
                    [self thinkTank];
                    break;
                default:
                    break;
            }
        }
        
        
        isRefresh = YES;
        self.currentPage=0;
        self.isTransparent = YES;
    }
    
    
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
    CGPoint point =scrollView.contentOffset;
    if (point.x<0) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
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
    controller.dic = dic;
    controller.type=1;
    controller.title = self.navView.title;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)wmTableViewController:(id)wmTableViewController thinkTankDetailData:(NSDictionary *)dic
{
    ThinkTankViewController* controller = [[ThinkTankViewController alloc]init];
    controller.dic = dic;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)wmTableViewController:(id)wmTableViewController refresh:(id)sender
{
    isRefresh = YES;
    self.currentPage=0;
    switch (self.menuSelectIndex) {
        case 0:
            [self refresh];
            break;
        case 1:
            [self finialCommicuteList];
            break;
        default:
            break;
    }
    self.startLoading = NO;
}

-(void)wmTableViewController:(id)wmTableViewController loadMore:(id)sender
{
    isRefresh = NO;
    self.currentPage++;
    switch (self.menuSelectIndex) {
        case 0:
            [self refresh];
            break;
        case 1:
            [self finialCommicuteList];
            break;
        default:
            break;
    }
    self.startLoading = NO;
}
-(void)wmTableViewController:(id)wmTableViewController playMedia:(BOOL)playMedia data:(NSDictionary *)dic
{
    [self playMedia:[dic valueForKey:@"vcr"]];
}
#pragma mark - WMMenuView Delegate
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    NSInteger gap = (NSInteger)labs(index - currentIndex);
    if (_selectIndex != (int)index) {
//        _selectIndex = (int)index;
        isRefresh = NO;
        if (self.menuSelectIndex==0) {
            switch ((int)index) {
                case 0:
                    if (!self.waitFinanceData || self.waitFinanceData.count==0) {
                        isRefresh = YES;
                    }
                    break;
                case 1:
                    if (!self.financingData || self.financingData.count==0) {
                        isRefresh = YES;
                    }
                    break;
                case 2:
                    if (!self.financedData || self.financedData.count==0) {
                        isRefresh = YES;
                    }
                    break;
                case 3:
                    if (!self.projectData || self.projectData.count==0) {
                        isRefresh = YES;
                    }
                    break;
                    
                default:
                    break;
            }
        }else{
            switch ((int)index) {
                case 0:
                    if (!self.personData || self.personData.count==0) {
                        isRefresh = YES;
                    }
                    break;
                case 1:
                    if (!self.comData || self.comData.count==0) {
                        isRefresh = YES;
                    }
                    break;
                case 2:
                    if (!self.thinkTankData || self.thinkTankData.count==0) {
                        isRefresh = YES;
                    }
                    break;
                default:
                    break;
            }
        }
        self.currentPage=0;
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

//项目库
-(void)setProjectData:(NSMutableArray *)projectData
{
    if (projectData) {
        self->_projectData = projectData;
    }
    
    if (isRefresh) {
        self.currentViewController.dataArray = self.projectData;
    }else{
        NSMutableArray* array = self.currentViewController.dataArray;
        [array addObjectsFromArray:self.projectData];
        self.currentViewController.dataArray  =array;
    }
    self.currentViewController.selectIndex = self.selectIndex;
    self.currentViewController.menuSelectIndex = self.menuSelectIndex;
    if (!self.currentViewController.delegate) {
        self.currentViewController.delegate  = self;
    }
}
-(void)setWaitFinanceData:(NSMutableArray *)waitFinanceData
{
    if (waitFinanceData) {
        self->_waitFinanceData = waitFinanceData;
    }
    
    if (isRefresh) {
        self.currentViewController.dataArray = self.waitFinanceData;
    }else{
        NSMutableArray* array = self.currentViewController.dataArray;
        [array addObjectsFromArray:self.waitFinanceData];
        self.currentViewController.dataArray  =array;
    }
    self.currentViewController.selectIndex = self.selectIndex;
    self.currentViewController.menuSelectIndex = self.menuSelectIndex;
    if (!self.currentViewController.delegate) {
        self.currentViewController.delegate  = self;
    }
}
-(void)setFinancingData:(NSMutableArray *)financingData
{
    if (financingData) {
        self->_financingData = financingData;
    }
    
    if (isRefresh) {
        self.currentViewController.dataArray = self.financingData;
    }else{
        NSMutableArray* array = self.currentViewController.dataArray;
        [array addObjectsFromArray:self.financingData];
        self.currentViewController.dataArray  =array;
    }
    self.currentViewController.selectIndex = self.selectIndex;
    self.currentViewController.menuSelectIndex = self.menuSelectIndex;
    if (!self.currentViewController.delegate) {
        self.currentViewController.delegate  = self;
    }
}

-(void)setFinancedData:(NSMutableArray *)financedData
{
    if (financedData) {
        self->_financedData = financedData;
    }
    
    if (isRefresh) {
        self.currentViewController.dataArray = self.financedData;
    }else{
        NSMutableArray* array = self.currentViewController.dataArray;
        [array addObjectsFromArray:self.financedData];
        self.currentViewController.dataArray  =array;
    }
    self.currentViewController.selectIndex = self.selectIndex;
    self.currentViewController.menuSelectIndex = self.menuSelectIndex;
    if (!self.currentViewController.delegate) {
        self.currentViewController.delegate  = self;
    }
}

//投资人
-(void)setPersonData:(NSMutableArray *)personData
{
    if (personData) {
        self->_personData = personData;
    }
    
    if (isRefresh) {
        self.currentViewController.dataArray = self.personData;
    }else{
        NSMutableArray* array = self.currentViewController.dataArray;
        [array addObjectsFromArray:self.personData];
        self.currentViewController.dataArray  =array;
    }
    self.currentViewController.selectIndex = self.selectIndex;
    self.currentViewController.menuSelectIndex = self.menuSelectIndex;
    if (!self.currentViewController.delegate) {
        self.currentViewController.delegate  = self;
    }
}

-(void)setComData:(NSMutableArray *)comData
{
    if (comData) {
        self->_comData = comData;
    }
    
    if (isRefresh) {
        self.currentViewController.dataArray = self.comData;
    }else{
        NSMutableArray* array = self.currentViewController.dataArray;
        [array addObjectsFromArray:self.comData];
        self.currentViewController.dataArray  =array;
    }
    self.currentViewController.selectIndex = self.selectIndex;
    self.currentViewController.menuSelectIndex = self.menuSelectIndex;
    if (!self.currentViewController.delegate) {
        self.currentViewController.delegate  = self;
    }
}
-(void)setThinkTankData:(NSMutableArray *)thinkTankData
{
    if (thinkTankData) {
        self->_thinkTankData = thinkTankData;
    }
    
    if (isRefresh) {
        self.currentViewController.dataArray = self.thinkTankData;
    }else{
        NSMutableArray* array = self.currentViewController.dataArray;
        [array addObjectsFromArray:self.thinkTankData];
        self.currentViewController.dataArray  =array;
    }
    self.currentViewController.selectIndex = self.selectIndex;
    self.currentViewController.menuSelectIndex = self.menuSelectIndex;
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
        if (self.menuSelectIndex==0) {
            switch (self.selectIndex) {
                case 0:
                    self.waitFinanceData = [jsonDic valueForKey:@"data"];
                    break;
                case 1:
                    self.financingData = [jsonDic valueForKey:@"data"];
                    break;
                case 2:
                    self.financedData = [jsonDic valueForKey:@"data"];
                    break;
                case 3:
                    self.projectData = [jsonDic valueForKey:@"data"];
                    break;
                default:
                    self.waitFinanceData = [jsonDic valueForKey:@"data"];
                    break;
            }
        }else{
            switch (self.selectIndex) {
                case 0:
                    self.personData = [jsonDic valueForKey:@"data"];
                    break;
                case 1:
                    self.comData = [jsonDic valueForKey:@"data"];
                    break;
                case 2:
                    self.thinkTankData = [jsonDic valueForKey:@"data"];
                    break;
                default:
                    self.personData = [jsonDic valueForKey:@"data"];
                    break;
            }
        }
        if (self.currentPage>0) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        }
        
        self.startLoading  =NO;
    }else{
        self.isNetRequestError = YES;
    }
    if (isRefresh) {
        [self.currentViewController.tableView.header endRefreshing];
    }else{
        [self.currentViewController.tableView.footer endRefreshing];
    }
}

@end
