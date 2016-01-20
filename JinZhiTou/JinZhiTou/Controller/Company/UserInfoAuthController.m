//
//  FinialAuthViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserInfoAuthController.h"
#import "ZHPickView.h"
#import "MWPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWeiXinPhotoContainerView.h"
@interface UserInfoAuthController ()<UIScrollViewDelegate,UITextFieldDelegate,ZHPickViewDelegate,MWPhotoBrowserDelegate>
{
    UITextField* IDTextField;
    UIScrollView* scrollView;
    UITextField* nameTextField;
    UITextField* positionTextField;
    UITextField* companyTextField;
    UITextField* addressTextField;;
}
@end

@implementation UserInfoAuthController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络初始化
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"认证信息"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"首页" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self addPersonalView];
    
    [self loadData];
}

-(void)back:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadData
{
    self.startLoading  =YES;
    [self.httpUtil getDataFromAPIWithOps:USERINFO postParam:nil type:0 delegate:self sel:@selector(requestFinished:)];
}

-(void)addPersonalView
{
    //缓存数据
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    scrollView.tag =40001;
    scrollView.delegate=self;
    scrollView.bounces = NO;
    scrollView.backgroundColor=BackColor;
    scrollView.contentSize = CGSizeMake(WIDTH(scrollView), HEIGHT(scrollView));
    [self.view addSubview:scrollView];
    UIView* view;
    //身份证
    //填写信息
    view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(self.view)-20, 150)];
    view.tag = 30001;
    view.layer.cornerRadius=5;
    view.backgroundColor  =WriteColor;
    [scrollView addSubview:view];
    
    UIImageView* imgView =[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, WIDTH(view)-40, HEIGHT(view)-20)];
    [imgView setImage:[TDUtil loadContent:STATIC_USER_DEFAULT_ID_PIC]];
    imgView.tag=50001;
    imgView.contentMode = UIViewContentModeScaleToFill;
    imgView.layer.cornerRadius = 5;
    imgView.layer.masksToBounds = YES;
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookPhotoDetail:)]];
    [view addSubview:imgView];
    UILabel* label;
    
    imgView =[[UIImageView alloc]initWithFrame:CGRectInset(imgView.frame, 40, 30)];
    imgView.image = IMAGE(@"auth", @"png");
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imgView];
    //填写信息
    view = [[UIView alloc]initWithFrame:CGRectMake(10, POS_Y(view), WIDTH(self.view)-20, 240)];
    view.tag = 30002;
    view.layer.cornerRadius=5;
    view.backgroundColor  =WriteColor;
    [scrollView addSubview:view];
    
    //姓名
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH(scrollView)*1/4, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"真实姓名";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入姓名
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollView)*2/3-20, 30)];
    nameTextField.font  =SYSTEMFONT(16);
    nameTextField.tag = 500001;
    nameTextField.enabled=NO;
    nameTextField.delegate = self;
    nameTextField.textColor = FONT_COLOR_GRAY;
    nameTextField.returnKeyType = UIReturnKeyDone;
    nameTextField.layer.borderColor =ColorTheme.CGColor;
    
    NSString* str = [data valueForKey:USER_STATIC_NAME];
    NSRange range;
    if (str.length>2) {
        range = NSMakeRange(1, str.length-2);
    }else{
        range = NSMakeRange(1, 1);
    }
    str = [self stringByReplacingCharactersInRange:range withString:@"*" content:str];
    nameTextField.text = str;
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
    label.text = @"身份证号";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    IDTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(nameTextField), 30)];
    IDTextField.tag = 500002;
    IDTextField.enabled=NO;
    IDTextField.delegate = self;
    IDTextField.font  =SYSTEMFONT(16);
    IDTextField.textColor = FONT_COLOR_GRAY;
    IDTextField.returnKeyType = UIReturnKeyDone;
    IDTextField.layer.borderColor =ColorTheme.CGColor;
    IDTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    str = [data valueForKey:USER_STATIC_IDNUMBER];
    str = [self stringByReplacingCharactersInRange:NSMakeRange(4, str.length-8) withString:@"*" content:str];
    IDTextField.text = str;
    IDTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    IDTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:IDTextField];
    
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(IDTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(label), 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"现住地址";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    addressTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(nameTextField), 30)];
    addressTextField.enabled=NO;
    addressTextField.tag = 500002;
    addressTextField.delegate = self;
    addressTextField.font  =SYSTEMFONT(16);
    addressTextField.textColor = FONT_COLOR_GRAY;
    addressTextField.returnKeyType = UIReturnKeyDone;
    addressTextField.layer.borderColor =ColorTheme.CGColor;
    addressTextField.text = [data valueForKey:USER_STATIC_ADDRESS];
    addressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addressTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:addressTextField];
    
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(addressTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(label), 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"公司名称";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    companyTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(nameTextField), 30)];
    companyTextField.enabled=NO;
    companyTextField.tag = 500002;
    companyTextField.delegate = self;
    companyTextField.font  =SYSTEMFONT(16);
    companyTextField.textColor = FONT_COLOR_GRAY;
    companyTextField.returnKeyType = UIReturnKeyDone;
    companyTextField.layer.borderColor =ColorTheme.CGColor;
    companyTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    companyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    companyTextField.text = [data valueForKey:USER_STATIC_COMPANY_NAME];
    companyTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:companyTextField];
    
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(companyTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(label), 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"担任职位";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    positionTextField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(nameTextField), 30)];
    positionTextField.tag = 500002;
    positionTextField.enabled=NO;
    positionTextField.delegate = self;
    positionTextField.font  =SYSTEMFONT(16);
    positionTextField.textColor = FONT_COLOR_GRAY;
    positionTextField.returnKeyType = UIReturnKeyDone;
    positionTextField.layer.borderColor =ColorTheme.CGColor;
    positionTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    positionTextField.text = [data valueForKey:USER_STATIC_POSITION];
    positionTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    positionTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [view addSubview:positionTextField];
    
    lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(view), POS_Y(positionTextField), WIDTH(view), 1)];
    lineView.backgroundColor  =BackColor;
    [view addSubview:lineView];
    
    
