//
//  FinialApplyViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RoadShowApplyViewController.h"
#import "TDUtil.h"
#import "NavView.h"
#import "QiniuSDK.h"
#import "HttpUtils.h"
#import "LoadVideo.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "FinialKind.h"
#import "AutoShowView.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "PrivacyViewController.h"
#import "CompanyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface RoadShowApplyViewController ()<UIScrollViewDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NavView* navView;
    NSString* videoName;
    HttpUtils* httpUtil;
    AutoShowView* autoShowView;
    LoadVideo* loadingVideView;
    
    UIImage* cutImage;
    
    BOOL isCheck;
    BOOL isVideo;
    NSString* token;
    NSDictionary* dicData;
    UIScrollView* scrollView;
    UITextField* userNameTextField;
    UITextField* userPhoneTextField;
    NSMutableArray* companyDataArray;
    UITextField* userCompanyTextField;
}

@end

@implementation RoadShowApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:@"我要路演"];
    navView.titleLable.textColor=WriteColor;
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"路演详情" forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:navView];
    
    //网络初始化
    httpUtil = [[HttpUtils alloc]init];
    
    [self addView];
    
    //获取公司列表
    [self loadCompanyData];
    
    //添加监听
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoSelect:) name:@"autoSelect" object:nil];
}

-(void)loadCompanyData
{
    [httpUtil getDataFromAPIWithOps:COMPANY_LIST postParam:nil type:0 delegate:self  sel:@selector(requestCompanyData:)];
}

-(void)loadCompanyStatus
{
    [httpUtil getDataFromAPIWithOps:COMPANY_STATUS postParam:nil type:0 delegate:self  sel:@selector(requestStatusData:)];
}

-(void)loadCompanyInfo:(NSInteger)project_id
{
    NSString* url = [COMPANY_INFO stringByAppendingFormat:@"%ld/",(long)project_id];
    [httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self  sel:@selector(requestCompanyInfoData:)];
}

-(BOOL)commitRoadShow
{
    
    NSString* userName;
    NSString* userPhone;
    userName = userNameTextField.text;
    userPhone =userPhoneTextField.text;
    if (![TDUtil isValidString:userName]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入联系人姓名" ];
        return NO;
    }
    
    if ([TDUtil isValidString:userPhone]) {
        if (![TDUtil validateMobile:userPhone]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入正确手机号码" ];
            return NO;
        }
       
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入联系人手机号码" ];
        return NO;
    }
    
    
    if (!dicData || [dicData valueForKey:@"dic"]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择公司" ];
    }
    
    
    NSDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:userName forKey:@"contact_name"];
    [dic setValue:userPhone forKey:@"contact_phone"];
    [dic setValue:[dicData valueForKey:@"id"] forKey:@"company"];
    
    [httpUtil getDataFromAPIWithOps:ROAD_SHOW postParam:dic type:0 delegate:self  sel:@selector(requestRoadShow:)];
    return YES;
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)autoSelect:(NSDictionary*)dic
{
    dicData= [[dic valueForKey:@"userInfo" ] valueForKey:@"item"];
    userCompanyTextField.text = [dicData valueForKey:@"company_name"];
    
    //请求公司详情
    [self loadCompanyInfo:[[dicData valueForKey:@"id"] integerValue]];
}

