//
//  UserInfoViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/6.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserInfoViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "ShareView.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "LoadingView.h"
#import "LoadingUtil.h"
#import "GlobalDefine.h"
#import "UserInfoHeader.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "PECropViewController.h"
#import "UserInfoTableViewCell.h"
#import "UserInfoSettingViewController.h"
#import "CustomImagePickerController.h"
@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,CustomImagePickerControllerDelegate>
{
    HttpUtils* httpUtils;
}
@property(retain,nonatomic)CustomImagePickerController* customPicker;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=0;
    [self.navView setTitle:@"个人中心"];
    self.navView.titleLable.textColor=WriteColor;
    [self.view addSubview:self.navView];
    NSUserDefaults* data = [NSUserDefaults standardUserDefaults];
    BOOL isAmious = [[data valueForKey:@"isAnimous"]boolValue];
    if (!isAmious) {
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view)-40, HEIGHT(self.view)-kTopBarHeight-kStatusBarHeight)];
        self.tableView.bounces=YES;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.allowsSelection=YES;
        self.tableView.delaysContentTouches=NO;
        self.tableView.backgroundColor=WriteColor;
        self.tableView.showsVerticalScrollIndicator=NO;
        self.tableView.showsHorizontalScrollIndicator=NO;
        self.tableView.contentSize = CGSizeMake(WIDTH(self.view), HEIGHT(self.view)+220);
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        
        [self.view addSubview:self.tableView];
        
        UserInfoHeader* headerView =[[UserInfoHeader alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), 200)];
        [self.tableView setTableHeaderView:headerView];
        
        UIView* footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 50)];
        UIImageView* imgView = [[UIImageView alloc]initWithImage:IMAGENAMED(@"gerenzhongxin-8")];
        imgView.frame = CGRectMake(WIDTH(footView)-30, HEIGHT(footView)/2-5, 20, 20);
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [footView addSubview:imgView];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setting:)]];
        [self.tableView setTableFooterView:footView];
        
        [self loadData];
        //修改个人资料
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modifyUserInfo:) name:@"modifyUserInfo" object:nil];
        //发送短信
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upLoad:) name:@"upLoad" object:nil];
    }else{
        self.isAmious = YES;
    }
}

-(void)upLoad:(id)sender
{
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"上传头像"];
    [self takePhoto:nil];
}

//上传身份证
-(void)uploadUserPic:(NSInteger)id
{
    if(!httpUtils){
        httpUtils = [[HttpUtils alloc]init];
    }
    [httpUtils getDataFromAPIWithOps:UPLOAD_USER_PIC postParam:nil file:STATIC_USER_HEADER_PIC postName:@"file" type:0 delegate:self sel:@selector(requestUploadHeaderImg:)];
}


