//
//  CompanyViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "CompanyViewController.h"
#import "TDUtil.h"
#import "NavView.h"
#import "HttpUtils.h"
#import "DialogUtil.h"
#import "ZHPickView.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "IndustoryView.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "RoadShowApplyViewController.h"
@interface CompanyViewController ()<UIScrollViewDelegate,UITextFieldDelegate,ASIHTTPRequestDelegate,ZHPickViewDelegate>
{
    NavView* navView;
    NSString* provinceCity;
    HttpUtils* httpUtils;
    ZHPickView *pickview;
    
    NSMutableArray* companyTypeArray;
    UIScrollView* scrollView;
}
@property(retain,nonatomic)IndustoryView* industoryView;
@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //初始化网络请求对象
    httpUtils = [[HttpUtils alloc]init];
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:@"公司信息"];
    navView.titleLable.textColor=WriteColor;
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:@"我要路演" forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:navView];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    scrollView.delegate=self;
    scrollView.bounces = NO;
    scrollView.backgroundColor=BackColor;
    scrollView.contentSize = CGSizeMake(WIDTH(scrollView), HEIGHT(scrollView)+50);
    [self.view addSubview:scrollView];
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(self.view)-20, 150)];
    view.tag = 20001;
    view.backgroundColor = WriteColor;
    view.layer.cornerRadius = 5;
    [scrollView addSubview:view];
    
    //公司名称
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH(scrollView)/2-70, 21)];
    label.text = @"公司名称";
    label.textAlignment = NSTextAlignmentRight;
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    UITextField* textfield = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollView)/2+10, 21)];
    textfield.font = SYSTEMFONT(16);
    textfield.delegate =self;
    textfield.tag = 10001;
    textfield.placeholder = @"请填写公司名称";
    [view addSubview:textfield];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, POS_Y(textfield)+10, WIDTH(view)-20, 1)];
    imageView.alpha = 0.4;
    imageView.backgroundColor =BACKGROUND_LIGHT_GRAY_COLOR;
    [view addSubview:imageView];
    
    //所属行业
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(imageView)+10, WIDTH(scrollView)/2-70, 21)];
    label.text = @"所属行业";
    label.textAlignment = NSTextAlignmentRight;
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    textfield = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollView)/2+10, 21)];
    textfield.font = SYSTEMFONT(16);
    textfield.delegate =self;
    textfield.tag = 10002;
    textfield.placeholder = @"请选择公司所属行业";
    [view addSubview:textfield];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, POS_Y(textfield)+10, WIDTH(view)-20, 1)];
    imageView.alpha = 0.4;
    imageView.backgroundColor =BACKGROUND_LIGHT_GRAY_COLOR;
    [view addSubview:imageView];
    
    
    //公司注册地址
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(imageView)+10, WIDTH(scrollView)/2-70, 21)];
    label.text = @"注册地址";
    label.textAlignment = NSTextAlignmentRight;
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    textfield = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollView)/2+10, 21)];
    textfield.font = SYSTEMFONT(16);
    textfield.delegate =self;
    textfield.tag = 10003;
    textfield.placeholder = @"请选择公司注册地址";
    [view addSubview:textfield];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, POS_Y(textfield)+10, WIDTH(view)-20, 1)];
    imageView.alpha = 0.4;
    imageView.backgroundColor =BACKGROUND_LIGHT_GRAY_COLOR;
    [view addSubview:imageView];
    
    
    view = [[UIView alloc]initWithFrame:CGRectMake(10, POS_Y(view)+10, WIDTH(self.view)-20, 170)];
    view.tag=20002;
    view.backgroundColor = WriteColor;
    view.layer.cornerRadius = 5;
    [scrollView addSubview:view];
    
    //公司状态
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH(scrollView)/2-70, 21)];
    label.text = @"公司状态";
    label.textAlignment = NSTextAlignmentRight;
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyType:)];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), 20, 20)];
    imageView.tag=10001;
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:recognizer];
    imageView.image = IMAGENAMED(@"dianxuankuang 1");
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imageView];
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyType:)];
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, Y(label), WIDTH(view), 21)];
    label.tag=10001;
    label.text = @"拟挂牌新三板";
    label.font =SYSTEMFONT(16);
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:recognizer];
    [view addSubview:label];
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyType:)];
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(scrollView)/2-60, POS_Y(imageView)+10, 20, 20)];
    imageView.tag=10002;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = IMAGENAMED(@"dianxuankuang 1");
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:recognizer];
    [view addSubview:imageView];
    
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyType:)];
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, POS_Y(label)+10, WIDTH(view), 21)];
    label.tag=10002;
    label.text = @"拟挂牌上股交";
    label.font =SYSTEMFONT(16);
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:recognizer];
    [view addSubview:label];
    
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyType:)];
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(X(imageView), POS_Y(imageView)+10, 20, 20)];
    imageView.tag=10003;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = IMAGENAMED(@"dianxuankuang 1");
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:recognizer];
    [view addSubview:imageView];
    
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyType:)];
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, POS_Y(label)+10, WIDTH(view), 21)];
    label.tag=10003;
    label.text = @"已挂配新三板";
    label.font =SYSTEMFONT(16);
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:recognizer];
    [view addSubview:label];
    
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyType:)];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(X(imageView), POS_Y(imageView)+10, 20, 20)];
    imageView.tag=10004;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = IMAGENAMED(@"dianxuankuang 1");
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:recognizer];
    [view addSubview:imageView];
    
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyType:)];
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, POS_Y(label)+10, WIDTH(view), 21)];
    label.tag=10004;
    label.text = @"已挂牌上股交";
    label.font =SYSTEMFONT(16);
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:recognizer];
    [view addSubview:label];
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyType:)];
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(X(imageView), POS_Y(imageView)+10, 20, 20)];
    imageView.tag=10005;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = IMAGENAMED(@"dianxuankuang 1");
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:recognizer];
    [view addSubview:imageView];
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(companyType:)];
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+10, POS_Y(label)+10, WIDTH(view), 21)];
    label.tag=10005;
    label.text = @"其他";
    label.font =SYSTEMFONT(16);
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:recognizer];
    [view addSubview:label];
    
    
    UIButton* btnAction = [[UIButton alloc]initWithFrame:CGRectMake(60, POS_Y(view)+20, WIDTH(self.view)-120, 35)];
    btnAction.backgroundColor = ColorTheme;
    btnAction.layer.cornerRadius = 5;
    [btnAction setTitleColor:WriteColor forState:UIControlStateNormal];
    [btnAction setTitle:@"确认添加" forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btnAction];
    
     [self loadIndustoryTypeList];
    
    
}

