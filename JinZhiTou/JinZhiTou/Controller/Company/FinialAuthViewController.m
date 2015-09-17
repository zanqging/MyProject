//
//  FinialAuthViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/4.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "FinialAuthViewController.h"
#import "TDUtil.h"
#import "NavView.h"
#import "PhotoAdd.h"
#import "HttpUtils.h"
#import "DialogUtil.h"
#import "UConstants.h"
#import "AutoShowView.h"
#import "SwitchSelect.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "ASIFormDataRequest.h"
#import "PECropViewController.h"
#import "PrivacyViewController.h"
#import "CompanyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FinialProctoTableViewCell.h"

@interface FinialAuthViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,CustomImagePickerControllerDelegate,ASIHTTPRequestDelegate,UITextFieldDelegate>
{
    NavView* navView;
    HttpUtils* httpUtils;
    AutoShowView* autoShowView;
    
    int currentItemIndex;
    BOOL isUploadID;
    BOOL isCheck;
    NSDictionary* companySelected;
    NSDictionary* industorySelected;
    NSDictionary* foundationSizeSelected;
    
    NSMutableArray* array;
    NSInteger currentPhotoTag;
    UIScrollView* scrollViewPerson;
    UIScrollView* scrollViewFinial;
}
@end

@implementation FinialAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //网络初始化
    httpUtils = [[HttpUtils alloc]init];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    navView.imageView.alpha=1;
    [navView setTitle:@"投资人认证"];
    navView.titleLable.textColor=WriteColor;
    
    [navView.leftButton setImage:nil forState:UIControlStateNormal];
    [navView.leftButton setTitle:self.titleStr forState:UIControlStateNormal];
    [navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    [navView.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:navView];
    
    [self addPersonalView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takePhoto:) name:@"takePhoto" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(autoSelect:) name:@"autoSelect" object:nil];
    //获取投资人认证协议条件
    [self loadData];
    [self loadCompanyData];
    
    //初始化协议书组
    array = [[NSMutableArray alloc]init];

}

-(void)autoSelect:(NSDictionary*)dic
{
    NSDictionary* dicData= [[dic valueForKey:@"userInfo" ] valueForKey:@"item"];
    
    UIView* view = [scrollViewFinial viewWithTag:30001];
    
    UITextField* textField;
    if (currentItemIndex==0) {
        textField = (UITextField*)[view viewWithTag:500003];
        textField.text = [dicData valueForKey:@"type_name"];
        industorySelected = dicData;
    }else if(currentItemIndex==2){
        textField = (UITextField*)[view viewWithTag:500002];
        textField.text = [dicData valueForKey:@"company_name"];
        companySelected = dicData;
    }else{
        textField = (UITextField*)[view viewWithTag:500004];
        textField.text = [dicData valueForKey:@"desc"];
        foundationSizeSelected = dicData;
    }
}

//加载协议
-(void)loadData
{
    [httpUtils getDataFromAPIWithOps:INVESTOR_PROT postParam:nil type:0 delegate:self sel:@selector(requestInvestPro:)];
}
//加载基金规模
-(void)loadFoundationSize
{
    [httpUtils getDataFromAPIWithOps:FOUNSIZERANGE postParam:nil type:0 delegate:self sel:@selector(requestFundSizeRange:)];
}
//加载行业类别
-(void)loadIndustoryTypeData
{
    [httpUtils getDataFromAPIWithOps:INDUSTORY_TYPE_LIST postParam:nil type:0 delegate:self sel:@selector(requestIndustoryTypeData:)];
}
//认证
-(void)authenticateAction
{
    [httpUtils getDataFromAPIWithOps:AUTHENTICATE postParam:nil type:0 delegate:self sel:@selector(requestIndustoryTypeData:)];
}

//上传名片
-(void)uploadBuinessCard:(NSString*)data
{
    NSString* url = [UPLOAD_BUINESSCARD stringByAppendingFormat:@"%@/",data];
    [httpUtils getDataFromAPIWithOps:url postParam:nil file:STATIC_USER_DEFAULT_PIC postName:@"file" type:0 delegate:self sel:@selector(requestUploadIDFore:)];
}

