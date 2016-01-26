//
//  DemoVC9.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * 持续更新地址: https://github.com/gsdios/SDAutoLayout                              *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************

 */

#import "CycleViewController.h"
#import "Pic.h"
#import "Cycle.h"
#import "Likers.h"
#import "Comment.h"
#import "MJRefresh.h"
#import "Demo9Model.h"
#import "DemoVC9Cell.h"
#import "CycleHeader.h"
#import "DAKeyboardControl.h"
#import "DemoVC9HeaderView.h"
#import "ShareTableViewCell.h"
#import "BannerViewController.h"
#import "PECropViewController.h"
#import "UIView+SDAutoLayout.h"
#import "PublishViewController.h"
#import "UserLookForViewController.h"
#import "ActionDetailViewController.h"
#import "CustomImagePickerController.h"
#import "UITableView+SDAutoTableViewCellHeight.h"

#define kDemoVC9CellId @"demovc9cell"
#define  TEXT_VIEW_HEIGHT  30
@interface CycleViewController ()<UITableViewDataSource,UITableViewDelegate,WeiboTableViewCellDelegate,UITextViewDelegate,CustomImagePickerControllerDelegate>

@property(retain,nonatomic)UIToolbar *toolBar;
@property (nonatomic, strong) NSMutableArray *modelsArray;
@property (nonatomic, strong) CustomImagePickerController* customPicker;

@end

@implementation CycleViewController
{
    CycleHeader* headerView;
    float toolBarHeight;
    float keyboardhight;
    
    UIButton *sendButton;
    UITextView *textView;
    NSInteger currentPage;
    NSString* replyContent;
    NSString* conId,* atConId;
    
    DemoVC9Cell* currentSelectedCell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    
    //==============================TabBarItem 设置==============================//
    UIImage* image=IMAGENAMED(@"btn-quanzi-cheng");
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setSelectedImage:image];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:AppColorTheme,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    //==============================TabBarItem 设置==============================//
    
    //==============================导航栏区域 设置==============================//
    [self.navView setTitle:@"金指投"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:IMAGENAMED(@"home") forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction:)]];
    
    [self.navView.rightButton setImage:IMAGENAMED(@"circle_publish") forState:UIControlStateNormal];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publishAction:)]];
    //==============================导航栏区域 设置==============================//
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView)-kBottomBarHeight-87)];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    [TDUtil tableView:self.tableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    //头部
    headerView = [[CycleHeader alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 200)];
    headerView.headerBackView.userInteractionEnabled = YES;
    headerView.headerView.userInteractionEnabled  =YES;
    [headerView.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UserInfoSetting:)]];
    [headerView.headerBackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takePhoto:)]];
    [self.tableView setTableHeaderView:headerView];
    
//    DemoVC9HeaderView *headerView = [DemoVC9HeaderView new];
//    headerView.frame = CGRectMake(0, 0, 0, 260);
//    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerClass:[DemoVC9Cell class] forCellReuseIdentifier:kDemoVC9CellId];
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                               self.view.bounds.size.height,
                                                               self.view.bounds.size.width,
                                                               40.0f)];
    self.toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.toolBar];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f,
                                                            6.0f,
                                                            self.toolBar.bounds.size.width - 20.0f - 68.0f,
                                                            TEXT_VIEW_HEIGHT)];
    textView.returnKeyType =UIReturnKeyDone;
    textView.layer.cornerRadius = 5;
    textView.layer.borderWidth = 1;
    textView.font = SYSTEMFONT(16);
    textView.delegate  =self;
    textView.layer.borderColor = FONT_COLOR_GRAY.CGColor;
    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.toolBar addSubview:textView];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [sendButton setTitle:@"回复" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    sendButton.frame = CGRectMake(self.toolBar.bounds.size.width - 68.0f,
                                  6.0f,
                                  58.0f,
                                  29.0f);
    [self.toolBar addSubview:sendButton];
    
    __block CycleViewController* blockSelf = self;
    self.view.keyboardTriggerOffset = self.toolBar.bounds.size.height;
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        CGRect toolBarFrame = blockSelf.toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        blockSelf.toolBar.frame = toolBarFrame;
    } constraintBasedActionHandler:nil];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"reloadData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishContent:) name:@"publish" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewMessage:) name:@"updateMessageStatus" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishContentNotification:) name:@"publishContent" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInteractionEnabled:) name:@"userInteractionEnabled" object:nil];
    
    //加载数据
    [self loadOffLineData];
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