-(void)modifyUserInfo:(id)sender
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"ModifyUserInfoViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)setting:(id)sender
{
    UserInfoSettingViewController* controller = [[UserInfoSettingViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)loadData
{
    NSMutableArray* array=[[NSMutableArray alloc]init];
    NSMutableDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"1" forKey:@"index"];
    [dic setValue:@"与我相关" forKey:@"title"];
    [dic setValue:@"yes" forKey:@"isBedEnable"];
    [dic setValue:@"About" forKey:@"imageName"];
    [array addObject:dic];
    
    dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"2" forKey:@"index"];
    [dic setValue:@"我的收藏" forKey:@"title"];
    [dic setValue:@"false" forKey:@"isBedEnable"];
    [dic setValue:@"Collect" forKey:@"imageName"];
    [array addObject:dic];
    
    dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"3" forKey:@"index"];
    [dic setValue:@"我的投融资" forKey:@"title"];
    [dic setValue:@"false" forKey:@"isBedEnable"];
    [dic setValue:@"Authenticate" forKey:@"imageName"];
    [array addObject:dic];
    
    dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"4" forKey:@"index"];
    [dic setValue:@"投资人认证" forKey:@"title"];
    [dic setValue:@"false" forKey:@"isBedEnable"];
    [dic setValue:@"Investment" forKey:@"imageName"];
    [array addObject:dic];
    
    dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"5" forKey:@"index"];
    [dic setValue:@"邀请好友" forKey:@"title"];
    [dic setValue:@"false" forKey:@"isBedEnable"];
    [dic setValue:@"Invite" forKey:@"imageName"];
    [array addObject:dic];
    
    dic =[[NSMutableDictionary alloc]init];
    [dic setValue:@"6" forKey:@"index"];
    [dic setValue:@"关于我们" forKey:@"title"];
    [dic setValue:@"false" forKey:@"isBedEnable"];
    [dic setValue:@"Related" forKey:@"imageName"];
    [array addObject:dic];
    
    self.dataArray=array;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSString* indexStr = [self.dataArray[indexPath.row] valueForKey:@"index"];
    if (indexStr.integerValue == 5) {
        [self ShareAction];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userInfoAction" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:indexStr,@"index",nil]];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"UserInfoViewCell";
    //用TableDataIdentifier标记重用单元格
    UserInfoTableViewCell* cell=(UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (cell==nil) {
        cell = [[UserInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(tableView), 50)];
    }

    NSInteger row =indexPath.row;
    NSDictionary* dic = self.dataArray[row];
    [cell setImageWithName:[dic valueForKey:@"imageName"] setTitle:[dic valueForKey:@"title"]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(void)setDataArray:(NSArray *)dataArray
{
    self->_dataArray = dataArray;
    [self.tableView reloadData];
}

-(void)setIsAmious:(BOOL)isAmious
{
    self->_isAmious = isAmious;
    if (self->_isAmious) {
        UIView* view =[[UIView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, WIDTH(self.view), HEIGHT(self.view)-kTopBarHeight-kStatusBarHeight)];
        view.tag =10001;
        //背景
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:view.bounds];
        imgView.image = IMAGENAMED(@"kuang");
        imgView.backgroundColor =WriteColor;
        [view addSubview:imgView];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-80, HEIGHT(view)/2-100, 160, 160)];
        imgView.image = IMAGENAMED(@"yun");
        [view addSubview:imgView];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-60, HEIGHT(view)/2-120, 140, 140)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = IMAGENAMED(@"diqiu-1");
        [view addSubview:imgView];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-60, HEIGHT(view)/2-60, 80, 80)];
        imgView.image = IMAGENAMED(@"mail-1");
        [view addSubview:imgView];
        
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)/2-30, HEIGHT(view)/2+10, 100, 50)];
        imgView.image = IMAGENAMED(@"anniu");
        [view addSubview:imgView];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(imgView)+10, WIDTH(view), 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = ColorTheme;
        label.text =@"去注册，开启互联金融新纪元";
        [view addSubview:label];
        
        UIButton* btnAction = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2-60, POS_Y(label)+20, 120, 40)];
        btnAction.layer.cornerRadius =20;
        btnAction.layer.borderColor =ColorTheme.CGColor;
        btnAction.layer.borderWidth =1;
        btnAction.backgroundColor = WriteColor;
        [btnAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnAction setTitle:@"去注册" forState:UIControlStateNormal];
        [btnAction setTitleColor:ColorTheme forState:UIControlStateNormal];
        
        [view addSubview:btnAction];
        [self.view addSubview:view];
    }else{
        UIView* view =[self.view viewWithTag:10001];
        [view removeFromSuperview];
    }
}

-(void)btnAction:(id)sender
{
    UIStoryboard* storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController* controller = [storyBoard instantiateViewControllerWithIdentifier:@"LoginController"];
    [self.navigationController pushViewController:controller animated:YES];
    
    for(UIViewController* c in self.navigationController.childViewControllers){
        if (![c isKindOfClass:controller.class]) {
            [c removeFromParentViewController];
        }
    }
}

-(void)ShareAction
{
    UIWindow* window =[UIApplication sharedApplication].windows[0];
    ShareView* shareView =[[ShareView alloc]initWithFrame:window.frame];
    shareView.type = 1;
    [window addSubview:shareView];
}

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
    [TDUtil saveCameraPicture:croppedImage fileName:STATIC_USER_HEADER_PIC];
    
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



//*********************************************************照相机功能结束*****************************************************//


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
            
        }
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"userInfoAction" object:nil];
}
@end
