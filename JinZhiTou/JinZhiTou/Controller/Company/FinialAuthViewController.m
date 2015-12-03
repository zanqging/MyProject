//
//  FinialAuthViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialAuthViewController.h"
#import "PhotoAdd.h"
#import "AutoShowView.h"
#import "SwitchSelect.h"
#import "PECropViewController.h"
#import "PrivacyViewController.h"
#import "CompanyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UserInfoAuthController.h"
#import "UserInfoAuthController.h"
#import "FinialProctoTableViewCell.h"

@interface FinialAuthViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,CustomImagePickerControllerDelegate,UITextFieldDelegate>
{
    
    BOOL isUploadID;
    BOOL isCheck;
    
    UITextField* nameTextField;
    UITextField* positionTextField;
    UITextField* companyTextField;
    NSDictionary* companySelected;
    NSDictionary* industorySelected;
    NSDictionary* foundationSizeSelected;
    
    NSMutableArray* array;
    NSInteger currentPhotoTag;
    UIScrollView* scrollViewPerson;
    
    NSMutableArray* heightsArray;
}
@end

@implementation FinialAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //网络初始化
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"投资人认证"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:self.titleStr forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];
    
    [self addPersonalView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takePhoto:) name:@"takePhoto" object:nil];
    //获取投资人认证协议条件
    [self loadData];
    
    //初始化协议书组
    array = [[NSMutableArray alloc]init];
    heightsArray  =[[NSMutableArray alloc]init];
    
    isCheck = YES;

}