-(void)companyType:(UITapGestureRecognizer*)sender
{
    if (!companyTypeArray) {
        companyTypeArray = [NSMutableArray new];
    }
    NSInteger index=sender.view.tag-10000;
    NSString* temp = [NSString stringWithFormat:@"%ld",index];
    if ([companyTypeArray containsObject:temp]) {
        [companyTypeArray removeObject:temp];
    }else{
        [companyTypeArray removeAllObjects];
        [companyTypeArray addObject:temp];
    }
    NSLog(@"%@",companyTypeArray);
    
    UIView* v = [scrollView viewWithTag:20002];
    UIView* view;
    for (int i = 1; i<=5; i++) {
        view = [v viewWithTag:10000+i];
        NSLog(@"class:%@",view.class);
        if ([view isKindOfClass:UIImageView.class]) {
            temp = [NSString stringWithFormat:@"%d",i];
            if ([companyTypeArray containsObject:temp]) {
                ((UIImageView*)view).image = IMAGENAMED(@"dianxuankuang");
            }else{
                ((UIImageView*)view).image = IMAGENAMED(@"dianxuankuang 1");
            }
        }
        
    }
    
}

-(BOOL)commitAction:(id)sender
{
    NSString* companyName;
    NSString* industory;
    NSString* address;
    UITextField* textField = (UITextField*)[scrollView viewWithTag:10001];
    companyName = textField.text;
    
    
    textField = (UITextField*)[scrollView viewWithTag:10002];
    industory =textField.text;
    
    textField = (UITextField*)[scrollView viewWithTag:10003];
    address =textField.text;
    
    if (!companyName || [companyName isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请填写公司名称"];
        return false;
    }
    
    NSDictionary* dic = [[NSMutableDictionary alloc]init];
    
    
    
    if (!self.industoryArray || self.industoryArray.count==0) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择公司所属行业"];
        return false;
    }
    
    if (!pickview.state || [(NSString*)pickview.state isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择公司注册省份"];
        return false;
    }
    
    if (!pickview.city || [(NSString*)pickview.city isEqualToString:@""]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择公司注册城市"];
        return false;
    }
    
    
    if (!companyTypeArray || companyTypeArray.count==0) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择公司类型"];
        return false;
    }
   
    
    [dic setValue:pickview.city forKey:@"city"];
    [dic setValue:pickview.state forKey:@"province"];
    [dic setValue:companyName forKey:@"company_name"];
    
    
    NSString* temp = @"";
    for (int i =0 ; i<self.industoryArray.count; i++) {
        if (i!=self.industoryArray.count-1) {
            temp =[temp stringByAppendingFormat:@"%@,",[self.industoryArray[i] valueForKey:@"id"]];
        }else{
            temp =[temp stringByAppendingFormat:@"%@",[self.industoryArray[i] valueForKey:@"id"]];
        }
    }
    
    [dic setValue:temp forKey:@"industry_type"];
    
    
    temp = @"";
    for (int i =0 ; i<companyTypeArray.count; i++) {
        if (i!=companyTypeArray.count-1) {
            temp =[temp stringByAppendingFormat:@"%@,",companyTypeArray[i]];
        }else{
            temp =[temp stringByAppendingFormat:@"%@",companyTypeArray[i]];
        }
    }
    
    [dic setValue:temp forKey:@"company_status"];
    
    
    [httpUtils getDataFromAPIWithOps:ADD_COMPANY postParam:dic type:0 delegate:self sel:@selector(requestAddCompany:)];
    
    return YES;
}