-(void)addView
{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    scrollView.tag =40001;
    scrollView.delegate=self;
    scrollView.bounces = NO;
    scrollView.backgroundColor=BackColor;
    scrollView.contentSize = CGSizeMake(WIDTH(scrollView), HEIGHT(scrollView)+500);
    [self.view addSubview:scrollView];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, WIDTH(scrollView), 170)];
    imageView.image=IMAGENAMED(@"luyan");
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [scrollView addSubview:imageView];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, POS_Y(imageView)+70, WIDTH(scrollView)-40, 40)];
    label.text = @"备注：我们的邮箱是kf@ jinzht.com,您准备好资料，发送至我们邮箱，将有工作人员联系您!";
    label.alpha = 0.5;
    label.numberOfLines =0;
    label.font = SYSTEMFONT(14);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [scrollView addSubview:label];
    
    loadingVideView = [[LoadVideo alloc]initWithFrame:CGRectMake(20, POS_Y(label)+10, WIDTH(scrollView)-40, 170)];
    loadingVideView.isLoaded = NO;
    loadingVideView.isComplete = NO;
    loadingVideView.uploadStart = NO;
    [loadingVideView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadVideo:)]];
    [scrollView addSubview:loadingVideView];
    
    //填写信息
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(20, POS_Y(loadingVideView)+10, WIDTH(self.view)-40, 150)];
    view.tag = 30001;
    view.backgroundColor  =WriteColor;
    [scrollView addSubview:view];
    
    //姓名
    label = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 80, 21)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"联系人姓名";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入姓名
    userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), WIDTH(scrollView)*2/3-40, 21)];
    userNameTextField.tag = 1001;
    userNameTextField.delegate = self;
    userNameTextField.placeholder = @"请输入联系人姓名";
    userNameTextField.font  =SYSTEMFONT(14);
    [view addSubview:userNameTextField];
    
    UIImageView* lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(userNameTextField), WIDTH(view), 1)];
    lineImgView.backgroundColor = BackColor;
    [view addSubview:lineImgView];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(X(label), POS_Y(label)+10, WIDTH(label), 21)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"联系人手机";
    label.font = SYSTEMFONT(14);
    [view addSubview:label];
    
    //输入职位
    userPhoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), WIDTH(userNameTextField), 21)];
    userPhoneTextField.tag = 1002;
    userPhoneTextField.font  =SYSTEMFONT(14);
    userPhoneTextField.placeholder = @"请输入联系人手机";
    userPhoneTextField.delegate = self;
    [view addSubview:userPhoneTextField];
    
    lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(userPhoneTextField), WIDTH(view), 1)];
    lineImgView.backgroundColor = BackColor;
    [view addSubview:lineImgView];
    
    //公司
    label = [[UILabel alloc]initWithFrame:CGRectMake(X(label), POS_Y(label)+10, WIDTH(label), 21)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"选择公司";
    label.font = SYSTEMFONT(14);
    [view addSubview:label];
    
    
    
    //输入公司信息
    userCompanyTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), WIDTH(userPhoneTextField)-25, 21)];
    userCompanyTextField.placeholder = @"请选择或填写公司";
    userCompanyTextField.font  =SYSTEMFONT(14);
    userCompanyTextField.tag = 10001;
    userCompanyTextField.delegate = self;
    [view addSubview:userCompanyTextField];
    
    lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, POS_Y(userCompanyTextField), WIDTH(view), 1)];
    lineImgView.backgroundColor = BackColor;
    [view addSubview:lineImgView];
    
    UITapGestureRecognizer* recognizer =[[ UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doAction:)];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(view)-30, Y(label), 20, 20)];
    imageView.image = IMAGENAMED(@"tianjia");
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:recognizer];
    [view addSubview:imageView];
    view.layer.cornerRadius = 5;
    
    //投资信息
    view = [[UIView alloc]initWithFrame:CGRectMake(20, POS_Y(view)+10, WIDTH(self.view)-40, 110)];
    view.tag = 30002;
    view.alpha = 0;
    view.backgroundColor  =WriteColor;
    [scrollView addSubview:view];
    

    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 70, 21)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"所属行业";
    label.font = SYSTEMFONT(14);
    [view addSubview:label];
    
    //姓名
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), WIDTH(scrollView)*2/3-20, 21)];
    label.tag =20001;
    label.font = SYSTEMFONT(14);
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label), WIDTH(scrollView)*1/3, 21)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"公司注册地";
    label.font = SYSTEMFONT(14);
    [view addSubview:label];
    

    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), WIDTH(scrollView)*2/3-20, 21)];
    label.textAlignment = NSTextAlignmentLeft;
    label.tag =20002;
    label.font = SYSTEMFONT(14);
    [view addSubview:label];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(label)+10, WIDTH(scrollView)*1/3, 21)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"公司状态";
    label.font = SYSTEMFONT(14);
    [view addSubview:label];
    

    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label), Y(label), WIDTH(scrollView)*2/3-20, 21)];
    label.tag =20003;
    label.font = SYSTEMFONT(14);
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    view.layer.cornerRadius = 5;
    
    UIView* v = [scrollView viewWithTag:30001];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(v), WIDTH(view), 100)];
    view.tag = 30003;
    view.backgroundColor  =BackColor;
    [scrollView addSubview:view];

    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 25, 10, 10)];
    imgView.image = IMAGENAMED(@"queren-1");
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(check:)]];
    [view addSubview:imgView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10,20, WIDTH(scrollView)-POS_X(imgView)-10, 20)];
    label.font = SYSTEMFONT(12);
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"我已经认真阅读并同意 《项目发起协议》";
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(protocolAction:)]];
    [view addSubview:label];
    
    
    
    UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(60, POS_Y(label)+20, WIDTH(scrollView)-120, 35)];
    btnAction.layer.cornerRadius =5;
    btnAction.backgroundColor = ColorTheme;
    [btnAction setTitle:@"提交资料" forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(commitRoadShow) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnAction];
}

