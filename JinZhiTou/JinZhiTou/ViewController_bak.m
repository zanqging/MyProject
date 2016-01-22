//
//  ViewController.m
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "ViewController_bak.h"
#import "Pic+CoreDataProperties.h"
#import "Cycle+CoreDataProperties.h"
#import "Likers+CoreDataProperties.h"
#import "Comment+CoreDataProperties.h"
#import "MJRefresh.h"
#import "CycleHeader.h"
#import "UIImage+Crop.h"
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
@interface ViewController_bak ()<WeiboTableViewCellDelegate,CustomImagePickerControllerDelegate,UITextViewDelegate>
{
    BOOL isRefresh;
    float toolBarHeight;
    
    UIButton *sendButton;
    UITextView *textView;
    NSInteger currentPage;
    NSString* replyContent;
    NSString* conId,* atConId;
    
    CycleHeader* headerView;
    WeiboTableViewCell* currentSelectedCell;
}
@property(retain,nonatomic)CustomImagePickerController* customPicker;
@property(retain,nonatomic)UIToolbar *toolBar;
@end

@implementation ViewController_bak

- (void)viewDidLoad {
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
    [self.navView.leftButton setImage:IMAGENAMED(@"shuruphone") forState:UIControlStateNormal];
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
    
    __block ViewController_bak* blockSelf = self;
    self.view.keyboardTriggerOffset = self.toolBar.bounds.size.height;
    [self.view addKeyboardPanningWithFrameBasedActionHandler:^(CGRect keyboardFrameInView, BOOL opening, BOOL closing) {
        CGRect toolBarFrame = blockSelf.toolBar.frame;
        toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
        blockSelf.toolBar.frame = toolBarFrame;
    } constraintBasedActionHandler:nil];
    
    
    //加载动画
//    self.startLoading  =YES;
    //加载离线数据
    [self loadOffLineData];
    //加载数据
    [self loadData];
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

-(void)loadOffLineData
{
    Cycle* cycleModel = [[Cycle alloc]init];
    NSMutableArray* dataArray = [cycleModel selectData:10 andOffset:(int)currentPage];
    
    if (dataArray && dataArray.count>0) {
        self.dataArray = dataArray;
    }
}

/**
 *  加载数据
 */
-(void)loadData
{
    NSString* serverUrl = [CYCLE_CONTENT_LIST stringByAppendingFormat:@"%ld/",currentPage];
    [self.httpUtil getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestData:)];
    
    [self updateNewMessage:nil];
}


-(void)refreshProject
{
    //加载动画
    isRefresh =YES;
    currentPage = 0;
    [self loadData];
}

-(void)loadProject
{
    //加载动画
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
        [dic setValue:postArray forKey:@"pic"];
        [dic setValue:@"刚刚" forKey:@"datetime"];
        [dic setValue:content forKey:@"content"];
        [dic setValue:[dataDefault valueForKey:@"userId"] forKey:@"uid"];
//        [dic setValue:[dataDefault valueForKey:@"city"] forKey:@"city"];
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
    
    self.startLoading  =YES;
    self.isTransparent = YES;
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
//        NSMutableDictionary* dic =self.dataArray[indexPath.row];
        Cycle*  cycle = self.dataArray[indexPath.row];
        cell.cycle =cycle;
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

-(void)weiboTableViewCell:(id)weiboTableViewCell deleteDic:(Cycle*)cycle
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
            NSDictionary* dicTemp = self.dataArray[indexPath.row];
            NSMutableArray* array = [dicTemp valueForKey:@"like"];
            [array insertObject:dic atIndex:0];
            [dicTemp setValue:array forKey:@"like"];
            self.dataArray[indexPath.row] = dicTemp;
        }else{
            NSDictionary* dicTemp = self.dataArray[indexPath.row];
            NSMutableArray* array = [dicTemp valueForKey:@"like"];
            for (int i= 0 ;i<array.count;i++) {
                NSDictionary* d = array[i];
                if ([[d valueForKey:@"uid"]integerValue]==[[dic valueForKey:@"uid"] integerValue]) {
                    [array removeObject:d];
                }
            }
            [dicTemp setValue:array forKey:@"like"];
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
    Cycle* cycle =((WeiboTableViewCell*)weiboTableViewCell).cycle;
//    BannerViewController* controller =[[BannerViewController alloc]init];
//    controller.titleStr=@"咨询详情";
//    controller.dic = [dic valueForKey:@"share"];
//    controller.title=@"圈子";
//    controller.type=3;
//    controller.url =[NSURL URLWithString:[[dic valueForKey:@"share"] valueForKey:@"url"]];
//    [self.navigationController pushViewController:controller animated:YES];
}
-(CGFloat)getHeightItemWithIndexpath:(NSIndexPath*) indexpath
{
    Cycle* cycle = self.dataArray[indexpath.row];
    //头像
    float height = 110; //姓名＋间距
    if ([TDUtil isValidString:cycle.addr]) {
        height+=20;
    }
    //内容
    NSString* content = cycle.content;
    if ([TDUtil isValidString:content]) {
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view)-160, 0)];
        label.font  =SYSTEMFONT(14);
        label.textColor  =FONT_COLOR_BLACK;
        label.numberOfLines  =5;
        label.userInteractionEnabled  =YES;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        
        [TDUtil setLabelMutableText:label content:content lineSpacing:3 headIndent:0];
        height+=HEIGHT(label);
    }
    
    NSInteger picsCount = cycle.pic.count;
    if(picsCount>0 && picsCount<=3){
        height +=70;
    }else{
        if (picsCount>0) {
            if (picsCount%3!=0) {
                height += (picsCount/3+1)*75;
            }else{
                height += (picsCount/3)*75;
            }
        }
    }
    
    NSArray* dataPriseArray = [cycle.likers allObjects];
    if (dataPriseArray && dataPriseArray.count>0) {
        NSString* str=@"";
        NSDictionary* dic;
        for (int i = 0; i<dataPriseArray.count; i++) {
            dic =dataPriseArray[i];
            NSString* name = [dic valueForKey:@"name"];
            if ([TDUtil isValidString:name]) {
                
                if (dataPriseArray.count>1) {
                    if (i!=dataPriseArray.count-1) {
                        str = [str stringByAppendingFormat:@"%@,",[dic valueForKey:@"name"]];
                    }else{
                        str = [str stringByAppendingFormat:@"%@",[dic valueForKey:@"name"]];
                    }
                }else{
                    str = [str stringByAppendingFormat:@"%@",[dic valueForKey:@"name"]];
                }
            }
        }
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 0)];
        label.font  =SYSTEMFONT(14);
        label.textColor  =FONT_COLOR_BLACK;
        label.numberOfLines  =0;
        label.userInteractionEnabled  =YES;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        
        [TDUtil setLabelMutableText:label content:str lineSpacing:3 headIndent:0];
        height+=HEIGHT(label);
    }
    
    
    
    NSInteger commentCount = cycle.comment.count;
    for (int i=0; i<commentCount; i++) {
        NSArray *commentArray  = [cycle.comment allObjects];
        Comment* comment  = commentArray[i];
        NSString* name  = comment.name;
        NSString* atName = comment.atName;
        NSString* atLabel = @"";
        NSString* suffix  =@":";
        if(atName && ![atName isEqualToString:@""]){
            atLabel = @"回复";
        }
        NSString* content =  comment.content;
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
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 0)];
        [TDUtil setLabelMutableText:label content:str lineSpacing:3 headIndent:0];
        
        float h = POS_Y(label)+5;
        height+=h;
    }
    
    
    if (cycle.share && cycle.share.title) {
        height+=60;
        
        if (cycle.comment.count==0) {
            height -=35;
        }
    }
    
    return height;