//上传身份证
-(void)uploadID:(NSInteger)id
{
    [httpUtils getDataFromAPIWithOps:ID_FORE postParam:nil file:STATIC_USER_DEFAULT_PIC postName:@"file" type:0 delegate:self sel:@selector(requestUploadIDFore:)];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadCompanyData
{
    [httpUtils getDataFromAPIWithOps:COMPANY_LIST postParam:nil type:0 delegate:self  sel:@selector(requestCompanyData:)];
}

-(void)addPersonalView
{
    scrollViewPerson = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    scrollViewPerson.tag =40001;
    scrollViewPerson.delegate=self;
    scrollViewPerson.bounces = NO;
    scrollViewPerson.backgroundColor=BackColor;
    scrollViewPerson.contentSize = CGSizeMake(WIDTH(scrollViewPerson), HEIGHT(scrollViewPerson)+500);
    [self.view addSubview:scrollViewPerson];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doAddCompanyAction:)];
    //自然投资人
    SwitchSelect* personalSwitchView = [[SwitchSelect alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view)/2, 50)];
    personalSwitchView.tag = 20001;
    personalSwitchView.isSelected = YES;
    [personalSwitchView addGestureRecognizer:recognizer];
    personalSwitchView.titleName = @"个人投资人";
    [scrollViewPerson addSubview:personalSwitchView];
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doAction:)];
    //机构投资人
    SwitchSelect* companySwitchView = [[SwitchSelect alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2, 0, WIDTH(self.view)/2, 50)];
    companySwitchView.tag = 20002;
    companySwitchView.isSelected = NO;
    [companySwitchView addGestureRecognizer:recognizer];
    companySwitchView.titleName = @"机构投资人";
    [scrollViewPerson addSubview:companySwitchView];
    
    PhotoAdd* IDPhotoAddView = [[PhotoAdd alloc]initWithFrame:CGRectMake(10, POS_Y(personalSwitchView)+20, WIDTH(scrollViewPerson)/2-15, 100)];
    IDPhotoAddView.tag = 20003;
    IDPhotoAddView.title = @"上传身份证";
    [scrollViewPerson addSubview:IDPhotoAddView];
    
    PhotoAdd* CardPhotoAddView = [[PhotoAdd alloc]initWithFrame:CGRectMake(WIDTH(scrollViewPerson)/2+5, Y(IDPhotoAddView), WIDTH(scrollViewPerson)/2-15, 100)];
    CardPhotoAddView.tag = 20004;
    CardPhotoAddView.title = @"上传个人名片";
    [scrollViewPerson addSubview:CardPhotoAddView];
    
    //填写信息
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(CardPhotoAddView)+10, WIDTH(self.view), 150)];
    view.tag = 30001;
    view.backgroundColor  =WriteColor;
    [scrollViewPerson addSubview:view];
    
    //姓名
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH(scrollViewPerson)*1/4, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"姓名";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入姓名
    UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollViewPerson)*2/3-20, 30)];
    textField.font  =SYSTEMFONT(16);
    textField.tag = 500001;
    textField.delegate = self;
    textField.placeholder = @"请输入您的真实姓名";
    [view addSubview:textField];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(label), 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"职位";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(textField), 30)];
    textField.tag = 500002;
    textField.delegate = self;
    textField.font  =SYSTEMFONT(16);
    textField.placeholder = @"请输入您的职位";
    [view addSubview:textField];
    
    //公司
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(scrollViewPerson)*1/4, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"公司";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入公司信息
    textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollViewPerson)*2/3-20, 30)];
    textField.tag = 500003;
    textField.delegate = self;
    textField.font  =SYSTEMFONT(16);
    textField.placeholder = @"请输入您的公司";
    [view addSubview:textField];
    
    //header
    view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(view)+10, WIDTH(scrollViewPerson), 30)];
    view.tag =30002;
    //头部
    label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, WIDTH(scrollViewPerson)-40, 20)];
    label.text = @"符合以下条件之一的自然人投资者，可多选";
    label.font  =SYSTEMFONT(14);
    [view addSubview:label];
    [scrollViewPerson addSubview:view];
    
    //tableView
    CGRect rect=CGRectMake(0, POS_Y(view)+10, WIDTH(scrollViewPerson),264);
    self.tableView=[[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    [scrollViewPerson addSubview:self.tableView];
    
    
    
    //footer
    view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(self.tableView)+10, WIDTH(scrollViewPerson), 50)];
    view.tag =30003;
    //头部
    label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, WIDTH(scrollViewPerson)-40, 40)];
    label.text = @"备注：以上内容请参考《私募股权基金监督管理暂行办法（试行）》合格投资人规定";
    label.numberOfLines = 0;
    label.font  =SYSTEMFONT(14);
    label.lineBreakMode  =NSLineBreakByWordWrapping;
    [view addSubview:label];
    
    [scrollViewPerson addSubview:view];
    
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, POS_Y(view)+7, WIDTH(scrollViewPerson), 20)];
    label.font = SYSTEMFONT(12);
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(protocolAction:)]];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"我已经认真阅读并同意 《投资风险提示书》";
    [scrollViewPerson addSubview:label];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, POS_Y(view)+10, 15, 15)];
    imgView.image = IMAGENAMED(@"queren-1");
    imgView.tag  =700001;
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(check:)]];
    [scrollViewPerson addSubview:imgView];
    
    
    
    UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(60, POS_Y(label)+20, WIDTH(scrollViewPerson)-120, 35)];
    btnAction.layer.cornerRadius =5;
    btnAction.backgroundColor = ColorTheme;
    [btnAction setTitle:@"提交资料" forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
    [scrollViewPerson addSubview:btnAction];
}