-(void)check:(id)sender
{
    UIImageView* imgView = (UIImageView*)[sender view];
    
    NSString* fileName =@"";
    if (isCheck) {
        fileName = @"queren-1";
        isCheck = NO;
    }else{
        fileName = @"queren";
        isCheck = YES;
    }
    imgView.image = IMAGENAMED(fileName);
}

-(void)protocolAction:(id)sender
{
    PrivacyViewController* controller = [[PrivacyViewController alloc]init];
    controller.serverUrl = aboutroadshow;
    controller.title = navView.title;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)uploadVideo:(id)sender
{
    videoName = [NSString stringWithFormat:@"VCR%@",[TDUtil CurrentDate]];
    videoName = [videoName stringByReplacingOccurrencesOfString:@"-" withString:@""];
    videoName = [videoName stringByReplacingOccurrencesOfString:@" " withString:@""];
    videoName = [videoName stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSLog(@"%@",videoName);
    [httpUtil getDataFromAPIWithOps:TOKEAN postParam:[NSDictionary dictionaryWithObjectsAndKeys:videoName,@"key", nil] type:0 delegate:self sel:@selector(requestToken:)];
}
-(void)doAction:(UITapGestureRecognizer*)recognizer
{
    CompanyViewController* controller  = [[CompanyViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)uploadQiNiuVedio:(NSURL*)url
{
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    QNUploadOption* options =[[QNUploadOption alloc]initWithProgessHandler:^(NSString* key,float progress){
        NSLog(@"%f",progress);
        loadingVideView.progress =progress;
    }];
    NSData *data =[NSData dataWithContentsOfURL:url];
    [upManager putData:data key:videoName token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"%@", info);
                  NSLog(@"返回:%@",resp);
                  if (resp!=nil) {
                      NSString* status = [resp valueForKey:@"status"];
                      if ([status integerValue] ==0 ) {
                          //NSDictionary* dic = [resp valueForKey:@"data"];
                          
                          [[DialogUtil sharedInstance]showDlg:self.view textOnly:[resp valueForKey:@"msg"]];
                          
                          loadingVideView.isLoaded = NO;
                          loadingVideView.uploadStart = NO;
                          loadingVideView.imgage = IMAGENAMED(@"loading");
                          loadingVideView.isComplete = YES;
                      }
                  }
              } option:options];
}
#pragma ASIHttpRequest


-(void)requestToken:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue] ==0 ) {
            token = [dic valueForKey:@"data"];
            isVideo = YES;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
    }
}