/**
 *  加载离线数据
 */
-(void)loadOffLineData
{
    Cycle* cycleModel = [[Cycle alloc]init];
    NSMutableArray* dataArray = [cycleModel selectData:10 andOffset:(int)currentPage];
    
    if (dataArray && dataArray.count>0) {
        NSMutableArray * tempArray = [NSMutableArray new];
        for (int i = 0; i<dataArray.count; i++) {
            NSDictionary * dic = dataArray[i];
            Demo9Model *model = [Demo9Model new];
            model.name = [dic valueForKey:@"name"];
            model.address = [dic valueForKey:@"addr"];
            model.iconName = [dic valueForKey:@"photo"];
            model.content = [dic valueForKey:@"content"];
            model.position = [dic valueForKey:@"position"];
            model.dateTime = [dic valueForKey:@"datetime"];
            model.id = [[dic valueForKey:@"id"] integerValue];
            model.flag = [[dic valueForKey:@"flag"] boolValue];
            model.uid = [[dic valueForKey:@"uid"] integerValue];
            model.isLike = [[dic valueForKey:@"is_like"] boolValue];
            
            
            //分享
            Share * dicShare =[dic valueForKey:@"share"];
            if (dicShare) {
                NSMutableDictionary * dic = [NSMutableDictionary new];
                SETDICVFK(dic, @"id", dicShare.id);
                SETDICVFK(dic, @"title", dicShare.title);
                SETDICVFK(dic, @"url", dicShare.url);
                SETDICVFK(dic, @"img", dicShare.img);
                
                if (dic && dic.count>0) {
                    model.shareDic  = dic;
                }
            }
            
            //图片
            NSSet<Pic*> * picSets = [dic valueForKey:@"pic"];
            NSArray * array = picSets.allObjects;
            if (array && array.count>0) {
                NSMutableArray * tempArrary = [NSMutableArray new];
                for (int j  = 0; j<array.count; j++) {
                    Pic * pic =array[j];
                    [tempArrary addObject:pic.url];
                }
                model.picNamesArray =tempArrary;
            }
            
            //评论列表
            NSSet<Comment*> * commentSets = [dic valueForKey:@"comment"];
            array = commentSets.allObjects;
            if (array && array.count>0) {
                NSMutableArray * tempArrary = [NSMutableArray new];
                
                NSMutableDictionary * tempDic;
                for (int j  = 0; j<array.count; j++) {
                    Comment * comment =array[j];
                    tempDic = [NSMutableDictionary new];
                    
                    
                    SETDICVFK(tempDic, @"uid", comment.uid);
                    SETDICVFK(tempDic, @"id", comment.id);
                    SETDICVFK(tempDic, @"name", comment.name);
                    SETDICVFK(tempDic, @"at_name", comment.atName);
                    SETDICVFK(tempDic, @"photo", comment.photo);
                    SETDICVFK(tempDic, @"flag", comment.flag);
                     SETDICVFK(tempDic, @"content", comment.content);
                    [tempArrary addObject:tempDic];
                }
                model.commentArray = tempArrary;
            }
            
            
            //点赞列表
            //评论列表
            NSSet<Comment*> * likerSets = [dic valueForKey:@"likers"];
            array = likerSets.allObjects;
            if (array && array.count>0) {
                NSMutableArray * tempArrary = [NSMutableArray new];
                
                NSMutableDictionary * tempDic;
                for (int j  = 0; j<array.count; j++) {
                    Likers * liker =array[j];
                    tempDic = [NSMutableDictionary new];
                    
                    SETDICVFK(tempDic, @"uid", liker.uid);
                    SETDICVFK(tempDic, @"id", liker.id);
                    SETDICVFK(tempDic, @"name", liker.name);
                    SETDICVFK(tempDic, @"photo", liker.photo);
                    [tempArrary addObject:tempDic];
                }
                model.likersArray = tempArrary;
            }
            
            [tempArray addObject:model];
        }
        
        //状态栏提示
        [JDStatusBarNotification showWithStatus:STRING(@"已更新%ld条新数据", tempArray.count)  dismissAfter:3.0];
        self.dataArray = tempArray;
        
        //判断网络
        if ([TDUtil checkNetworkState] != NetStatusNone) {
            isRefresh = YES;
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadData) userInfo:nil repeats:NO];
        }
    }else{
        [self loadData];
    }
}

/**
 *  加载数据
 */