-(void)protocolAction:(id)sender
{
    PrivacyViewController* controller = [[PrivacyViewController alloc]init];
    controller.serverUrl = risk;
    controller.title = navView.title;
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)addCompanyView
{
    scrollViewFinial = [[UIScrollView alloc]initWithFrame:CGRectMake(0, POS_Y(navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(navView))];
    scrollViewFinial.tag =40002;
    scrollViewFinial.delegate=self;
    scrollViewFinial.bounces = NO;
    scrollViewFinial.backgroundColor=BackColor;
    scrollViewFinial.contentSize = CGSizeMake(WIDTH(scrollViewFinial), HEIGHT(scrollViewFinial)+650);
    [self.view addSubview:scrollViewFinial];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doAction:)];
    //自然投资人
    SwitchSelect* personalSwitchView = [[SwitchSelect alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view)/2, 50)];
    personalSwitchView.tag = 20001;
    personalSwitchView.isSelected = YES;
    [personalSwitchView addGestureRecognizer:recognizer];
    personalSwitchView.titleName = @"个人投资人";
    [scrollViewFinial addSubview:personalSwitchView];
    
    recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doAction:)];
    //机构投资人
    SwitchSelect* companySwitchView = [[SwitchSelect alloc]initWithFrame:CGRectMake(WIDTH(self.view)/2, 0, WIDTH(self.view)/2, 50)];
    companySwitchView.tag = 20002;
    companySwitchView.isSelected = NO;
    [companySwitchView addGestureRecognizer:recognizer];
    companySwitchView.titleName = @"机构投资人";
    [scrollViewFinial addSubview:companySwitchView];
    
    PhotoAdd* IDPhotoAddView = [[PhotoAdd alloc]initWithFrame:CGRectMake(10, POS_Y(personalSwitchView)+20, WIDTH(scrollViewFinial)/2-15, 100)];
    IDPhotoAddView.title = @"上传身份证";
    IDPhotoAddView.tag = 20003;
    [scrollViewFinial addSubview:IDPhotoAddView];
    
    PhotoAdd* CardPhotoAddView = [[PhotoAdd alloc]initWithFrame:CGRectMake(WIDTH(scrollViewFinial)/2+5, Y(IDPhotoAddView), WIDTH(scrollViewFinial)/2-15, 100)];
    CardPhotoAddView.title = @"上传个人名片";
    CardPhotoAddView.tag = 20004;
    [scrollViewFinial addSubview:CardPhotoAddView];
    
    //header
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(CardPhotoAddView)+10, WIDTH(scrollViewFinial), 30)];
    view.tag =30002;
    //头部
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, WIDTH(scrollViewFinial)-40, 20)];
    label.text = @"符合以下条件之一的机构投资者，可多选";
    label.font  =SYSTEMFONT(14);
    [view addSubview:label];
    [scrollViewFinial addSubview:view];
    
    //tableView
    CGRect rect=CGRectMake(0, POS_Y(view)+10, WIDTH(scrollViewFinial),264);
    self.tableView=[[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.bounces=YES;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    [scrollViewFinial addSubview:self.tableView];
    
    
    
    //footer
    view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(self.tableView)+10, WIDTH(scrollViewFinial), 50)];
    view.tag =30003;
    //头部
    label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, WIDTH(scrollViewFinial)-40, 40)];
    label.text = @"备注：以上内容请参考《私募股权基金监督管理暂行办法（试行）》合格投资人规定";
    label.numberOfLines = 0;
    label.font  =SYSTEMFONT(14);
    label.lineBreakMode  =NSLineBreakByWordWrapping;
    [view addSubview:label];
    
    [scrollViewFinial addSubview:view];
    
    //填写信息
    view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(view)+10, WIDTH(self.view), 200)];
    view.tag = 30001;
    view.backgroundColor  =WriteColor;
    [scrollViewFinial addSubview:view];
    
    //姓名
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, WIDTH(scrollViewFinial)*1/4, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"姓名";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入姓名
    UITextField* textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollViewFinial)*2/3-20, 30)];
    textField.tag = 500001;
    textField.delegate = self;
    textField.font  =SYSTEMFONT(16);
    textField.placeholder = @"请输入您的真实姓名";
    [view addSubview:textField];
    
    //职位
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(label), 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"公司";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入职位
    textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(textField), 30)];
    textField.tag = 500002;
    textField.delegate = self;
    textField.font  =SYSTEMFONT(16);
    textField.placeholder = @"请输入您的公司名称";
    [view addSubview:textField];
    
    
    recognizer =[[ UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doAction:)];
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self.view)-35, Y(textField), 20, 20)];
    imageView.image = IMAGENAMED(@"tianjia");
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:recognizer];
    [view addSubview:imageView];
    view.layer.cornerRadius = 5;
    
    //投资领域
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(scrollViewFinial)*1/4, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"投资领域";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入公司信息
    textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollViewFinial)*2/3-20, 30)];
    textField.tag = 500003;
    textField.delegate = self;
    textField.font  =SYSTEMFONT(16);
    textField.placeholder = @"请输入您所感兴趣的领域";
    [view addSubview:textField];
    
    //基金规模
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, POS_Y(label)+10, WIDTH(scrollViewFinial)*1/4, 30)];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"基金规模";
    label.font = SYSTEMFONT(16);
    [view addSubview:label];
    
    //输入公司信息
    textField = [[UITextField alloc]initWithFrame:CGRectMake(POS_X(label)+10, Y(label), WIDTH(scrollViewFinial)*2/3-20, 30)];
    textField.placeholder = @"请选择您的基金规模";
    textField.font  =SYSTEMFONT(16);
    textField.tag =500004;
    textField.delegate = self;
    [view addSubview:textField];
    
    
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, POS_Y(view)+20, 15, 15)];
    imgView.image = IMAGENAMED(@"queren-1");
    imgView.tag  =700001;
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(check:)]];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [scrollViewFinial addSubview:imgView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(0, Y(imgView)-3, WIDTH(scrollViewFinial), 20)];
    label.font = SYSTEMFONT(12);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"我已经认真阅读并同意 《投资风险提示书》";
    [scrollViewFinial addSubview:label];
    
    
    
    UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(60, POS_Y(label)+20, WIDTH(scrollViewFinial)-120, 35)];
    btnAction.layer.cornerRadius =5;
    btnAction.backgroundColor = ColorTheme;
    [btnAction setTitle:@"提交资料" forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
    [scrollViewFinial addSubview:btnAction];
}

