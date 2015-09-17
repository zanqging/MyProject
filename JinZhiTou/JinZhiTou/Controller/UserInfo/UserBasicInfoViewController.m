//
//  UserBasicInfoViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/7.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserBasicInfoViewController.h"
#import "ZHPickView.h"
#import "ModifyViewController.h"
#import "ForgetPassViewController.h"
#import "CustomImagePickerController.h"
@interface UserBasicInfoViewController ()<UITableViewDataSource,UITableViewDelegate,CustomImagePickerControllerDelegate,ASIHTTPRequestDelegate,ZHPickViewDelegate>
{
    HttpUtils * httpUtils;
    NSUserDefaults* data;
    NSMutableArray* typeArray;
    NSMutableArray* positionTypeArray;
    NSMutableArray* settingDataArray;
}
@property(nonatomic,strong)ZHPickView *pickview;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(retain,nonatomic)CustomImagePickerController* customPicker;
@end

@implementation UserBasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"修改资料"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [self.navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=BackColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    httpUtils = [[HttpUtils alloc]init];
    
    data = [NSUserDefaults standardUserDefaults];;
    
    [self loadData];
    
    //加载数据
    [self loadPositionType];
    
}

-(void)loadData
{
    
    settingDataArray = [[NSMutableArray alloc]init];
    NSDictionary* dic;
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"头像" forKey:@"title"];
    [dic setValue:@"0" forKey:@"section"];
    [dic setValue:@"0" forKey:@"subTitle"];
    
    [settingDataArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"姓名" forKey:@"title"];
    [dic setValue:@"1" forKey:@"section"];
    [dic setValue:[data valueForKey:STATIC_USER_NAME] forKey:@"subTitle"];
    
    [settingDataArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"性别" forKey:@"title"];
    [dic setValue:@"2" forKey:@"section"];
    [dic setValue:[data valueForKey:STATIC_USER_GENDER] forKey:@"subTitle"];
    
    [settingDataArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"手机号码" forKey:@"title"];
    [dic setValue:@"0" forKey:@"section"];
    [dic setValue:[data valueForKey:STATIC_USER_DEFAULT_DISPATCH_PHONE] forKey:@"subTitle"];
    
    [settingDataArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"用户类型" forKey:@"title"];
    [dic setValue:@"1" forKey:@"section"];
    [dic setValue:[data valueForKey:STATIC_USER_TYPE] forKey:@"subTitle"];
    
    [settingDataArray addObject:dic];
    
//    dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:@"公司名称" forKey:@"title"];
//    [dic setValue:@"1" forKey:@"section"];
//    [dic setValue:@"查看详情" forKey:@"subTitle"];
//    
//    [settingDataArray addObject:dic];
//    
//    dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:@"职位" forKey:@"title"];
//    [dic setValue:@"1" forKey:@"section"];
//    [dic setValue:@"" forKey:@"subTitle"];
//    
//    [settingDataArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"地区" forKey:@"title"];
    [dic setValue:@"1" forKey:@"section"];
    
    NSString* str = [NSString stringWithFormat:@"%@%@",[data valueForKey:@"province"],[data valueForKey:@"city"]];
    [dic setValue:str forKey:@"subTitle"];
    
    [settingDataArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@"修改密码" forKey:@"title"];
    [dic setValue:@"1" forKey:@"section"];
    [dic setValue:@"" forKey:@"subTitle"];
    
    [settingDataArray addObject:dic];
}