-(void)loadData
{
    if (!self.dataArray) {
        self.startLoading = YES;
    }
    NSString* serverUrl = [CYCLE_CONTENT_LIST stringByAppendingFormat:@"%d/",curentPage];
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestData:)];
}

-(void)refreshProject
{
    //加载动画
    isRefresh =YES;
    curentPage = 0;
    [self loadData];
    self.startLoading=NO;
}

-(void)loadProject
{
    //加载动画
    isRefresh =NO;
    if (!isEndOfPageSize) {
        curentPage++;
        [self loadData];
        self.startLoading=NO;
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"已加载全部"];
        isRefresh =NO;
    }
}


-(void)refresh
{
    [super refresh];
    
    [self loadData];
}

-(void)publishContentNotification:(NSDictionary*)dic
{
    NSDictionary* dataDic = [[dic valueForKey:@"userInfo"] valueForKey:@"data"];
    if (dataDic) {
        NSString* content = [dataDic valueForKey:@"content"];
        NSMutableArray* postArray =[dataDic valueForKey:@"files"];
        
        //组织数据
//        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        NSUserDefaults* dataDefault =[NSUserDefaults standardUserDefaults];
        
        //重构数组,
        //用户id
//        [dic setValue:@"YES" forKey:@"flag"];
//        [dic setValue:postArray forKey:@"pic"];
//        [dic setValue:@"刚刚" forKey:@"datetime"];
//        [dic setValue:content forKey:@"content"];
//        [dic setValue:[dataDefault valueForKey:@"userId"] forKey:@"uid"];
//        //        [dic setValue:[dataDefault valueForKey:@"city"] forKey:@"city"];
//        [dic setValue:[dataDefault valueForKey:@"name"] forKey:@"name"];
//        [dic setValue:[dataDefault valueForKey:@"photo"] forKey:@"photo"];
//        [dic setValue:[dataDefault valueForKey:@"STATIC_USER_TYPE"] forKey:@"position"];
        
        Demo9Model* model = [[Demo9Model alloc]init];
        
//        NSMutableArray* arr = [[NSMutableArray alloc]init];
//        for (int i = 0; i<postArray.count; i++) {
//            [arr addObject:[NSString stringWithFormat:@"file%d",i]];
//        }
        model.picNamesArray = postArray;
        model.flag = true;
        model.dateTime  = @"刚刚";
        model.content = content;
        model.uid = [[dataDefault valueForKey:@"userId"] integerValue];
        model.name = [dataDefault valueForKey:@"name"];
        model.iconName = [dataDefault valueForKey:@"photo"];
        model.position = [dataDefault valueForKey:@"STATIC_USER_TYPE"];
        
        
        [self.dataArray insertObject:model atIndex:0];
        [self.tableView reloadData];
        
        //1.获得全局的并发队列
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //2.添加任务到队列中，就可以执行任务
        //异步函数：具备开启新线程的能力
        dispatch_async(queue, ^{
            [self savePhoto:dataDic];
        });
        
        //[self performSelector:@selector(publishContent:) withObject:dataDic afterDelay:2];
    }
}

-(void)savePhoto:(NSDictionary*)dic
{
    NSMutableArray* uploadFiles =[NSMutableArray new];
    NSMutableArray* postArray =[dic valueForKey:@"files"];
    int i=0;
    for (UIView* v in postArray) {
        UIImage* image = (UIImage*)v;
        BOOL flag = [TDUtil saveContent:image fileName:[NSString stringWithFormat:@"file%d",i]];
        if (flag) {
            [uploadFiles addObject:[NSString stringWithFormat:@"file%d",i]];
            i++;
        }
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"publish" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:uploadFiles,@"uploadFiles",[dic valueForKey:@"content" ],@"content", nil]];
}

-(void)UserInfoSetting:(id)sender
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"ModifyUserInfoViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)userInfoAction:(id)sender
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfo" object:nil];
}

-(void)publishContent:(NSDictionary*)dic
{
    NSMutableArray* uploadFiles =[[dic valueForKey:@"userInfo"] valueForKey:@"uploadFiles"];
    NSString* content = [[dic valueForKey:@"userInfo"] valueForKey:@"content"];
    [self.httpUtil getDataFromAPIWithOps:CYCLE_CONTENT_PUBLISH postParam:[NSDictionary dictionaryWithObject:content forKey:@"content"] files:uploadFiles postName:@"file" type:0 delegate:self sel:@selector(requestPublishContent:)];
    
//    self.startLoading  =YES;
//    self.isTransparent = YES;
}