-(void)doAction:(UITapGestureRecognizer*)recongnizer
{
    NSInteger tag = recongnizer.view.tag;
    SwitchSelect* selectViewPerson;
    SwitchSelect* selectViewCompany;
    if (selectedIndex==0) {
        selectViewPerson =(SwitchSelect*)[scrollViewPerson viewWithTag:20001];
        selectViewCompany =(SwitchSelect*)[scrollViewPerson viewWithTag:20002];
    }else{
        selectViewPerson =(SwitchSelect*)[scrollViewFinial viewWithTag:20001];
        selectViewCompany =(SwitchSelect*)[scrollViewFinial viewWithTag:20002];
    }
    
    switch (tag) {
        case 20001:
            if (!selectViewPerson.isSelected) {
                selectedIndex =0;
                selectViewPerson.isSelected=!selectViewPerson.isSelected;
                selectViewCompany.isSelected = NO;
            }
            break;
        case 20002:
            if (!selectViewCompany.isSelected) {

                selectedIndex =1;
                selectViewCompany.isSelected=!selectViewCompany.isSelected;
                selectViewPerson.isSelected = NO;
            }
            break;
        default:
            if (!selectViewPerson.isSelected) {
                selectedIndex =0;
                [self changeSwitchview];
                selectViewPerson.isSelected=!selectViewPerson.isSelected;
                selectViewCompany.isSelected = NO;
            }
            break;
    }
    //清空选项
    [array removeAllObjects];
    //重新加载
    [self.tableView reloadData];
    [self changeSwitchview];
    
    if (selectedIndex ==1) {
        //获取基金规模
        [self loadFoundationSize];
        //获取行业类别
        [self loadIndustoryTypeData];
    }
}