//    return 500;
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
        tv.text=@"";
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

#pragma ASIHttpRequest
-(void)requestData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* code = [dic valueForKey:@"code"];
        if ([code integerValue]==0  || [code integerValue]==2) {
            NSMutableArray* arrayData = [dic valueForKey:@"data"];
            
    
            //开始进行圈子数据缓存
            Cycle* cycleModel = [[Cycle alloc]init];
            //移除先前缓存数据
            [cycleModel deleteData];
            //将对象实例添加至新数组中
            NSMutableArray* cycleArray = [[NSMutableArray alloc]init];
            Cycle* cycle;
            NSDictionary* dic;
            for (int i = 0; i<arrayData.count; i++) {
                dic = arrayData[i];
                
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
                        
                        
                        /**
                         *  模拟点赞
                         */
//                        for (int m=0; m<10; m++) {
//                            Likers* l = [[Likers alloc]init];
//                            l.name = [NSString stringWithFormat:@"陈生珠%d",m];
//                            [likersSet addObject:l];
//                        }
                        /**
                         *  模拟点赞
                         */
                        
                    }
                    cycle.likers = likersSet;
                }
                
                [cycle save];
                [cycleArray addObject:cycle];
            }
            
            self.dataArray = cycleArray;
//            
//            if (isRefresh) {
//                self.dataArray = cycleArray;
//            }else{
//                if (self.dataArray) {
//                    for (int i=0; i<cycleArray.count; i++) {
//                        [self.dataArray addObject:cycleArray[i]];
//                    }
//                    [self.tableView reloadData];
//                }
//            }
        
            
            //保存数据
            if (isRefresh) {
                [self.tableView.header endRefreshing];
            }else{
                [self.tableView.footer endRefreshing];
            }
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
//            self.startLoading = NO;
            //移除重新加载数据监听
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadData" object:nil];
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

-(void)refresh
{
    if (isRefresh) {
        [self.tableView.header endRefreshing];
    }else{
        [self.tableView.footer endRefreshing];
    }
    
    [super refresh];
    [self refreshProject];
    
    self.startLoading = YES;
    self.isTransparent = NO;
    
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
        NSString* code = [dic valueForKey:@"code"];
        if ([code integerValue] == 0) {
            NSDictionary* dataDic = [dic valueForKey:@"data"];
            [self.dataArray replaceObjectAtIndex:0 withObject:dataDic];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        self.startLoading = NO;
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
    }
}

-(void)requestFailed:(ASIFormDataRequest*)request
{
    if (isRefresh) {
        [self.tableView.header endRefreshing];
    }else{
        [self.tableView.footer endRefreshing];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //添加监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"reloadData" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishContent:) name:@"publish" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewMessage:) name:@"updateMessageStatus" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishContentNotification:) name:@"publishContent" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //添加监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"publish" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateMessageStatus" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"publishContent" object:nil];
}
@end