-(BOOL)commentAction:(id)sender
{
    NSString* content = textView.text;
    if ([content isEqualToString:@""] || [content isEqualToString:replyContent]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入回复内容"];
        [textView resignFirstResponder];
        return false;
    }
    
    [textView resignFirstResponder];
    
    NSString* serverUrl = [CYCLE_CONTENT_REPLY stringByAppendingFormat:@"%@/",conId];
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:[NSDictionary dictionaryWithObjectsAndKeys:content,@"content",atConId,@"at", nil] type:0 delegate:self sel:@selector(requestReply:)];
    return true;
}

-(void)publishAction:(id)sender
{
    UIStoryboard* board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    PublishViewController* controller = [board instantiateViewControllerWithIdentifier:@"PublishViewController"];
    controller.controller = self;
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoVC9Cell *cell = [tableView dequeueReusableCellWithIdentifier:kDemoVC9CellId];
//    if (!cell) {
        cell =[[DemoVC9Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDemoVC9CellId];
//    }
    cell.delegate = self;
    
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    NSLog(@"%@",cell.description);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
//    id model = self.dataArray[indexPath.row];
//    CGFloat h = [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DemoVC9Cell class]  contentViewWidth:[UIScreen mainScreen].bounds.size.width];
////    NSLog(@"%ld-->%f",indexPath.row,h);
//    return h;
//    // 获取cell高度
//    //return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[DemoVC9Cell class]  contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
}

- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width
{
    
    if (!self.tableView.cellAutoHeightManager) {
        self.tableView.cellAutoHeightManager = [[SDCellAutoHeightManager alloc] init];
    }
    if (self.tableView.cellAutoHeightManager.contentViewWidth != width) {
        self.tableView.cellAutoHeightManager.contentViewWidth = width;
        [self.tableView.cellAutoHeightManager clearHeightCache];
    }
    UITableViewCell *cell = [self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:indexPath];
    self.tableView.cellAutoHeightManager.modelCell = cell;
    if (cell.contentView.width != width) {
        cell.contentView.width = width;
    }
    return [[self.tableView cellAutoHeightManager] cellHeightForIndexPath:indexPath model:nil keyPath:nil];
}

#pragma UploadPic
//*********************************************************照相机功能*****************************************************//


//照相功能

-(void)takePhoto:(NSDictionary*)dic
{
    [self showPicker];
}

- (void)showPicker
{
    CustomImagePickerController* picker = [[CustomImagePickerController alloc] init];
    
    //创建返回按钮
    UIButton* btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NUMBERFORTY, NUMBERTHIRTY)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [leftButton setStyle:UIBarButtonItemStylePlain];
    //创建设置按钮
    btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, NUMBERFORTY, NUMBERTHIRTY)];
    btn.tintColor=WriteColor;
    btn.titleLabel.textColor=WriteColor;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    picker.navigationItem.leftBarButtonItem=leftButton;
    picker.navigationItem.rightBarButtonItem=rightButton;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else{
        [picker setIsSingle:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    [picker setCustomDelegate:self];
    self.customPicker=picker;
    [self presentViewController:self.customPicker animated:YES completion:nil];
}

- (void)cameraPhoto:(UIImage *)imageCamera  //选择完图片
{
    [self openEditor:imageCamera];
}

- (void)openEditor:(UIImage*)imageCamera
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = imageCamera;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    //保存图片
    [TDUtil saveCameraPicture:croppedImage fileName:USER_STATIC_CYCLE_BG];
    
    //    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeUserPic" object:nil userInfo:[NSDictionary dictionaryWithObject:croppedImage forKey:@"img"]];
    //修改头部背景
    [headerView.headerBackView setImage:croppedImage];
    
    //开始上传
    [self uploadUserPic:0];
}