-(void)layout
{
    
    SwitchSelect* selectViewPerson;
    SwitchSelect* selectViewCompany;
    if (selectedIndex==0) {
        selectViewPerson=(SwitchSelect*)[scrollViewPerson viewWithTag:20001];
        selectViewCompany=(SwitchSelect*)[scrollViewPerson viewWithTag:20002];
    }else{
        selectViewPerson=(SwitchSelect*)[scrollViewFinial viewWithTag:20001];
        selectViewCompany=(SwitchSelect*)[scrollViewFinial viewWithTag:20002];
    }
   
    
    
    switch (selectedIndex) {
        case 0:
            if (!selectViewPerson.isSelected) {
                selectedIndex =0;
                selectViewPerson.isSelected=!selectViewPerson.isSelected;
                selectViewCompany.isSelected = NO;
            }
            break;
        case 1:
            if (!selectViewCompany.isSelected) {
                
                selectedIndex =1;
                selectViewPerson.isSelected=!selectViewPerson.isSelected;
                selectViewCompany.isSelected = YES;
            }
            break;
        default:
            if (!selectViewPerson.isSelected) {
                selectedIndex =0;
                [self changeSwitchview];
                selectViewPerson.isSelected=!selectViewPerson.isSelected;
                selectViewCompany.isSelected = NO;
            }
            break;
    }
}
-(void)changeSwitchview
{
    if (selectedIndex==0) {
        [scrollViewFinial removeFromSuperview];
        UIScrollView* scrollView = (UIScrollView*)[self.view viewWithTag:40001];
        if (scrollView) {
            [scrollViewFinial removeFromSuperview];
        }
        if (selectedIndex ==0 && !scrollView) {
            if (scrollViewPerson) {
                [self.view addSubview:scrollViewPerson];
            }else{
                [self addPersonalView];
            }
        }
        
    }else{
        UIScrollView* scrollView = (UIScrollView*)[self.view viewWithTag:40002];
        if (scrollView) {
            [scrollViewPerson removeFromSuperview];
        }
        
        if (selectedIndex != 0 && !scrollView) {
            if (scrollViewFinial) {
                [self.view addSubview:scrollViewFinial];
            }else{
                [self addCompanyView];
            }
            
        }
        
    }
    isCheck = NO;
    [self layout];
    
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
       
    }else{
       imgView = (UIImageView*)[scrollViewFinial viewWithTag:700001];
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
    NSString* userType;
    NSString* company;
    if (selectedIndex==0) {
        UITextField* textField = (UITextField*)[scrollViewPerson viewWithTag:500001];
        userName = textField.text;
        
        textField = (UITextField*)[scrollViewPerson viewWithTag:500002];
        userType = textField.text;
        
        textField = (UITextField*)[scrollViewPerson viewWithTag:500003];
        company = textField.text;
    }else{
        UITextField* textField = (UITextField*)[scrollViewFinial viewWithTag:500001];
        userName = textField.text;
        
        textField = (UITextField*)[scrollViewFinial viewWithTag:500002];
        userType = textField.text;
        
        textField = (UITextField*)[scrollViewFinial viewWithTag:500003];
        company = textField.text;
    }
    
    if (![TDUtil isValidString:userName]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入姓名" ];
        return NO;
    }
    
    if (![TDUtil isValidString:userType]) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择职位" ];
        return NO;
    }
    
    if (![TDUtil isValidString:company]) {
        if (selectedIndex == 1 && companySelected) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请填写公司" ];
            return NO;
        }
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请填写公司" ];
        return NO;
    }
    
    if (selectedIndex ==1) {
        if (!industorySelected) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择投资领域" ];
            return NO;
        }
        
        if (!foundationSizeSelected) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择基金规模" ];
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
            str = [str stringByAppendingFormat:@"%@,",[array[i] valueForKey:@"id"]];
        }else{
            str = [str stringByAppendingFormat:@"%@",[array[i] valueForKey:@"id"]];
        }
        
    }
    
    NSDictionary* dic =[[NSMutableDictionary alloc]init];
    [dic setValue:userName forKey:@"real_name"];
    [dic setValue:userType forKey:@"position"];
    [dic setValue:str forKey:@"investor_qualification"];
    if (selectedIndex==0) {
        [dic setValue:company forKey:@"company"];
    }else{
        [dic setValue:[companySelected valueForKey:@"id"] forKey:@"company"];
    }
    
    [dic setValue:[industorySelected valueForKey:@"id"] forKey:@"industry_type"];
    [dic setValue:[NSString stringWithFormat:@"%d",selectedIndex] forKey:@"investor_type"];
    [dic setValue:[foundationSizeSelected valueForKey:@"id"] forKey:@"fund_size_range"];
    [httpUtils getDataFromAPIWithOps:AUTHENTICATE postParam:dic type:0 delegate:self sel:@selector(requestAuthenicate:)];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray) {
        return [self.dataArray count];
    }
    return 6;
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
    [Cell setImageWithName:str setText:[dic valueForKey:@"desc"]];
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
        
        NSString* str = [dic valueForKey:@"desc"];
        if(str){
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str];
            NSRange range = NSMakeRange(0, attrStr.length);
            NSDictionary *dicFONT = [attrStr attributesAtIndex:0 effectiveRange:&range];   // 获取该段attributedString的属性字典
            // 计算文本的大小
            CGSize textSize = [str boundingRectWithSize:CGSizeMake(100, 30000) // 用于计算文本绘制时占据的矩形块
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                             attributes:dicFONT        // 文字的属性
                                                context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
            return textSize.height+20;
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
       [TDUtil saveCameraPicture:croppedImage fileName:STATIC_USER_DEFAULT_PIC];
        
       photoView =(PhotoAdd*)[scrollViewPerson viewWithTag:currentPhotoTag];
        //开始上传身份证
        if (currentPhotoTag==20003) {
            [self uploadID:1];
        }
    }else{
        //保存头像
        [TDUtil saveCameraPicture:croppedImage fileName:STATIC_USER_DEFAULT_PIC];
        
       photoView =(PhotoAdd*)[scrollViewFinial viewWithTag:currentPhotoTag];
        //开始上传身份证
        if (currentPhotoTag==20003) {
            [self uploadID:1];
        }
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
        NSString* status =[dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            NSMutableArray* data = [dic valueForKey:@"data"];
            if (data!=nil && data.count>0) {
                self.dataArray = data;
            }
            
        }
    }
}

