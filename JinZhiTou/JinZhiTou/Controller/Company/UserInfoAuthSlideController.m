//
//  FinialAuthViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "UserInfoAuthSlideController.h"
#import "ZHPickView.h"
#import "MWPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface UserInfoAuthSlideController ()<UIScrollViewDelegate,UITextFieldDelegate,ZHPickViewDelegate,MWPhotoBrowserDelegate>
{
    UITextField* IDTextField;
    UIScrollView* scrollView;
    UITextField* nameTextField;
    UITextField* positionTextField;
    UITextField* companyTextField;
    UITextField* addressTextField;;
}
@property (retain, nonatomic) NSMutableArray * photos;
@end

@implementation UserInfoAuthSlideController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //网络初始化
    self.view.backgroundColor = ColorTheme;
    [self.navView removeFromSuperview];
//    //设置标题
//    self.navView.imageView.alpha=1;
//    [self.navView setTitle:@"认证信息"];
//    self.navView.titleLable.textColor=WriteColor;
//    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
//    [self.navView.leftButton setTitle:@"首页" forState:UIControlStateNormal];
//    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    self.loadingViewFrame  =CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)-100);
    [self addPersonalView];
    
    //认证信息
    [self authInfo];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadData
{
    [self.httpUtil getDataFromAPIWithOps:USERINFO postParam:nil type:0 delegate:self sel:@selector(requestFinished:)];
}

-(void)authInfo
{
    self.startLoading = YES;
    [self.httpUtil getDataFromAPIWithOps:@"myauth/" postParam:nil type:0 delegate:self sel:@selector(requestAuthFinished:)];
}

-(void)addPersonalView
{
    //缓存数据
    NSUserDefaults* data =[NSUserDefaults standardUserDefaults];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)-100)];
    scrollView.tag =40001;
    scrollView.delegate=self;
    scrollView.bounces = YES;
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
    [imgView setUserInteractionEnabled:YES];
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookPhotoDetail:)]];
    [view addSubview:imgView];
    UILabel* label;
    
    imgView =[[UIImageView alloc]initWithFrame:CGRectInset(imgView.frame, 40, 30)];
    imgView.image = IMAGE(@"auth", @"png");
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imgView];
    //填写信息
    view = [[UIView alloc]initWithFrame:CGRectMake(10, POS_Y(view), WIDTH(self.view)-20, 220)];
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
    
    
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)-170, POS_Y(view)-90, 140, 140)];
    imgView.tag=1001;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [scrollView addSubview:imgView];
    
    NSString * auth = [data valueForKey:@"auth"];
    if (![auth boolValue]) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(view)+30, WIDTH(self.view), 50)];
        label.tag = 10001;
        label.text = @"修改";
        label.backgroundColor  =WriteColor;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(modify:)]];
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];

    }
    
    [scrollView setContentSize:CGSizeMake(WIDTH(self.view), POS_Y(label)+20)];
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

-(void)modify:(id)sender
{
    NSLog(@"修改");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showAuth" object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:@"viewController"]];
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

-(void)requestAuthFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    
    if (dic!=nil) {
        //        NSString* code =[dic valueForKey:@"code"];
        NSDictionary* tempDic = [dic valueForKey:@"data"];
        NSString* auth = (NSString*)[tempDic valueForKey:@"auth"];
        
        UIImageView* imgView = [self.view viewWithTag:1001];
        UILabel * label =[scrollView viewWithTag:10001];
        if ([auth isKindOfClass:NSNull.class]) {
            imgView.image = IMAGE(@"authing", @"png");
        }else{
            if ([auth isKindOfClass:NSString.class]) {
                if ([auth isEqualToString:@""]) {
//                    [[NSNotificationCenter defaultCenter]postNotificationName:@"showAuth" object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:@"viewController"]];
                }
                
//                imgView.image = IMAGE(@"authing", @"png");
            }else{
                label.alpha = 0;
                label.userInteractionEnabled = NO;
                
                if ([auth boolValue]) {
                   imgView.image = IMAGE(@"passed", @"png");
                }else if(![auth boolValue]){
                   imgView.image = IMAGE(@"failed", @"png");
                }else{
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"showAuth" object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:@"viewController"]];
                }
                
            }
        }
    }
    
    [self loadData];
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