-(void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


//取消照相
-(void)cancelCamera
{
    
}


//上传身份证
-(void)uploadUserPic:(NSInteger)id
{
    [self.httpUtil getDataFromAPIWithOps:CYCLE_CONTENT_BACKGROUND_UPLOAD postParam:nil file:STATIC_USER_BACKGROUND_PIC postName:@"file" type:0 delegate:self sel:@selector(requestUploadHeaderImg:)];
}


#pragma WeiboTableViewCellDelegate
-(void)weiboTableViewCell:(id)weiboTableViewCell userId:(NSString*)userId isSelf:(BOOL)isSelf
{
    UserLookForViewController* controller = [[UserLookForViewController alloc]init];
    controller.userId = userId;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)weiboTableViewCell:(id)weiboTableViewCell contentId:(NSString *)contentId atId:(NSString *)atId isSelf:(BOOL)isSelf
{
    atConId  =atId;
    conId  =contentId;
    currentSelectedCell = weiboTableViewCell;
    
    if (atConId) {
        //获取被@对象名称
        NSString* name = @"";
        for (int i = 0 ; i<currentSelectedCell.dataArray.count; i++) {
            NSDictionary* dic  = currentSelectedCell.dataArray[i];
            if ([[dic valueForKey:@"id"] integerValue]==[atId integerValue]) {
                name = [dic valueForKey:@"name"];
            }
        }
        
        textView.text= [NSString stringWithFormat:@"回复%@:",name];
        replyContent = textView.text;
        textView.textColor = LightGrayColor;
    }else{
        replyContent = @"";
        textView.text  = replyContent;
    }
    [textView becomeFirstResponder];
}

-(void)weiboTableViewCell:(id)weiboTableViewCell deleteDic:(id)cycle
{
    if ([self.dataArray containsObject:cycle]) {
        [self.dataArray removeObject:cycle];
        [self.tableView reloadData];
    }
}

-(void)weiboTableViewCell:(id)weiboTableViewCell priseDic:(NSDictionary *)dic msg:(NSString *)msg
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:weiboTableViewCell];
    if (dic) {
        if ([[dic valueForKey:@"is_like"] boolValue]) {
            Demo9Model* model = self.dataArray[indexPath.row];
            NSMutableArray* array = [NSMutableArray arrayWithArray:model.likersArray];
            if (![model.likersArray containsObject:dic]) {
                [array insertObject:dic atIndex:0];
                model.likersArray = array;
                self.dataArray[indexPath.row] = model;
            }
        }else{
            Demo9Model* model = self.dataArray[indexPath.row];
            NSMutableArray* array = [NSMutableArray arrayWithArray:model.likersArray];
            for (int i= 0 ;i<array.count;i++) {
                NSDictionary* d = array[i];
                if ([[d valueForKey:@"uid"]integerValue]==[[dic valueForKey:@"uid"] integerValue]) {
                    [array removeObject:d];
                }
            }
            //设置为没有点赞
            model.isLike = NO;
            model.likersArray = array;
            self.dataArray[indexPath.row] = model;
        }
        [self.tableView reloadData];
    }
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:msg];
    
}
-(void)weiboTableViewCell:(id)weiboTableViewCell refresh:(BOOL)refresh
{
    Demo9Model* model =((DemoVC9Cell*)weiboTableViewCell).model;
    NSIndexPath* inPath = [self.tableView indexPathForCell:weiboTableViewCell];
    Demo9Model* modelInstance = [self.dataArray objectAtIndex:inPath.row];
    modelInstance.commentArray = model.commentArray;
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:inPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView reloadData];
    
}

-(void)weiboTableViewCell:(id)weiboTableViewCell didSelectedContent:(BOOL)isSelected
{
    NSIndexPath* indexPath =[self.tableView indexPathForCell:weiboTableViewCell];
    //    NSDictionary* dic = self.dataArray[indexPath.row];
    //    //内容
    //    NSString* content = [dic valueForKey:@"content"];
    //    NSInteger picsCount = [[dic valueForKey:@"pics"] count];
    //
    //
    //    int number = [TDUtil convertToInt:content] / 17;
    //    if (number==0) {
    //        if ([content length]>0) {
    //            number++;
    //        }
    //    }
    //
    //    CGFloat height = number*25;
    //    if(picsCount>0 && picsCount<=3){
    //        height +=70;
    //    }else{
    //        if (picsCount%3!=0) {
    //            height += (picsCount/3+1)*80;
    //        }else{
    //            height += (picsCount/3)*80;
    //        }
    //    }
    //
    //
    //    height+=160;
    
    ActionDetailViewController* controller = [[ActionDetailViewController alloc]init];
    controller.dic = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)weiboTableViewCell:(id)weiboTableViewCell didSelectedShareContentUrl:(NSURL *)urlStr
{
    Demo9Model * model = ((DemoVC9Cell*)weiboTableViewCell).model;
    BannerViewController* controller =[[BannerViewController alloc]init];
    controller.type=3;
    controller.url =urlStr;
    controller.title=@"圈子";
    controller.titleStr=@"资讯详情";
    controller.dic = model.shareDic;
    [self.navigationController pushViewController:controller animated:YES];
}



//*********************************************************照相机功能结束*****************************************************//