//    UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(60, POS_Y(view)+20, WIDTH(scrollView)-120, 35)];
//    btnAction.layer.cornerRadius =5;
//    btnAction.backgroundColor = ColorTheme;
//    [btnAction setTitle:@"提交资料" forState:UIControlStateNormal];
//    [btnAction addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
//    [scrollView addSubview:btnAction];
    
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)-170, POS_Y(view)-90, 140, 140)];
    imgView.tag=1001;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imgView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT(self.view)-50, WIDTH(self.view), 50)];
    label.font = SYSTEMFONT(12);
    label.text=@"最终解释权归金指投所有";
    label.textColor = FONT_COLOR_GRAY;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

-(NSString*)stringByReplacingCharactersInRange:(NSRange)range withString:(NSString*)str content:(NSString*)content
{
    if ([TDUtil isValidString:content]) {
        NSString* returnStr =[content substringToIndex:range.location];
        for (int i=0; i<content.length; i++) {
            if (i>=range.location && i<=range.length) {
                returnStr =[returnStr stringByAppendingString:@"*"];
            }
        }
        if (content.length!=2) {
            returnStr =[returnStr stringByAppendingString:[content substringWithRange:NSMakeRange(content.length-range.location, range.location)]];
        }
        return returnStr;
    }
    return @"";
}