-(void)requestFundSizeRange:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    
    if (dic!=nil) {
        NSString* status =[dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            NSMutableArray* data = [dic valueForKey:@"data"];
            if (data!=nil && data.count>0) {
                self.foundationSizeRange = data;
            }
            
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
            self.companyDataArray = [dic valueForKey:@"data"];
            if (self.companyDataArray.count>0) {
                
                autoShowView.isHidden =YES;
                autoShowView.title=@"company_name";
                autoShowView.dataArray = self.companyDataArray;
                [self.view addSubview:autoShowView];
            }
        }
    }
}



-(void)requestIndustoryTypeData:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    
    if (dic!=nil) {
        NSString* status =[dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            NSMutableArray* data = [dic valueForKey:@"data"];
            if (data!=nil && data.count>0) {
                self.industoryList = data;
            }
        }
    }
}

//上传身份证 requestUploadIDFore
-(void)requestUploadIDFore:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    
    if (dic!=nil) {
        NSString* status =[dic valueForKey:@"status"];
        if ([status integerValue]==0) {
//            NSMutableArray* data = [dic valueForKey:@"data"];
            isUploadID = YES;
        }
    }
}
//身份认证 requestAuthenicate
-(void)requestAuthenicate:(ASIHTTPRequest*)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    
    NSMutableDictionary* dic = [jsonString JSONValue];
    
    if (dic!=nil) {
        NSString* status =[dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            NSString* data = [dic valueForKey:@"data"];
            [self uploadBuinessCard:data];
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
            //返回
            [self back:nil];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
        }
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
    }else{
        [scrollViewFinial setContentOffset:CGPointMake(0, 560) animated:YES];
        if (textField.tag == 500003) {
            [textField resignFirstResponder];
            UIView* view = [scrollViewFinial viewWithTag:30001];
            
            
            if (!autoShowView) {
                
                autoShowView = [[AutoShowView alloc]initWithFrame:CGRectMake(X(textField), Y(view)+POS_Y(textField), WIDTH(textField), 150)];
                [scrollViewFinial addSubview:autoShowView];
            }else{
                [autoShowView setFrame:CGRectMake(X(textField), Y(view)+POS_Y(textField), WIDTH(textField), 150)];
            }
            currentItemIndex = 0;
            autoShowView.alpha =1;
            autoShowView.title = @"type_name";
            autoShowView.dataArray = self.industoryList;
        }else if (textField.tag == 500004){
            [textField resignFirstResponder];
            UIView* view = [scrollViewFinial viewWithTag:30001];
            [textField resignFirstResponder];
            if (!autoShowView) {
                autoShowView = [[AutoShowView alloc]initWithFrame:CGRectMake(X(textField), Y(view)+POS_Y(textField), WIDTH(textField), 150)];
                [scrollViewFinial addSubview:autoShowView];
            }else{
                [autoShowView setFrame:CGRectMake(X(textField), Y(view)+POS_Y(textField), WIDTH(textField), 150)];
            }
            currentItemIndex = 1;
            autoShowView.alpha =1;
            autoShowView.title = @"desc";
            autoShowView.dataArray = self.foundationSizeRange;
        }else if (textField.tag == 500002){
            [textField resignFirstResponder];
            UIView* view = [scrollViewFinial viewWithTag:30001];
            [textField resignFirstResponder];
            //bug
            UITextField* txtField = (UITextField*)[view viewWithTag:500001];
            if (txtField) {
                [textField resignFirstResponder];
            }
            
            if (!autoShowView) {
                autoShowView = [[AutoShowView alloc]initWithFrame:CGRectMake(X(textField), Y(view)+POS_Y(textField), WIDTH(textField), 150)];
                [scrollViewFinial addSubview:autoShowView];
            }else{
                [autoShowView setFrame:CGRectMake(X(textField), Y(view)+POS_Y(textField), WIDTH(textField), 150)];
            }
            currentItemIndex = 2;
            autoShowView.alpha =1;
            autoShowView.title = @"company_name";
            autoShowView.dataArray = self.companyDataArray;

        }

    }
    
    
}

-(void)resignKeyboard
{
    //收起键盘
    //收起键盘
    UIView* view = [scrollViewFinial viewWithTag:30001];
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
        [scrollViewPerson setContentOffset:CGPointMake(0, 0) animated:YES];
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
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