//加载协议
-(void)loadData
{
    self.startLoading  = YES;
    [self.httpUtil getDataFromAPIWithOps:@"auth/" type:0 delegate:self sel:@selector(requestInvestPro:) method:@"GET"];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addPersonalView
{
    scrollViewPerson = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    scrollViewPerson.tag =40001;
    scrollViewPerson.delegate=self;
    scrollViewPerson.bounces = NO;
    scrollViewPerson.backgroundColor=BackColor;
    float height =0;
    if (self.type==0) {
        height = HEIGHT(scrollViewPerson)+370;
    }else{
        height=HEIGHT(scrollViewPerson)+420;
    }
    scrollViewPerson.contentSize = CGSizeMake(WIDTH(scrollViewPerson),height);
    [self.view addSubview:scrollViewPerson];
    
    
    PhotoAdd* IDPhotoAddView = [[PhotoAdd alloc]initWithFrame:CGRectMake(10, 10, WIDTH(scrollViewPerson)-20, 150)];
    IDPhotoAddView.tag = 20003;
    IDPhotoAddView.title = @"上传身份证";
    [scrollViewPerson addSubview:IDPhotoAddView];
    UIView* view;
    UILabel* label;
    if (self.type!=0) {
        //填写信息
        view = [[UIView alloc]initWithFrame:CGRectMake(10, POS_Y(IDPhotoAddView)+10, WIDTH(self.view)-20, 100)];
        view.tag = 30001;
        view.layer.cornerRadius=5;
        view.backgroundColor  =WriteColor;
        [scrollViewPerson addSubview:view];
        
        //姓名
        label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH(scrollViewPerson)*1/4, 30)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"机构名称";
        label.font = SYSTEMFONT(16);
        [view addSubview:label];
        
        //输入姓名
        nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollViewPerson)*2/3-20, 30)];
        nameTextField.font  =SYSTEMFONT(16);
        nameTextField.tag = 500001;
        nameTextField.delegate = self;
        nameTextField.placeholder = @"请输入机构名称";
        nameTextField.returnKeyType = UIReturnKeyDone;
        nameTextField.layer.borderColor =ColorTheme.CGColor;
        nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [view addSubview:nameTextField];
        
        UIImageView* lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(nameTextField), WIDTH(view), 1)];
        lineView.backgroundColor  =BackColor;
        [view addSubview:lineView];
        
        //职位
        label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(label), 30)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"法人姓名";
        label.font = SYSTEMFONT(16);
        [view addSubview:label];
        
        //输入职位
        positionTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(nameTextField), 30)];
        positionTextField.tag = 500002;
        positionTextField.delegate = self;
        positionTextField.font  =SYSTEMFONT(16);
        positionTextField.placeholder = @"请输入机构法人姓名";
        positionTextField.returnKeyType = UIReturnKeyDone;
        positionTextField.layer.borderColor =ColorTheme.CGColor;
        positionTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        positionTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        positionTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [view addSubview:positionTextField];
        
        lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(positionTextField), WIDTH(view), 1)];
        lineView.backgroundColor  =BackColor;
        [view addSubview:lineView];
        
        //header
        view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(view)+10, WIDTH(scrollViewPerson), 30)];
        view.tag =30002;
        //头部
        label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, WIDTH(scrollViewPerson)-40, 20)];
        label.text = @"符合以下条件之一的机构投资者，可多选";
        label.font  =SYSTEMFONT(14);
        [view addSubview:label];
        [scrollViewPerson addSubview:view];
    }else{
        //header
        view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(IDPhotoAddView)+10, WIDTH(scrollViewPerson), 30)];
        view.tag =30002;
        //头部
        label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, WIDTH(scrollViewPerson)-40, 20)];
        label.text = @"符合以下条件之一的自然人投资者，可多选";
        label.font  =SYSTEMFONT(14);
        [view addSubview:label];
        [scrollViewPerson addSubview:view];
    }
    
    //tableView
    CGRect rect=CGRectMake(0, POS_Y(view)+10, WIDTH(scrollViewPerson),264);
    self.tableView=[[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.bounces=NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollEnabled  =NO;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    [scrollViewPerson addSubview:self.tableView];
}

-(void)protocolAction:(id)sender
{
    PrivacyViewController* controller = [[PrivacyViewController alloc]init];
    controller.serverUrl = risk;
    controller.title = @"返回";
    controller.titleStr =@"投资风险提示书";
    [self.navigationController pushViewController:controller animated:YES];
}



-(void)doAddCompanyAction:(UITapGestureRecognizer*)recognizer
{
    CompanyViewController* controller  = [[CompanyViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)check:(id)sender
{
    UIImageView* imgView;
    if (selectedIndex==0) {
       imgView = (UIImageView*)[scrollViewPerson viewWithTag:700001];
       
    }
    
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
-(BOOL)commitData
{
//    if (!isUploadID) {
//        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请先上传身份证" ];
//        return NO;
//    }
    NSString* userName;
    NSString* company;
    
    userName = nameTextField.text;
    company = positionTextField.text;
    
    if (self.type == 1) {
        if (![TDUtil isValidString:userName]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入姓名" ];
            return NO;
        }
        
        
        
        if (![TDUtil isValidString:company]) {
            
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入公司" ];
            return NO;
        }
    }
    
    
    
    if (!array || array.count<=0) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择投资人类型" ];
        return NO;
    }
    
    if (!isCheck) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择已阅读投资人协议" ];
        return NO;
    }
    
    
    NSString* str=@"";
    for (int i =0; i<array.count; i++) {
        if(i!=array.count-1){
            str = [str stringByAppendingFormat:@"%@,",[array[i] valueForKey:@"key"]];
        }else{
            str = [str stringByAppendingFormat:@"%@",[array[i] valueForKey:@"key"]];
        }
        
    }
    
    
//    NSDictionary* dic =[[NSMutableDictionary alloc]init];
//    [dic setValue:userName forKey:@"name"];
//    [dic setValue:userType forKey:@"position"];
//    [dic setValue:str forKey:@"qualification"];
//    [dic setValue:company forKey:@"company"];
//    [httpUtils getDataFromAPIWithOps:AUTHENTICATE postParam:dic type:0 delegate:self sel:@selector(requestAuthenicate:)];
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc]init];
    [dataDic setValue:str forKey:@"qualification"];
    if (self.type==1) {
        [dataDic setValue:userName forKey:@"legalperson"];
        [dataDic setValue:company forKey:@"institute"];
    }
    
//    [self.httpUtil getDataFromAPIWithOps:@"auth/" postParam:dataDic type:0 delegate:self sel:@selector(requestUserInfo:)];
    
//    [self.httpUtil getDataFromAPIWithOps:@"auth/" postParam:dataDic file:STATIC_USER_DEFAULT_ID_PIC postName:@"file" type:0 delegate:self sel:@selector(requestUserInfo:)];
    
    [self.httpUtil getDataFromAPIWithOps:@"auth/" postParam:dataDic file:STATIC_USER_DEFAULT_ID_PIC postName:@"file" type:0 delegate:self sel:@selector(requestUserInfo:)];
//    NSMutableArray* arr = [NSMutableArray arrayWithObjects:STATIC_USER_DEFAULT_ID_PIC, nil];
//     [self.httpUtil getDataFromAPIWithOps:@"auth/" postParam:dataDic files:arr postName:@"file" type:0 delegate:self sel:@selector(requestUserInfo:)];
    self.startLoading = YES;
    self.isTransparent  =YES;
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"FinialProctoTableViewCell";
    //用TableDataIdentifier标记重用单元格
    FinialProctoTableViewCell* Cell=(FinialProctoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    //如果单元格未创建，则需要新建
    if (Cell==nil) {
        CGRect frame=self.view.frame;
        frame.size.height=60;
        Cell=[[FinialProctoTableViewCell alloc]initWithFrame:frame];
    }
    NSInteger row = indexPath.row;
    row++;
    
    NSString* str = [NSString stringWithFormat:@"renzheng%ld 1",(long)row];
    NSDictionary* dic =[self.dataArray objectAtIndex:row-1];
    
    //填充行的详细内容
    [Cell setImageWithName:str setText:[dic valueForKey:@"value"]];
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //设置是否已经选择
    if ([array containsObject:dic]) {
        Cell.isSelected = YES;
    }
    return Cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FinialProctoTableViewCell* Cell = (FinialProctoTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    
    NSDictionary* dic = self.dataArray[indexPath.row];
    if ([array containsObject:dic]) {
        [array removeObject:dic];
        Cell.isSelected = NO;
    }else{
        [array addObject:dic];
        Cell.isSelected = YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =indexPath.row;
    if (self.dataArray.count>0) {
        NSDictionary* dic =[self.dataArray objectAtIndex:row];
        
        NSString* str = [dic valueForKey:@"value"];
        if(str){
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, WIDTH(self.view)-100, 50)];
            label.numberOfLines = 0 ;
            label.font = SYSTEMFONT(14);
            label.textColor =FONT_COLOR_GRAY;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            
            [TDUtil setLabelMutableText:label content:str lineSpacing:3 headIndent:0];
            
            heightsArray[row] =[NSString stringWithFormat:@"%f", POS_Y(label)+10];
            
            if (row==self.dataArray.count-1) {
                float height;
                for (int i = 0 ; i<self.dataArray.count;i++) {
                    height += [heightsArray[i] floatValue];
                }
                
                CGRect frame =self.tableView.frame;
                frame.size.height = height;
                [self.tableView setFrame:frame];
                UIView* view =[scrollViewPerson viewWithTag:30003];
                if (!view) {
                    //footer
                    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(self.tableView)+10, WIDTH(scrollViewPerson), 50)];
                    view.tag =30003;
                    //头部
                    label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, WIDTH(scrollViewPerson)-40, 40)];
                    label.text = @"备注：以上内容请参考《私募股权基金监督管理暂行办法（试行）》合格投资人规定";
                    label.numberOfLines = 0;
                    label.font  =SYSTEMFONT(14);
                    label.lineBreakMode  =NSLineBreakByWordWrapping;
                    [view addSubview:label];
                    
                    [scrollViewPerson addSubview:view];
                    
                    
                    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(40, POS_Y(view)+7, WIDTH(scrollViewPerson)-40, 20)];
                    label.font = SYSTEMFONT(12);
                    label.userInteractionEnabled = YES;
                    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(protocolAction:)]];
                    label.textAlignment = NSTextAlignmentLeft;
                    NSString* content =@"我已经认真阅读并同意 《投资风险提示书》";
                    
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10, [content length]-10)];
                    
                    label.attributedText = attributedString;//ios 6
                    [scrollViewPerson addSubview:label];
                    
                    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, POS_Y(view)+10, 15, 15)];
                    imgView.image = IMAGENAMED(@"queren");
                    imgView.tag  =700001;
                    imgView.userInteractionEnabled = YES;
                    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(check:)]];
                    [scrollViewPerson addSubview:imgView];
                    
                    
                    
                    UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(60, POS_Y(label)+20, WIDTH(scrollViewPerson)-120, 35)];
                    btnAction.layer.cornerRadius =5;
                    btnAction.backgroundColor = AppColorTheme;
                    [btnAction setTitle:@"提交资料" forState:UIControlStateNormal];
                    [btnAction addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
                    [scrollViewPerson addSubview:btnAction];
                }
            }
            return POS_Y(label)+10;
        }else{
            return 0;
        }
        
    }
    
    
    return 0;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}