-(BOOL)textViewShouldBeginEditing:(UITextView *)tv
{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)tv
{
    
}

-(void)textViewDidEndEditing:(UITextView *)tv
{
    if ([tv.text isEqualToString:@""]) {
        tv.text=replyContent;
        tv.textColor  =LightGrayColor;
    }
}


-(void)textViewDidChange:(UITextView *)tv
{
    if (!atConId) {
        tv.textColor  =FONT_COLOR_BLACK;
    }
    if ([tv.text containsString:replyContent]) {
        NSString * content = tv.text;
        content = [content stringByReplacingOccurrencesOfString:replyContent withString:@""];
        tv.text  = content;
        tv.textColor  =FONT_COLOR_BLACK;
    }else if ([tv.text isEqualToString:@""]){
        tv.text=replyContent;
        tv.textColor  =LightGrayColor;
    }
    
    CGFloat height = textView.contentSize.height;
    if (toolBarHeight != height) {
        if (toolBarHeight!=0) {
            CGRect toolBarFrame = self.toolBar.frame;
            toolBarFrame.origin.y -=(height-toolBarHeight);
            toolBarFrame.size.height+=(height-toolBarHeight);
            
            [self.toolBar setFrame:toolBarFrame];
            
            sendButton.frame = CGRectMake(self.toolBar.bounds.size.width - 68.0f,
                                          HEIGHT(self.toolBar)/2-15,
                                          58.0f,
                                          29.0f);
            
        }
        toolBarHeight=height;
    }
}

-(void)textViewDidChangeSelection:(UITextView *)tv
{
    //    NSLog(@"-----%@",tv.text);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self commentAction:nil];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


#pragma 设置数据
-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray && dataArray.count>0) {
        self->_dataArray = dataArray;
        [self.tableView reloadData];
    }
}


#pragma ASIHttpRequest
-(void)requestData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* code = [dic valueForKey:@"code"];
        if ([code integerValue]==0  || [code integerValue]==2) {
            NSArray* tempArray = [dic valueForKey:@"data"];
            NSMutableArray* modelArray=[NSMutableArray new];
            NSDictionary* dic;
            for (int i=0; i<tempArray.count; i++) {
                dic = [tempArray objectAtIndex:i];
                
                Demo9Model *model = [Demo9Model new];
                model.name = [dic valueForKey:@"name"];
                model.address = [dic valueForKey:@"addr"];
                model.iconName = [dic valueForKey:@"photo"];
                model.content = [dic valueForKey:@"content"];
                model.position = [dic valueForKey:@"position"];
                model.dateTime = [dic valueForKey:@"datetime"];
                model.id = [[dic valueForKey:@"id"] integerValue];
                model.flag = [[dic valueForKey:@"flag"] boolValue];
                model.uid = [[dic valueForKey:@"uid"] integerValue];
                model.isLike = [[dic valueForKey:@"is_like"] boolValue];
                
                
                //分享
                NSDictionary* dicShare =[dic valueForKey:@"share"];
                if (dicShare) {
                    model.shareDic=dicShare;
                }
                
                //图片
                NSArray* array = [dic valueForKey:@"pic"];
                if (array && array.count>0) {
                    model.picNamesArray =array;
                }
                
                //评论列表
                array = [dic valueForKey:@"comment"];
                model.commentArray = array;
                
                //点赞列表
                array = [dic valueForKey:@"like"];
                model.likersArray = array;
                [modelArray addObject:model];
            }
            
            if (isRefresh) {
                self.dataArray = modelArray;
            }else{
                if (self.dataArray) {
                    [self.dataArray addObjectsFromArray:modelArray];
                    [self.tableView reloadData];
                }else{
                    self.dataArray = modelArray;
                }
            }
            
            
            if (curentPage == 0 && tempArray && tempArray.count>0) {
                //缓存离线数据
                [self storeOfflineData:tempArray];
            }
            
            //保存数据
            if (isRefresh) {
                [self.tableView.header endRefreshing];
            }else{
                [self.tableView.footer endRefreshing];
            }
            if ([code integerValue]==2) {
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"已加载全部数据"];
            }
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
            //            self.startLoading = NO;
            //移除重新加载数据监听
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
            
            //关闭加载动画
            self.startLoading = NO;
        }else if([code intValue]==-1){
            //添加重新加载数据监听
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"reloadData" object:nil];
            //通知系统重新登录
            [[NSNotificationCenter defaultCenter]postNotificationName:@"login" object:nil];
        }else{
            self.isNetRequestError = YES;
        }
    }else{
        self.isNetRequestError = YES;
    }
}