-(void)requestCompanyData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue] ==0 ) {
            companyDataArray = [dic valueForKey:@"data"];
            if (companyDataArray.count>0) {
                UIView* view = (UIView*)[scrollView viewWithTag:30001];
                view = [view viewWithTag:10001];
                CGRect frame = view.frame;
                frame.origin.y +=532;
                frame.origin.x=90;
                frame.size.width = 200;
                
                autoShowView = [[AutoShowView alloc]initWithFrame:frame];
                autoShowView.isHidden =YES;
                autoShowView.title=@"company_name";
                autoShowView.dataArray = companyDataArray;
                [scrollView addSubview:autoShowView];
                
            }
        }
    }
}

-(void)requestStatusData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
     NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            
        }
    }
}

-(void)requestAddCompany:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
     NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            
        }
    }
}


-(void)requestCompanyInfoData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            NSDictionary* dataDic = [dic valueForKey:@"data"];
            UIView* view = [scrollView viewWithTag:30002];
            UILabel* label = (UILabel*)[view viewWithTag:20001];
            NSArray* array =[dataDic valueForKey:@"industry_type"];
            NSString* str=@"";
            for (int i=0; i<array.count; i++) {
                str  =[str stringByAppendingFormat:@"%@",array[i]];
            }
            label.text = str;
            
            str = [[dataDic valueForKey:@"province"] stringByAppendingString:[dataDic valueForKey:@"city"]];
            label = (UILabel*)[view viewWithTag:20002];
            
            label.text =str;
            label = (UILabel*)[view viewWithTag:20003];
            label.text = [dataDic valueForKey:@"company_status"];
            UIView* v3 = (UIView*)[scrollView viewWithTag:30003];
            CGRect frame = v3.frame;
            frame.origin.y = POS_Y(view);
            
            [UIView animateWithDuration:1 animations:^(void){
                [view setAlpha:1];
                [v3 setFrame:frame];
            }];
        }
    }
}
-(void)requestRoadShow:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            [self back:nil];
            
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
        }
    }
}

-(void)requestProtocol:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
        
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}

#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag ==10001) {
        autoShowView.isHidden = NO;
        [textField resignFirstResponder];
    }
}

-(void)resignKeyboard
{
    //收起键盘
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidChange:(id)sender
{
    
}

//*********************************************************照相机功能*****************************************************//

#pragma mark - UIImagePickerController代理方法
//完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//如果是拍照
        UIImage *image;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (self.imagePicker.allowsEditing) {
            image=[info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image=[info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){//如果是录制视频
        NSLog(@"video...");
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 私有方法
-(UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker=[[UIImagePickerController alloc]init];
        _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置image picker的来源，这里设置为摄像头
        _imagePicker.cameraDevice=UIImagePickerControllerCameraDeviceRear;//设置使用哪个摄像头，这里设置为后置摄像头
        if (isVideo) {
            _imagePicker.mediaTypes=@[(NSString *)kUTTypeMovie];
            _imagePicker.videoQuality=UIImagePickerControllerQualityTypeIFrame1280x720;
            _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
            
        }else{
            _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
        }
        _imagePicker.allowsEditing=YES;//允许编辑
        _imagePicker.delegate=self;//设置代理，检测操作
    }
    return _imagePicker;
}

//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        //录制完之后自动播放
        NSURL *url=[NSURL fileURLWithPath:videoPath];
        AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:url options:nil];
        AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
        generate1.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(1, 2);
        CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
        cutImage = [[UIImage alloc] initWithCGImage:oneRef];
        
        
        loadingVideView.isLoaded = YES;
        loadingVideView.isComplete = NO;
        loadingVideView.uploadStart = YES;
        //上传视频
        [self uploadQiNiuVedio:url];
       // _moviePlayerViewController=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
        //[self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
    }
}

//*********************************************************照相机功能结束*****************************************************//
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
