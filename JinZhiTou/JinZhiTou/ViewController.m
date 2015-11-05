//
//  ViewController.m
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "UIImage+Crop.h"
#import "CycleHeader.h"
#import "DAKeyboardControl.h"
#import "PECropViewController.h"
#import "BannerViewController.h"
#import "PublishViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserLookForViewController.h"
#import "ActionDetailViewController.h"
#import "UserBasicInfoViewController.h"
#import "CustomImagePickerController.h"
#define  TEXT_VIEW_HEIGHT  30
@interface ViewController ()<WeiboTableViewCellDelegate,CustomImagePickerControllerDelegate,UITextViewDelegate>
{
    BOOL isRefresh;
    float toolBarHeight;
    
    UIButton *sendButton;
    UITextView *textView;
    NSInteger currentPage;
    NSString* conId,* atConId;
    
    CycleHeader* headerView;
    WeiboTableViewCell* currentSelectedCell;
}
@property(retain,nonatomic)CustomImagePickerController* customPicker;
@property(retain,nonatomic)UIToolbar *toolBar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    
    //==============================TabBarItem 设置==============================//
    UIImage* image=IMAGENAMED(@"btn-quanzi-cheng");
    image=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.tabBarItem setSelectedImage:image];
    [self.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorTheme,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
     //==============================TabBarItem 设置==============================//
    
     //==============================导航栏区域 设置==============================//
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=0;
    [self.navView setTitle:@"金指投"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:IMAGENAMED(@"top-caidan") forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction:)]];
    
    [self.navView.rightButton setImage:IMAGENAMED(@"circle_publish") forState:UIControlStateNormal];
    [self.navView.rightTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publishAction:)]];
    [self.view addSubview:self.navView];
     //==============================导航栏区域 设置==============================//
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView)-kBottomBarHeight-70)];
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
    
    __block ViewController* blockSelf = self;
    self.view.keyboardTriggerOffset = self.toolBar.bounds.size.height;
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        /*
         Try not to call "self" inside this block (retain cycle).
         But if you do, make sure to remove DAKeyboardControl
         when you are done with the view controller by calling:
         [self.view removeKeyboardControl];
         */
        
        CGRect toolBarFrame = blockSelf.toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        blockSelf.toolBar.frame = toolBarFrame;
        
//        CGRect tableViewFrame = viewSelf.tableView.frame;
//        tableViewFrame.size.height = toolBarFrame.origin.y;
//        viewSelf.tableView.frame = tableViewFrame;
    } constraintBasedActionHandler:nil];
    
    [self loadData];
    
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishContentNotification:) name:@"publishContent" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishContent:) name:@"publish" object:nil];
}

/**
 *  加载数据
 */
-(void)loadData
{
//    NSMutableArray* array = [NSMutableArray new];
//    NSMutableDictionary* dic;
//    for (int i=1; i<=8; i++) {
//        dic = [NSMutableDictionary new];
//        NSMutableArray* imgArray = [NSMutableArray new];
//        for (int j = i; j <=7; j++) {
//            [imgArray addObject:[NSString stringWithFormat:@"%d",j]];
//        }
//        [dic setValue:imgArray forKey:@"imageName"];
//        [array addObject:dic];
//    }
//    self.dataArray = array;
    NSString* serverUrl = [CYCLE_CONTENT_LIST stringByAppendingFormat:@"%ld/",currentPage];
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestData:)];
}


-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    [self loadData];
}

-(void)loadProject
{
    isRefresh =NO;
    if (!self.isEndOfPageSize) {
        currentPage++;
        [self loadData];
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"已加载全部"];
        isRefresh =NO;
    }
}