-(void)storeOfflineData:(NSArray*)array
{
    //开始进行圈子数据缓存
    
    Cycle* cycleModel = [[Cycle alloc]init];
    
    //移除先前缓存数据
    
    [cycleModel deleteData];
    
    Cycle* cycle;
    
    NSDictionary* dic;
    
    for (int i = 0; i<array.count; i++) {
        
        dic = array[i];
        
        cycle = [[Cycle alloc]init];
        
        cycle.id = [dic valueForKey:@"id"];
        
        cycle.flag = [dic valueForKey:@"flag"];
        
        cycle.position = [dic valueForKey:@"position"];
        
        cycle.name = [dic valueForKey:@"name"];
        
        cycle.datetime = [dic valueForKey:@"datetime"];
        
        cycle.is_like = [dic valueForKey:@"is_like"];
        
        cycle.addr = [dic valueForKey:@"addr"];
        
        cycle.remain_comment = [dic valueForKey:@"remain_comment"];
        
        cycle.flag = [dic valueForKey:@"flag"];
        
        cycle.remain_like = [dic valueForKey:@"remain_like"];
        
        cycle.photo = [dic valueForKey:@"photo"];
        
        cycle.uid = [dic valueForKey:@"uid"];
        
        cycle.company = [dic valueForKey:@"company"];
        
        cycle.content = [dic valueForKey:@"content"];
        
        
        
        //分享
        
        NSDictionary* dicShare =[dic valueForKey:@"share"];
        
        if (dic) {
            
            Share* share = [[Share alloc]init];
            
            share.id = [dicShare valueForKey:@"id"];
            
            share.url = [dicShare valueForKey:@"url"];
            
            share.img = [dicShare valueForKey:@"img"];
            
            share.title = [dicShare valueForKey:@"title"];
            
            cycle.share = share;
            
        }
        
        
        
        //评论列表
        
        NSArray* array = [dic valueForKey:@"comment"];
        
        if (array && array.count>0) {
            
            Comment* comment;
            
            NSMutableSet<Comment*> *commentSet = [[NSMutableSet alloc]init];
            
            NSDictionary* commentDic;
            
            for (int j = 0; j<array.count; j++) {
                
                commentDic = [array objectAtIndex:j];
                
                comment = [[Comment alloc]init];
                
                comment.id = [NSNumber numberWithInteger:[[commentDic valueForKey:@"id"] integerValue]];
                
                comment.uid = [NSNumber numberWithInteger:[[commentDic valueForKey:@"uid"] integerValue]];
                
                comment.flag = [NSNumber numberWithInt:[[commentDic valueForKey:@"flag"] intValue]];
                
                comment.name = [NSString stringWithFormat:@"%@",[commentDic valueForKey:@"name"]];
                
                comment.atName = [NSString stringWithFormat:@"%@",[commentDic valueForKey:@"at_name"]];
                
                
                
                if ([comment.atName isEqualToString:@"(null)"]) {
                    
                    comment.atName = @"";
                    
                }
                
                comment.photo = [commentDic valueForKey:@"photo"];
                
                comment.content = [commentDic valueForKey:@"content"];
                
                
                
                [commentSet addObject:comment];
                
            }
            
            cycle.comment = commentSet;
            
        }
        
        
        
        //评论列表
        
        array = [dic valueForKey:@"pic"];
        
        if (array && array.count>0) {
            
            Pic* pic;
            
            NSMutableSet<Pic*> *picSet = [[NSMutableSet alloc]init];
            
            for (int j = 0; j<array.count; j++) {
                
                pic = [[Pic alloc]init];
                
                pic.url = [array objectAtIndex:j];
                
                [picSet addObject:pic];
                
            }
            
            cycle.pic = picSet;
            
        }
        
        
        
        //点赞列表
        
        array = [dic valueForKey:@"like"];
        
        
        
        if (array && array.count>0) {
            
            Likers* liker;
            
            NSMutableSet<Likers*> *likersSet = [[NSMutableSet alloc]init];
            
            NSDictionary* likerDic;
            
            for (int j = 0; j<array.count; j++) {
                
                likerDic = [array objectAtIndex:j];
                
                liker = [[Likers alloc]init];
                
                liker.id = [NSNumber numberWithInteger:[[likerDic valueForKey:@"id"] integerValue]];
                
                liker.uid = [NSNumber numberWithInteger:[[likerDic valueForKey:@"uid"] integerValue]];
                
                liker.name = [NSString stringWithFormat:@"%@",[likerDic valueForKey:@"name"]];
                
                liker.photo = [likerDic valueForKey:@"photo"];
                
                [likersSet addObject:liker];
                
                
                
                
                
//                /**
//                 
//                 *  模拟点赞
//                 
//                 */
////                
//                                        for (int m=0; m<10; m++) {
//                
//                                            Likers* l = [[Likers alloc]init];
//                
//                                            l.name = [NSString stringWithFormat:@"陈生珠%d",m];
//                
//                                            [likersSet addObject:l];
//                
//                                        }
//
//                /**
//                 
//                 *  模拟点赞
//                 
//                 */
                
                
                
            }
            
            cycle.likers = likersSet;
            
        }
        
        [cycle save];
        
    }
}


