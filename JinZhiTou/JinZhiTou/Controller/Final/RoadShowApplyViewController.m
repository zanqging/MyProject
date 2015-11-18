//
//  FinialApplyViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/5.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "RoadShowApplyViewController.h"
#import "QiniuSDK.h"
#import "LoadVideo.h"
#import "FinialKind.h"
#import "PrivacyViewController.h"
#import "CompanyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserTraceViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface RoadShowApplyViewController ()<UIScrollViewDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UITextViewDelegate, UINavigationControllerDelegate>
{
    NSString* videoName;
    
    UIImage* cutImage;
    NSInteger currentIndex;
    
    BOOL isCheck;
    BOOL isVideo;
    NSString* token;
    NSDictionary* dicData;
    UIScrollView* scrollView;
    LoadVideo* loadingVideView;
    NSMutableArray* companyDataArray;
    UITextField* userCompanyTextField;
    UITextView* textView;
}

@end

@implementation RoadShowApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"上传项目"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"项目详情" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self addView];
    
    //获取公司列表
//    [self loadCompanyData];
    
}

//-(void)loadCompanyData
//{
//    [httpUtil getDataFromAPIWithOps:COMPANY_LIST postParam:nil type:0 delegate:self  sel:@selector(requestCompanyData:)];
//}

//-(void)loadCompanyStatus
//{
//    [httpUtil getDataFromAPIWithOps:COMPANY_STATUS postParam:nil type:0 delegate:self  sel:@selector(requestStatusData:)];
//}

//-(void)loadCompanyInfo:(NSInteger)project_id
//{
//    NSString* url = [COMPANY_INFO stringByAppendingFormat:@"%ld/",(long)project_id];
//    [httpUtil getDataFromAPIWithOps:url postParam:nil type:0 delegate:self  sel:@selector(requestCompanyInfoData:)];
//}

-(BOOL)commitRoadShow
{
    
    NSString* desc;
    NSString* company;
    
    company = userCompanyTextField.text;
    if (![TDUtil isValidString:company]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:userCompanyTextField.placeholder];
        return NO;
    }
    
    desc = textView.text;
    if (![TDUtil isValidString:desc]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入公司简介"];
        return NO;
    }
    
    NSDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:desc forKey:@"desc"];
    [dic setValue:company forKey:@"company"];
    [dic setValue:videoName forKey:@"vcr"];
    
    [self.httpUtil getDataFromAPIWithOps:ROAD_SHOW postParam:dic type:0 delegate:self  sel:@selector(requestRoadShow:)];
    self.startLoading  =YES;
    self.isTransparent = YES;
    return YES;
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
//
//-(void)autoSelect:(NSDictionary*)dic
//{
//    dicData= [[dic valueForKey:@"userInfo" ] valueForKey:@"item"];
//    userCompanyTextField.text = [dicData valueForKey:@"company_name"];
//    if (currentIndex != [[dicData valueForKey:@"id"] integerValue]) {
//        currentIndex = [[dicData valueForKey:@"id"] integerValue];
//        //请求公司详情
//        [self loadCompanyInfo:[[dicData valueForKey:@"id"] integerValue]];
//    }
//}