-(BOOL)commitData
{
//    if (!isUploadID) {
//        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请先上传身份证" ];
//        return NO;
//    }
    NSString* userName;
    NSString* userType;
    NSString* company;
    NSString* IDNumber;
    NSString* address;
    
    IDNumber  =IDTextField.text;
    userName = nameTextField.text;
    address  =addressTextField.text;
    company  = companyTextField.text;
    userType = positionTextField.text;
    
    if (![TDUtil isValidString:userName]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:nameTextField.placeholder];
        return NO;
    }
    
    if (![TDUtil isValidString:IDNumber]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:IDTextField.placeholder];
        return NO;
    }else{
        if (![TDUtil validateIdentityCard:IDNumber]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"身份证号输入错误"];
            return NO;
        }
    }
    
    if (![TDUtil isValidString:address]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:addressTextField.placeholder];
        return NO;
    }
    
    if (![TDUtil isValidString:company]) {
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:companyTextField.placeholder];
        return NO;
    }
    if (![TDUtil isValidString:userType]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:positionTextField.placeholder];
        return NO;
    }
    
    
    
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc]init];
    [dataDic setValue:address forKey:@"addr"];
    [dataDic setValue:userName forKey:@"name"];
    [dataDic setValue:IDNumber forKey:@"idno"];
    [dataDic setValue:company forKey:@"company"];
    [dataDic setValue:userType forKey:@"position"];
    [self.httpUtil getDataFromAPIWithOps:@"userinfo/" postParam:dataDic type:0 delegate:self sel:@selector(requestUserInfo:)];
    return YES;
}
     
#pragma lookPhotoDetail
 -(void)lookPhotoDetail:(UITapGestureRecognizer*)recognizer
 {
     UIImageView * imgView = (UIImageView*)recognizer.view;
     // Create array of MWPhoto objects
     self.photos = [NSMutableArray new];
     [self.photos addObject:[MWPhoto photoWithImage:imgView.image]];
     
     
     // Create browser (must be done each time photo browser is
     // displayed. Photo browser objects cannot be re-used)
     MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
     
     // Set options
     browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
     browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
     browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
     browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
     browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
     browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
     browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
     
     // Optionally set the current visible photo before displaying
     [browser setCurrentPhotoIndex:1];
     
     // Present
     [self.navigationController pushViewController:browser animated:YES];
     
     // Manipulate
     [browser showNextPhotoAnimated:YES];
     [browser showPreviousPhotoAnimated:YES];
     [browser setCurrentPhotoIndex:10];
 }

#pragma MWPhotoBrowser
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.photos.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    return self.photos[index];
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray=dataArray;
}

-(void)setType:(int)type
{
    self->_type = type;
    UIImageView* imgView = [self.view viewWithTag:1001];
    if (imgView) {
        switch (self.type) {
            case 0:
                imgView.image = IMAGE(@"passed", @"png");
                break;
            case 1:
                imgView.image = IMAGE(@"authing", @"png");
                break;
            case 2:
                imgView.image = IMAGE(@"failed", @"png");
                break;
            default:
                imgView.image = IMAGE(@"authing", @"png");
                break;
        }
    }
}

-(void)refresh
{
    [self loadData];
}


//*********************************************************网络请求开始*****************************************************//
-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    
    if (dic!=nil) {
//        NSString* code =[dic valueForKey:@"code"];
        NSDictionary* tempDic = [dic valueForKey:@"data"];
        
        UIImageView* imgView = [[scrollView viewWithTag:30001] viewWithTag:50001];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[tempDic valueForKey:@"idpic"]] placeholderImage:IMAGENAMED(@"loading")];
        
        self.startLoading = NO;
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
            [[NSNotificationCenter defaultCenter]postNotificationName:@"showAuth" object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:@"viewController"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
    }
}
//*********************************************************网络请求结束*****************************************************//

#pragma pickviewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    addressTextField.text  =[NSString stringWithFormat:@"%@ %@",pickView.state,pickView.city];
}

//*********************************************************UiTextField *****************************************************//
#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == addressTextField) {
        [textField resignFirstResponder];
        ZHPickView* pickview=[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
        pickview.backgroundColor = ClearColor;
        pickview.delegate=self;
        [pickview show];
    }
    
}

-(void)resignKeyboard
{
    //收起键盘
    //收起键盘
    UIView* view = [scrollView viewWithTag:30002];
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
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//陈生珠
@end
