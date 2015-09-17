//
//  WaterF.m
//  CollectionView
//
//  Created by d2space on 14-2-21.
//  Copyright (c) 2014年 D2space. All rights reserved.
//

#import "WaterF.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "WaterFCell.h"
#import "DialogUtil.h"
#import "DialogView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "WaterFallHeader.h"
#import "WaterFallFooter.h"
#import "ASIHTTPRequest.h"
#import "UIImageView+WebCache.h"
#import "MJRefreshBackNormalFooter.h"
#import "RoadShowDetailViewController.h"

@interface WaterF ()<ASIHTTPRequestDelegate>
{
    BOOL isRefresh;
    HttpUtils* httpUtils;
    NSInteger currentPage;
    NSMutableArray* dataArray;
}

@property (nonatomic, strong) WaterFCell* cell;
/** 存放假数据 */
@property (strong, nonatomic) NSMutableArray *colors;
@end

@implementation WaterF

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        httpUtils = [[HttpUtils alloc]init];
        dataArray =[[NSMutableArray alloc]init];
        self.textsArr = [[NSMutableArray alloc]init];
        self.imagesArr = [[NSMutableArray alloc]init];
        
        
        isRefresh = YES;
        //当前页
        currentPage = -1;
        
        self.collectionView.backgroundColor=BackColor;
        [self.collectionView registerClass:[WaterFCell class] forCellWithReuseIdentifier:@"cell"];
        [self.collectionView registerClass:[WaterFallFooter class]  forSupplementaryViewOfKind:WaterFallSectionFooter withReuseIdentifier:@"WaterFallSectionfooter"];
        [self.collectionView registerClass:[WaterFallHeader class]  forSupplementaryViewOfKind:WaterFallSectionHeader withReuseIdentifier:@"WaterFallSectionHeader"];
        
        NSMutableArray* imgArrays =[[NSMutableArray alloc]init];
        NSString* fileName=@"";
        UIImage* image;
        for (int i = 0; i<7; i++) {
            fileName = [NSString stringWithFormat:@"person%d",i+1];
            image = IMAGENAMED(fileName);
            [imgArrays addObject:image];
        }
        
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshProject)];
        // 设置普通状态的动画图片
        [header setImages:imgArrays forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [header setImages:imgArrays forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [header setImages:imgArrays forState:MJRefreshStateRefreshing];
        
        
        self.collectionView.header = header;
        
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadProject)];
        // 设置普通状态的动画图片
        [footer setImages:imgArrays forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [footer setImages:imgArrays forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [footer setImages:imgArrays forState:MJRefreshStateRefreshing];
        // 上拉刷新
        self.collectionView.footer = footer;
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //加载数据源
    [self loadProject];
    
}

-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    NSString * url = [PROJECT_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
    [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestProjectList:)];
}

-(void)loadProject
{
    isRefresh =NO;
    if (!self.isEndOfPageSize) {
        currentPage++;
        NSString * url = [PROJECT_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
        [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestProjectList:)];
    }else{
        if ([_delegate respondsToSelector:@selector(loadFinished)]) {
            [_delegate loadFinished];
        }
        [self.collectionView.footer endRefreshing];
        isRefresh =NO;
    }
}

#pragma mark UICollectionViewDataSource
//required
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionNum;
}

/* For now, we won't return any sections */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    CGFloat aFloat = 0;
    UIImageView* imageView = self.imagesArr[indexPath.item];
    aFloat = self.imagewidth/imageView.image.size.width;
    self.cell.imageView.frame = CGRectMake(0, 0, self.imagewidth,  imageView.image.size.height*aFloat) ;
   //状态
    NSDictionary* dic =dataArray[indexPath.item];

    NSInteger colorHex = [[dic valueForKey:@"color"] integerValue];
    NSString* hexNumber = [TDUtil ToHex:colorHex];
    UIColor* color = [TDUtil colorWithHexString:hexNumber];
    self.cell.tinColor = color;
    self.cell.title = [dic valueForKey:@"stage"];
    //获取文字高度
    [self getTextViewHeight:indexPath];
    self.cell.lblProjectName.frame = CGRectMake(10, imageView.image.size.height*aFloat+15, self.imagewidth, 21);

    //设置图片
    self.cell.imageView.image = imageView.image;
    self.cell.lblProjectName.text = self.textsArr[indexPath.item];
    
    //底部标签
    CGRect  frame=self.cell.lblProjectName.frame;
    self.cell.lblRoadShowTime.frame = CGRectMake(10, frame.size.height+frame.origin.y, self.imagewidth, 21);
    self.cell.lblRoadShowTime.text =[NSString stringWithFormat:@"路演时间:%@",self.datesArr[indexPath.item]];

    return self.cell;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //select Item
    //NSLog(@"row= %i,section = %i",indexPath.item,indexPath.section);
    NSMutableDictionary* dic =dataArray[indexPath.item];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RoadShowProject" object:nil userInfo:[NSDictionary dictionaryWithObject:dic forKey:@"data"]];
}