-(void)addView
{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    scrollView.tag =40001;
    scrollView.delegate=self;
    scrollView.bounces = NO;
    scrollView.backgroundColor=BackColor;
    [self.view addSubview:scrollView];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, WIDTH(scrollView), 170)];
    imageView.image=IMAGENAMED(@"luyan");
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [scrollView addSubview:imageView];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, POS_Y(imageView)+70, WIDTH(scrollView)-40, 40)];
    label.alpha = 0.5;
    label.numberOfLines =0;
    label.font = SYSTEMFONT(14);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [scrollView addSubview:label];
    
    NSString* content =@"备注：请您准备好资料，发送至邮箱 kf@jinzht.com 工作人员第一时间联系您!";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(16, 13)];
    
    label.attributedText = attributedString;//ios 6
    
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
    
    //公司
    label = [[UILabel alloc]initWithFrame:CGRectMake(X(label),10, 60, 30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"公司名称";
    label.font = SYSTEMFONT(14);
    [view addSubview:label];
    
    //输入公司信息
    userCompanyTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(view)-25, 30)];
    userCompanyTextField.placeholder = @"请输入公司名称";
    userCompanyTextField.font  =SYSTEMFONT(16);
    userCompanyTextField.tag = 10001;
    userCompanyTextField.delegate = self;
    userCompanyTextField.returnKeyType = UIReturnKeyDone;
    userCompanyTextField.layer.borderColor =ColorTheme.CGColor;
    userCompanyTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    userCompanyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    userCompanyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:userCompanyTextField];
    view.layer.cornerRadius = 5;
    
    UIImageView* lineImageView =[[UIImageView alloc]initWithFrame:CGRectMake(5, POS_Y(userCompanyTextField), WIDTH(view)-10, 1)];
    lineImageView.backgroundColor = BackColor;
    [view addSubview:lineImageView];
    
    textView =[[UITextView alloc]initWithFrame:CGRectMake(5,POS_Y(userCompanyTextField)+5, WIDTH(view)-10, 100)];
    textView.delegate  =self;
    textView.layer.borderWidth=1;
    textView.text=@"请输入项目简介描述";
    textView.returnKeyType = UIReturnKeyDone;
    textView.layer.borderColor=BackColor.CGColor;
    textView.textColor = FONT_COLOR_GRAY;
    [view addSubview:textView];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(view)+10, WIDTH(self.view), 130)];
    view.tag = 30003;
    view.backgroundColor  =WriteColor;
    [scrollView addSubview:view];

    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 20, 20)];
    imgView.userInteractionEnabled = YES;
    imgView.image = IMAGENAMED(@"queren-1");
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(check:)]];
    [view addSubview:imgView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imgView)+10,Y(imgView), WIDTH(scrollView)-POS_X(imgView)-10, 20)];
    label.font = SYSTEMFONT(14);
    label.userInteractionEnabled = YES;
    label.textAlignment = NSTextAlignmentLeft;
    content =@"我已经认真阅读并同意 《项目发起协议》";
    
    attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10, [content length]-10)];
    
    label.attributedText = attributedString;//ios 6
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(protocolAction:)]];
    [view addSubview:label];
    
    
    
    UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(60, POS_Y(label)+20, WIDTH(scrollView)-120, 35)];
    btnAction.layer.cornerRadius =5;
    btnAction.backgroundColor = ColorTheme;
    [btnAction setTitle:@"提交资料" forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(commitRoadShow) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnAction];
    
    scrollView.contentSize = CGSizeMake(WIDTH(scrollView), POS_Y(view)+150);
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
    controller.title = @"返回";
    controller.titleStr =@"项目发起协议";
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)uploadVideo:(id)sender
{
    videoName = [NSString stringWithFormat:@"VCR%@",[TDUtil CurrentDate]];
    videoName = [videoName stringByReplacingOccurrencesOfString:@"-" withString:@""];
    videoName = [videoName stringByReplacingOccurrencesOfString:@" " withString:@""];
    videoName = [videoName stringByReplacingOccurrencesOfString:@":" withString:@""];
    [self.httpUtil getDataFromAPIWithOps:TOKEAN postParam:[NSDictionary dictionaryWithObjectsAndKeys:videoName,@"key", nil] type:0 delegate:self sel:@selector(requestToken:)];
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
                          loadingVideView.isLoaded = YES;
                          loadingVideView.uploadStart = NO;
                          loadingVideView.imgage = IMAGENAMED(@"vido_successful");
                          loadingVideView.isComplete = YES;
                          loadingVideView.doneImage  =cutImage;
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
        NSString* code = [dic valueForKey:@"code"];
        if ([code integerValue] ==0 ) {
            token = [[dic valueForKey:@"data"] valueForKey:@"token"];
            isVideo = YES;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
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
                frame.origin.y +=370;
                frame.origin.x=90;
                frame.size.width = 200;
                
//                autoShowView = [[AutoShowView alloc]initWithFrame:frame];
//                autoShowView.isHidden =YES;
//                autoShowView.title=@"company_name";
//                autoShowView.dataArray = companyDataArray;
//                [scrollView addSubview:autoShowView];
                
            }
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
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
            
            [scrollView setContentSize:CGSizeMake(WIDTH(scrollView), scrollView.contentSize.height+150)];
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
    }
}
-(void)requestRoadShow:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* code = [dic valueForKey:@"code"];
        if ([code integerValue]==0) {
            //进度查看
            double delayInSeconds = 1.0;
            //__block RoadShowDetailViewController* bself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                UserTraceViewController* controller = [[UserTraceViewController alloc]init];
                //来现场
                controller.titleStr = self.navView.title;
                controller.currentSelected = 1000;
                [self.navigationController pushViewController:controller animated:YES];
                
                
            });
        }
         self.startLoading = NO;
         [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}
#pragma UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)tv
{
    NSString* str = @"请输入项目简介描述";
    NSString* text = tv.text;
    if ([text isEqualToString:str]) {
        textView.text=@"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)tv
{
    NSString* str = @"请输入项目简介描述";
    NSString* text = tv.text;
    if ([text isEqualToString:@""]) {
        textView.text=str;
    }
}

- (BOOL)textView:(UITextView *)tv shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [tv resignFirstResponder];
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointMake(0, 500) animated:YES];
//    if (textField.tag ==10001) {
////        autoShowView.isHidden = NO;
//        [scrollView setContentOffset:CGPointMake(0, 500) animated:YES];
//    }else if (textField.tag == 1001){
//        [scrollView setContentOffset:CGPointMake(0, 400) animated:YES];
//    }else if (textField.tag == 1002){
//        [scrollView setContentOffset:CGPointMake(0, 300) animated:YES];
//    }
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
            _imagePicker.videoQuality=UIImagePickerControllerQualityTypeMedium;  //设置视频质量大小
            _imagePicker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
            _imagePicker.videoMaximumDuration = 60;
            
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
//        CMTime time = CMTimeMake(1, 2);
//        CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
        
        CMTime time=CMTimeMakeWithSeconds(2, 10);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
        
        CMTime actualTime;
        CGImageRef cgImage= [generate1 copyCGImageAtTime:time actualTime:&actualTime error:&err];
        if(err){
            NSLog(@"截取视频缩略图时发生错误，错误信息：%@",err.localizedDescription);
            return;
        }
        CMTimeShow(actualTime);
        
        cutImage = [[UIImage alloc] initWithCGImage:cgImage];
        
        CGImageRelease(cgImage);
        
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