-(void)loadPositionType
{
    [httpUtils getDataFromAPIWithOps:Position_Type postParam:nil type:0 delegate:self sel:@selector(requestPositionType:)];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self takePhoto:nil];
    }else if (indexPath.section == 1) {
        if (indexPath.row==0) {
            ModifyViewController* controller = [[ModifyViewController alloc]init];
            controller.title = @"修改姓名";
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if(indexPath.row == 1){
            _pickview=[[ZHPickView alloc] initPickviewWithPlistName:@"sex" isHaveNavControler:NO];
            _pickview.delegate=self;
            
            [_pickview show];
        }else if(indexPath.row == 2){
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"金指投温馨提示" message:@"无法修改手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            
        }else{
            _pickview=[[ZHPickView alloc]initPickviewWithArray:typeArray isHaveNavControler:NO];
            _pickview.delegate=self;
            
            [_pickview show];
            
        }
        
        
    }else if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ForgetPassViewController * controller =[storyBoard instantiateViewControllerWithIdentifier:@"ModifyPasswordController"];
            controller.type=1;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            _pickview=[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
            _pickview.backgroundColor = ClearColor;
            _pickview.delegate=self;
            
            [_pickview show];
        }
       
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 80;
    }else{
        return 50;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =indexPath.row;
    NSInteger section = indexPath.section;
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"HeaderViewCell";
    
    
    UserBasicInfoTableViewCell * Cell =(UserBasicInfoTableViewCell*) [self switchTableViewCell:TableDataIdentifier tableView:tableView];
    float height = 0;
    if (indexPath.section==0) {
        height =  80;
    }else{
        height = 50;
    }
    if (!Cell) {
        Cell = [[UserBasicInfoTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), height)];
    }
    
    NSInteger index =0;
    if (section==1) {
        index = row+1;
    }else if (section ==2){
        index =row+5;
    }else if (section ==3){
        index =row+8;
    }else{
        Cell.isShowImg = YES;
        UIImage* image = [TDUtil loadContent:STATIC_USER_HEADER_PIC];
        Cell.rightImgView.image = image;
    }
    
    NSDictionary* dic = settingDataArray[index];
    Cell.titleLabel.text = [dic valueForKey:@"title"];
    Cell.rightLabel.text = [dic valueForKey:@"subTitle"];
    Cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return Cell;
}

-(UITableViewCell*)switchTableViewCell:(NSString*)identifier tableView:(UITableView*)tableView
{
    //用TableDataIdentifier标记重用单元格
    UserBasicInfoTableViewCell * Cell =(UserBasicInfoTableViewCell*) [tableView dequeueReusableCellWithIdentifier:identifier];
    
    return Cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}



//*********************************************************照相机功能*****************************************************//


//照相功能

-(void)takePhoto:(NSDictionary*)dic
{
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"上传照片"];
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
    
    NSIndexPath* indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    UserBasicInfoTableViewCell* Cell = (UserBasicInfoTableViewCell*)[self.tableView cellForRowAtIndexPath:indexpath];
    if (Cell) {
        Cell.rightImgView.image = croppedImage;
    }
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
//上传身份证
-(void)uploadUserPic:(NSInteger)id
{
    [httpUtils getDataFromAPIWithOps:UPLOAD_USER_PIC postParam:nil file:STATIC_USER_HEADER_PIC postName:@"file" type:0 delegate:self sel:@selector(requestUploadHeaderImg:)];
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
            
        }
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
}

/**
 *  修改性别
 *
 *  @param request 返回结果
 */
-(void)requestModifyGender:(ASIHTTPRequest *)request{
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

-(void)requestPositionType:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            positionTypeArray = [jsonDic valueForKey:@"data"];
            typeArray = [[NSMutableArray alloc]init];
            NSDictionary *  dic;
            for (int  i=0; i<positionTypeArray.count; i++) {
                dic = positionTypeArray[i];
                [typeArray addObject:[dic valueForKey:@"type_name"]];
            }
        }else{
             [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        }
        
       
    }
}

-(void)requestModifyType:(ASIHTTPRequest *)request{
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


#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    UserBasicInfoTableViewCell * cell=(UserBasicInfoTableViewCell*)[self.tableView cellForRowAtIndexPath:_indexPath];
    cell.rightLabel.text=resultString;
    
    
    NSInteger section = _indexPath.section;
    NSInteger row = _indexPath.row;
    
    if (section ==1 && row ==1) {
        //修改性别
        [data setValue:resultString forKey:STATIC_USER_GENDER];
        int gender = [TDUtil GenderIndex:resultString];
        [httpUtils getDataFromAPIWithOps:UserGender postParam:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",gender] forKey:@"gender"] type:0 delegate:self sel:@selector(requestModifyGender:)];
    }else if (section ==1 && row ==3){
        //修改用户类型
        [data setValue:resultString forKey:STATIC_USER_TYPE];
        NSString* type =@"0";
        NSDictionary *  dic;
        for (int  i=0; i<positionTypeArray.count; i++) {
            dic = positionTypeArray[i];
            if ([[dic valueForKey:@"type_name"] isEqualToString:resultString]) {
                type = [dic valueForKey:@"id"];
            }
        }
        [httpUtils getDataFromAPIWithOps:UserType postParam:[NSDictionary dictionaryWithObject:type forKey:@"position_type"] type:0 delegate:self sel:@selector(requestModifyType:)];
    }else{
        
        NSString* province =(NSString*)pickView.state;
        NSString* city = (NSString*)pickView.city;
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:province,@"province",city,@"city",nil];
        [httpUtils getDataFromAPIWithOps:editprovince postParam:dic type:0 delegate:self sel:@selector(requestUploadHeaderImg:)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (!self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