-(void)cancel:(id)sender
{
    UIView* view = [self.view viewWithTag:10001];
    [view removeFromSuperview];
}

-(void)shure:(id)sender
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"AuthConfig"];
    [self.navigationController pushViewController:controller animated:YES];
    
    [self cancel:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imagesArr && self.imagesArr.count>0) {
        CGFloat aFloat = 0;
        UIImageView* imageView = self.imagesArr[indexPath.item];
        aFloat = self.imagewidth/imageView.image.size.width;
        CGSize size = CGSizeMake(0,0);
        [self getTextViewHeight:indexPath];
        size = CGSizeMake(self.imagewidth, imageView.image.size.height*aFloat+60);
        return size;
    }else{
        return CGSizeZero;
    }
    
}

- (CGFloat)getTextViewHeight:(NSIndexPath*)indexPath
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.textsArr[indexPath.item]];
    UITextView* textViewTemple = [[UITextView alloc]init];
    textViewTemple.attributedText = attrStr;
    textViewTemple.text = self.textsArr[indexPath.item];
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];   // 获取该段attributedString的属性字典
    // 计算文本的大小  ios7.0
    CGSize textSize = [textViewTemple.text boundingRectWithSize:CGSizeMake(self.imagewidth, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                                     attributes:dic        // 文字的属性
                                                        context:nil].size;
    self.textViewHeight = textSize.height;
    return self.textViewHeight;
}

#pragma mark ADD Header AND Footer
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return self.headerView.frame.size.height;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:WaterFallSectionHeader])
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:@"WaterFallSectionHeader"
                                                                 forIndexPath:indexPath];
        [reusableView addSubview:self.headerView];
    }
    else if ([kind isEqualToString:WaterFallSectionFooter])
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:@"WaterFallSectionfooter"
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

#pragma ASIHttpRequester
//===========================================================网络请求=====================================
-(void)requestProjectList:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            NSMutableArray* array=[jsonDic valueForKey:@"data"];
            if (array.count>0) {
                NSMutableArray* arrayData = [[NSMutableArray alloc]init];
                NSMutableDictionary* dic;
                NSDictionary* dictionary;
                for (int i = 0; i<array.count; i++) {
                    dic =[[NSMutableDictionary alloc]init];
                    dictionary = array[i];
                    [dic setValue:[dictionary valueForKey:@"id"] forKey:@"id"];
                    [dic setValue:[dictionary valueForKey:@"color"] forKey:@"color"];
                    [dic setValue:[dictionary valueForKey:@"stage"] forKey:@"stage"];
                    [dic setValue:[dictionary valueForKey:@"project_img"] forKey:@"project_img"];
                    [dic setValue:[dictionary valueForKey:@"thumbnail"] forKey:@"thumbnail"];
                    [dic setValue:[dictionary valueForKey:@"company_name"] forKey:@"company_name"];
                    [dic setValue:[dictionary valueForKey:@"roadshow_start_datetime"] forKey:@"roadshow_start_datetime"];
                    [arrayData addObject:dic];
                }
                
                if (isRefresh) {
                    dataArray = arrayData;
                }else{
                    for (int i=0; i<arrayData.count; i++) {
                        [dataArray addObject:arrayData[i]];
                    }
                }
                if (dataArray && dataArray.count>0) {
                    NSDictionary* dic;
                    NSMutableArray* textArray=[NSMutableArray new];
                    NSMutableArray* imageArray = [NSMutableArray new];
                    NSMutableArray* dateArray = [NSMutableArray new];
                    for (int i =0; i<dataArray.count; i++) {
                        dic = dataArray[i];
                        [textArray addObject:[dic valueForKey:@"company_name"]];
                        [dateArray addObject:[dic valueForKey:@"roadshow_start_datetime"]];
                        
                        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(self.view)-20, 150)];
                        NSURL* url = [NSURL URLWithString:[dic valueForKey:@"thumbnail"]];
                        [imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"loading") completed:^(UIImage * image,NSError* error,SDImageCacheType cacheType,NSURL* imageUrl){
                            [self.collectionView reloadData];
                        }];
                        [imageArray addObject:imgView];
                    }
                    
                    self.textsArr = textArray;
                    self.datesArr = dateArray;
                    self.imagesArr  =imageArray;
                    [self.collectionView reloadData];
                    if ([_delegate respondsToSelector:@selector(loadFinished)]) {
                        [_delegate loadFinished];
                    }
                }
            }else{
                self.isEndOfPageSize = YES;
                if ([_delegate respondsToSelector:@selector(loadFinished)]) {
                    [_delegate loadFinished];
                }
                [self.collectionView.footer endRefreshing];
            }
        }else{
            NSLog(@"列表获取失败!");
        }
        if (isRefresh) {
            self.isEndOfPageSize = NO;
            [self.collectionView.header endRefreshing];
        }else{
            [self.collectionView.footer endRefreshing];
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