-(void)loadIndustoryTypeList{
    [httpUtils getDataFromAPIWithOps:INDUSTORY_TYPE_LIST postParam:nil type:0 delegate:self sel:@selector(requestIndustoryList:)];
}
-(void)back:(id)sender
{
    [(RoadShowApplyViewController*)self.controller loadCompanyData];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger tag = textField.tag;
    if (tag == 10003) {
        [textField resignFirstResponder];
        pickview=[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
        pickview.backgroundColor = ClearColor;
        pickview.delegate=self;
        pickview.sender = textField;
        [pickview show];
    }else if (tag ==10002){
        if(!self.industoryView){
            self.industoryView = [[IndustoryView alloc]initWithFrame:self.view.frame];
            self.industoryView.controller =self;
        }
        self.industoryView.dataArray = self.dataArray;
        [self.view addSubview:self.industoryView];
    }
   
}


-(void)setIndustoryArray:(NSMutableArray *)industoryArray
{
    self->_industoryArray  =industoryArray;
    
    UIView* v = [scrollView viewWithTag:20001];
    UITextField* textField = (UITextField*)[v viewWithTag:10002];
    
    NSString* str =@"";
    for (int i =0 ; i<industoryArray.count; i++) {
        if (i!=industoryArray.count-1) {
            str =[str stringByAppendingFormat:@"%@,",[industoryArray[i] valueForKey:@"type_name"]];
        }else{
            str =[str stringByAppendingFormat:@"%@",[industoryArray[i] valueForKey:@"type_name"]];
        }
    }
    textField.text = str;
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


-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    provinceCity = resultString;
    ((UITextField*)pickview.sender).text = resultString;
}

#pragma ASIHttpRequester
//===========================================================网络请求=====================================
-(void)requestIndustoryList:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            NSMutableArray* array = [jsonDic valueForKey:@"data"];
            NSMutableArray* tempArray = [NSMutableArray new];
            
            if (!self.dataArray) {
                self.dataArray = [NSMutableArray new];
            }
            for (int i=0; i<array.count; i++) {
                if (i%3==0) {
                    if (tempArray && tempArray.count>0) {
                        [self.dataArray addObject:tempArray];
                    }
                    tempArray = [NSMutableArray new];
                }else{
                    [tempArray addObject:array[i]];
                }
            }
        }
    }
}

//发送验证码
-(void)requestAddCompany:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            NSLog(@"公司添加成功成功!");
            [self back:nil];
        }else{
            NSLog(@"公司添加失败失败!");
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
}
@end