/**
 *  上传照片
 *
 *  @param request 返回上传结果
 */
-(void)requestUploadHeaderImg:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            headerView.headerBackView.image  =[TDUtil loadContent:STATIC_USER_BACKGROUND_PIC];
        }
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
}

-(void)requestReply:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"code"];
        if ([status integerValue] ==0) {
            textView.text = @"";
            toolBarHeight =0;
            [textView resignFirstResponder];
            [self.toolBar setFrame:CGRectMake(0.0f,
                                              self.view.bounds.size.height,
                                              self.view.bounds.size.width,
                                              40.0f)];
            
            sendButton.frame = CGRectMake(self.toolBar.bounds.size.width - 68.0f,
                                          HEIGHT(self.toolBar)/2-15,
                                          58.0f,
                                          29.0f);
            //currentSelectedCell.dic = [dic valueForKey:@"data"];
            NSIndexPath* indexPath = [self.tableView indexPathForCell:currentSelectedCell];
            Demo9Model* model = self.dataArray[indexPath.row];
            NSMutableArray* array =[NSMutableArray arrayWithArray:model.commentArray];
            NSDictionary* dicTemp = [dic valueForKey:@"data"];
            [array insertObject:dicTemp atIndex:0];
            
            model.commentArray = array;
            self.dataArray[indexPath.row] = model;
            [self.tableView reloadData];
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
    }
}

-(void)requestPublishContent:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* code = [dic valueForKey:@"code"];
        if ([code integerValue] == 0) {
            NSDictionary* dataDic = [dic valueForKey:@"data"];
            
            
            Demo9Model *model = [Demo9Model new];
            model.id = [[dataDic valueForKey:@"id"] integerValue];
            model.uid = [[dataDic valueForKey:@"uid"] integerValue];
            model.isLike = [[dataDic valueForKey:@"is_like"] boolValue];
            model.name = [dataDic valueForKey:@"name"];
            model.address = [dataDic valueForKey:@"addr"];
            model.iconName = [dataDic valueForKey:@"photo"];
            model.content = [dataDic valueForKey:@"content"];
            model.position = [dataDic valueForKey:@"position"];
            model.dateTime = [dataDic valueForKey:@"datetime"];
            
            //分享
            NSDictionary* dicShare =[dataDic valueForKey:@"share"];
            if (dicShare) {
                model.shareDic=dicShare;
            }
            
            //图片
            NSArray* array = [dataDic valueForKey:@"pic"];
            if (array && array.count>0) {
                model.picNamesArray =array;
            }
            
            //评论列表
            array = [dataDic valueForKey:@"comment"];
            model.commentArray = array;
            
            //点赞列表
            array = [dataDic valueForKey:@"like"];
            model.likersArray = array;
            
            [self.dataArray replaceObjectAtIndex:0 withObject:model];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        self.startLoading = NO;
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
    }
}


-(void)requestFailed:(ASIFormDataRequest*)request
{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    self.isNetRequestError = YES;
}


#pragma mark - keyboardHight
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 鍵盤出現時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 鍵盤隐藏時
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}



//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGFloat change = [self keyboardEndingFrameHeight:[aNotification userInfo]];
    CGPoint point = [self.tableView contentOffset];
    point.y += change;
//    [self.tableView setContentOffset:point animated:YES];
    NSIndexPath * indexPath = [self.tableView indexPathForCell:currentSelectedCell];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

//当键盘隐藏的时候
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //输入框位置动画加载
//    CGFloat change = [self keyboardEndingFrameHeight:[aNotification userInfo]];
//    CGPoint point = [self.tableView contentOffset];
//    point.y -= change;
//    [self.tableView setContentOffset:point animated:YES];
    
}

-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