-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray=dataArray;
    [self.tableView reloadData];
}

//*********************************************************照相机功能*****************************************************//


//照相功能

-(void)takePhoto:(NSDictionary*)dic
{
    NSInteger index = [[[dic valueForKey:@"userInfo"] valueForKey:@"index"] integerValue];
    currentPhotoTag=index;
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
    PhotoAdd* photoView ;
    if (selectedIndex==0) {
        //保存头像
       [TDUtil saveCameraPicture:croppedImage fileName:STATIC_USER_DEFAULT_ID_PIC];
        
       photoView =(PhotoAdd*)[scrollViewPerson viewWithTag:currentPhotoTag];
    }
    
    photoView.image = croppedImage;
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

//*********************************************************网络请求开始*****************************************************//
-(void)requestInvestPro:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    
    if (dic!=nil) {
        NSString* code =[dic valueForKey:@"code"];
        if ([code integerValue]==0) {
            NSMutableArray* data = [[dic valueForKey:@"data"] valueForKey:@"qualification"];
            if (data!=nil && data.count>0) {
                self.dataArray = data;
                self.startLoading = NO;
            }
            
        }
    }
}


-(void)requestUserInfo:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    if (dic!=nil) {
        NSString* code =[dic valueForKey:@"code"];
        if ([code integerValue]==0) {
            //进度查看
            double delayInSeconds = 1.0;
            //__block RoadShowDetailViewController* bself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                UserInfoAuthController* controller = [[UserInfoAuthController alloc]init];
                controller.type=1;
                [self.navigationController pushViewController:controller animated:YES];
                [self removeFromParentViewController];
            });
            
            NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
            [dataStore setValue:@"None" forKey:@"auth"];
            
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
        }
        self.startLoading  = NO;
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}
//*********************************************************网络请求结束*****************************************************//

//*********************************************************UiTextField *****************************************************//
#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (selectedIndex ==0) {
        [scrollViewPerson setContentOffset:CGPointMake(0, 150) animated:YES];
    }
    
    
}

-(void)resignKeyboard
{
    //收起键盘
    //收起键盘
    UIView* view = [scrollViewPerson viewWithTag:30001];
    for (UIView * v in view.subviews){
        if (v.class ==  UITextField.class) {
            [(UITextField*)v resignFirstResponder];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (selectedIndex ==0) {
        //[scrollViewPerson setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}

-(void)textFieldDidChange:(id)sender
{
    
}
//*********************************************************UITextField*****************************************************//

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (!self.navigationController.interactivePopGestureRecognizer.enabled) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