-(void)publishContentNotification:(NSDictionary*)dic
{
    NSDictionary* dataDic = [[dic valueForKey:@"userInfo"] valueForKey:@"data"];
    if (dataDic) {
        NSString* content = [dataDic valueForKey:@"content"];
        NSMutableArray* postArray =[dataDic valueForKey:@"files"];
        
        //组织数据
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        NSUserDefaults* dataDefault =[NSUserDefaults standardUserDefaults];
        
        //重构数组,
        //用户id
        [dic setValue:@"YES" forKey:@"flag"];
        [dic setValue:postArray forKey:@"pics"];
        [dic setValue:@"刚刚" forKey:@"datetime"];
        [dic setValue:content forKey:@"content"];
        [dic setValue:[dataDefault valueForKey:@"userId"] forKey:@"uid"];
        [dic setValue:[dataDefault valueForKey:@"city"] forKey:@"city"];
        [dic setValue:[dataDefault valueForKey:@"name"] forKey:@"name"];
        [dic setValue:[dataDefault valueForKey:@"photo"] forKey:@"photo"];
        [dic setValue:[dataDefault valueForKey:@"STATIC_USER_TYPE"] forKey:@"position"];
        
        [self.dataArray insertObject:dic atIndex:0];
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
-(void)publishContent:(NSDictionary*)dic
{
    NSMutableArray* uploadFiles =[[dic valueForKey:@"userInfo"] valueForKey:@"uploadFiles"];
    NSString* content = [[dic valueForKey:@"userInfo"] valueForKey:@"content"];
    [self.httpUtil getDataFromAPIWithOps:CYCLE_CONTENT_PUBLISH postParam:[NSDictionary dictionaryWithObject:content forKey:@"content"] files:uploadFiles postName:@"file" type:0 delegate:self sel:@selector(requestPublishContent:)];
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

-(BOOL)commentAction:(id)sender
{
    NSString* content = textView.text;
    if ([content isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入回复内容"];
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

-(void)setDataArray:(NSMutableArray *)dataArray{
    self->_dataArray = dataArray;
    if (dataArray && dataArray.count>0) {
        [self.tableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [textView resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count>0) {
        return [self getHeightItemWithIndexpath:indexPath];
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"CellInstance";
    //用TableDataIdentifier标记重用单元格
    WeiboTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    if (!cell) {
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        cell  =  [[WeiboTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.dataArray.count>0){
        NSMutableDictionary* dic =self.dataArray[indexPath.row];
        cell.dic =dic;
    }
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    [textView becomeFirstResponder];
}

-(void)weiboTableViewCell:(id)weiboTableViewCell deleteDic:(NSDictionary *)dic
{
    if ([self.dataArray containsObject:dic]) {
        [self.dataArray removeObject:dic];
        [self.tableView reloadData];
    }
}

-(void)weiboTableViewCell:(id)weiboTableViewCell priseDic:(NSDictionary *)dic msg:(NSString *)msg
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:weiboTableViewCell];
    if (dic) {
        if ([[dic valueForKey:@"is_like"] boolValue]) {
            NSDictionary* dicTemp = self.dataArray[indexPath.row];
            NSMutableArray* array = [dicTemp valueForKey:@"likers"];
            [array insertObject:dic atIndex:0];
            [dicTemp setValue:array forKey:@"likers"];
            self.dataArray[indexPath.row] = dicTemp;
        }else{
            NSDictionary* dicTemp = self.dataArray[indexPath.row];
            NSMutableArray* array = [dicTemp valueForKey:@"likers"];
            for (int i= 0 ;i<array.count;i++) {
                NSDictionary* d = array[i];
                if ([[d valueForKey:@"uid"]integerValue]==[[dic valueForKey:@"uid"] integerValue]) {
                    [array removeObject:d];
                }
            }
            [dicTemp setValue:array forKey:@"likers"];
            self.dataArray[indexPath.row] = dicTemp;
        }
        [self.tableView reloadData];
    }
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:msg];
    
}
-(void)weiboTableViewCell:(id)weiboTableViewCell refresh:(BOOL)refresh
{
    if (refresh) {
        [self loadData];
    }
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
    NSLog(@"url:%@",urlStr);
    NSDictionary* dic =((WeiboTableViewCell*)weiboTableViewCell).dic;
    BannerViewController* controller =[[BannerViewController alloc]init];
    controller.titleStr=@"咨询详情";
    controller.dic = [dic valueForKey:@"share"];
    controller.title=@"圈子";
    controller.type=3;
    controller.url =urlStr;
    [self.navigationController pushViewController:controller animated:YES];
}
-(CGFloat)getHeightItemWithIndexpath:(NSIndexPath*) indexpath
{
    NSDictionary* dic = self.dataArray[indexpath.row];
    //内容
    NSString* content = [dic valueForKey:@"content"];
    NSInteger picsCount = [[dic valueForKey:@"pics"] count];
    NSInteger likersCount = [[dic valueForKey:@"likers"] count];
    NSInteger commentCount = [[dic valueForKey:@"comment"] count];
    
    
    int number = [TDUtil convertToInt:content] / 17;
    if (number>5) {
        number  =5;
    }else{
        if ([content length]>0) {
            number++;
        }
    }
    
    CGFloat height = number*25;
    if(picsCount>0 && picsCount<=3){
        height +=70;
    }else{
        if (picsCount%3!=0) {
            height += (picsCount/3+1)*80;
        }else{
            height += (picsCount/3)*80;
        }
    }
    
    if (likersCount>0 && likersCount<=4) {
        height+=50;
    }else{
        height += (likersCount/4+1)*25;
    }
    
    for (int i=0; i<commentCount; i++) {
        NSMutableArray* array  = [dic valueForKey:@"comment"];
        NSDictionary* dic  = array[i];
        NSString* name  = [dic valueForKey:@"name"];
        NSString* atLabel = [dic valueForKey:@"at_label"];
        NSString* atName = [dic valueForKey:@"at_name"];
        NSString* suffix =  [dic valueForKey:@"label_suffix"];
        NSString* content =  [dic valueForKey:@"content"];
        NSString* str = name;
        if (atLabel) {
            str = [str stringByAppendingString:atLabel];
        }
        
        if (atName) {
            str = [str stringByAppendingString:atName];
        }
        
        if (suffix) {
            str = [str stringByAppendingString:suffix];
        }
        
        if (content) {
            str = [str stringByAppendingString:content];
        }
        
        NSInteger number = [TDUtil convertToInt:str];
        NSInteger line = number/17;
        
        if (line>0) {
            height+=(line+1)*13+10;
        }else{
            if (number>0) {
                height += 23;
            }
        }
        
    }
    
    if ([dic valueForKey:@"share"]) {
        height+=74;
    }
    
    height+=140;
    return height;
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
    [TDUtil saveCameraPicture:croppedImage fileName:STATIC_USER_BACKGROUND_PIC];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeUserPic" object:nil userInfo:[NSDictionary dictionaryWithObject:croppedImage forKey:@"img"]];
    
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



//*********************************************************照相机功能结束*****************************************************//

-(void)textViewDidChange:(UITextView *)tv
{
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
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

#pragma ASIHttpRequest
-(void)requestData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        NSMutableArray* dataArray = [NSMutableArray new];
        NSMutableArray* arrayData = [dic valueForKey:@"data"];
        if ([status integerValue]==0  || [status integerValue]==-1) {
            if (isRefresh) {
                dataArray = arrayData;
            }else{
                if (self.dataArray) {
                    dataArray = self.dataArray;
                }
                for (int i=0; i<arrayData.count; i++) {
                    [dataArray addObject:arrayData[i]];
                }
            }
//            NSDictionary* dic =[[dataArray[0] valueForKey:@"likers"] objectAtIndex:0];
//            for (int i=0; i<45; i++) {
//                [dic setValue:[NSString stringWithFormat:@"%d",i] forKey:@"uid"];
//                [[dataArray[0] valueForKey:@"likers"] addObject:dic];
//            }
            self.dataArray = dataArray;
            if (isRefresh) {
                [self.tableView.header endRefreshing];
            }else{
                [self.tableView.footer endRefreshing];
            }
            
            if ([status integerValue]==-1) {
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"内容已加载完毕!"];
            }
        }else{
            
        }
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
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
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
        NSString* status = [dic valueForKey:@"status"];
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
            NSDictionary* dataDic = self.dataArray[indexPath.row];
            NSMutableArray* array =[dataDic  valueForKey:@"comment"];
            NSDictionary* dicTemp = [dic valueForKey:@"data"];
            [array insertObject:dicTemp atIndex:0];
            self.dataArray[indexPath.row] = dataDic;
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
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue] == 0) {
            NSDictionary* dataDic = [dic valueForKey:@"data"];
            [self.dataArray replaceObjectAtIndex:0 withObject:dataDic];
            [self.tableView reloadData];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

@end
