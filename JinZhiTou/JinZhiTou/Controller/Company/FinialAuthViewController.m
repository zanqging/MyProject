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
#import "PersonalFinanceAuthViewController.h"

@interface FinialAuthViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,CustomImagePickerControllerDelegate,UITextFieldDelegate>
{
    
    BOOL isCheck;
    UITextField* nameTextField;
    UITextField* positionTextField;
    UITextField* companyTextField;
    NSDictionary* companySelected;
    NSDictionary* industorySelected;
    NSDictionary* foundationSizeSelected;
    
    NSMutableArray* array;
    NSInteger currentPhotoTag; //当前上传图片索引，1:身份证，2:头像
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
    scrollViewPerson.showsVerticalScrollIndicator = NO;
    scrollViewPerson.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollViewPerson];
    
    
    PhotoAdd* IDPhotoAddView = [[PhotoAdd alloc]initWithFrame:CGRectMake(0, 10, WIDTH(scrollViewPerson), 150)];
    IDPhotoAddView.tag = 20003;
    IDPhotoAddView.title = @"点击上传身份证（仅用于认证使用）";
    IDPhotoAddView.placeImage = IMAGENAMED(@"shangchuan");
    [scrollViewPerson addSubview:IDPhotoAddView];
    UIView* view;
    UILabel* label;
    if (self.type==0) {
        PhotoAdd* PICPhotoAddView = [[PhotoAdd alloc]initWithFrame:CGRectMake(X(IDPhotoAddView), POS_Y(IDPhotoAddView)+10, WIDTH(IDPhotoAddView), HEIGHT(IDPhotoAddView))];
        PICPhotoAddView.tag = 20004;
        PICPhotoAddView.placeImage = IMAGENAMED(@"touxiangshangchuan");
        PICPhotoAddView.title = @"点击上传头像（仅用于认证使用）";
        [scrollViewPerson addSubview:PICPhotoAddView];
        
        //填写信息
        view = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(PICPhotoAddView)+10, WIDTH(self.view), 100)];
        view.tag = 30001;
        view.layer.cornerRadius=5;
        view.backgroundColor  =WriteColor;
        [scrollViewPerson addSubview:view];
        
        //姓名
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, WIDTH(scrollViewPerson)*1/4, 30)];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"个人介绍";
        label.font = SYSTEMFONT(16);
        [view addSubview:label];
        
        //输入姓名
        nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(X(label)+15, POS_Y(label), WIDTH(view)-30, 30)];
        nameTextField.font  =SYSTEMFONT(16);
        nameTextField.tag = 500001;
        nameTextField.delegate = self;
        nameTextField.placeholder = @"请简单介绍自己";
        nameTextField.returnKeyType = UIReturnKeyDone;
        nameTextField.layer.borderColor =ColorTheme.CGColor;
        nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [view addSubview:nameTextField];
        
        UIImageView* lineView =[[UIImageView alloc]initWithFrame:CGRectMake(X(nameTextField), POS_Y(nameTextField), WIDTH(view)-30, 1)];
        lineView.backgroundColor  =BackColor;
        [view addSubview:lineView];
    }
    
    float pos_y = 0;
    if (self.type!=0) {
        pos_y = POS_Y(IDPhotoAddView)+10;
        //header
        view = [[UIView alloc]initWithFrame:CGRectMake(0, pos_y, WIDTH(scrollViewPerson), 30)];
        view.tag =30002;
        //头部
        label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, WIDTH(scrollViewPerson)-40, 20)];
        label.text = @"符合以下条件之一的机构投资者，可多选";
        label.font  =SYSTEMFONT(14);
        view.backgroundColor = WriteColor;
        [view addSubview:label];
        
        [scrollViewPerson addSubview:view];
    }else{
        UIView * v = [scrollViewPerson viewWithTag:20004];
        pos_y = POS_Y(v)+10;
        
        pos_y = POS_Y(view)+10;
        //header
        view = [[UIView alloc]initWithFrame:CGRectMake(0, pos_y, WIDTH(scrollViewPerson), 30)];
        view.tag =30002;
        //头部
        label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, WIDTH(scrollViewPerson)-40, 20)];
        label.text = @"符合以下条件之一的自然人投资者，可多选";
        label.font  =SYSTEMFONT(14);
        view.backgroundColor = WriteColor;
        [view addSubview:label];
        
        [scrollViewPerson addSubview:view];
    }
    //tableView
    CGRect rect=CGRectMake(0, POS_Y(view), WIDTH(scrollViewPerson),420);
    self.tableView=[[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.bounces=NO;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.scrollEnabled  =NO;
    self.tableView.allowsSelection=YES;
    self.tableView.delaysContentTouches=NO;
    self.tableView.backgroundColor=WriteColor;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [scrollViewPerson addSubview:self.tableView];
    
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), 30)];
    label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, WIDTH(view)-40, HEIGHT(view)-5)];
    label.numberOfLines = 2;
    label.font = SYSTEMFONT(10);
    label.textColor = FONT_COLOR_GRAY;
    label.lineBreakMode  =NSLineBreakByWordWrapping;
    
    [TDUtil setLabelMutableText:label content:@"备注：以上内容请参考《私募股权基金监督管理暂行办法（征求意见稿）》合格投资人规定" lineSpacing:3 headIndent:0];
    [view addSubview:label];
    
    self.tableView.tableFooterView = view;
    
    view = [[UIView alloc]initWithFrame:CGRectMake(10, 0, WIDTH(self.tableView)-20, HEIGHT(self.tableView))];
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 2;
    view.userInteractionEnabled = YES;
    view.backgroundColor = ClearColor;
    view.layer.borderColor  = FONT_COLOR_GRAY.CGColor;
    
    [self.tableView addSubview:view];
    [self.tableView sendSubviewToBack:view];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(40, POS_Y(self.tableView)+20, WIDTH(scrollViewPerson)-40, 0)];
    label.font = SYSTEMFONT(12);
    label.textColor  = BlackColor;
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(check:)]];
    label.textAlignment = NSTextAlignmentLeft;
    NSString* content =@"我已经认真阅读并同意";
    
    [TDUtil setLabelMutableText:label content:content lineSpacing:0 headIndent:0];
    [scrollViewPerson addSubview:label];
    [label setFrame:CGRectMake(X(label), Y(label), WIDTH(label), 40)];
    
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(label)+5, POS_Y(self.tableView)+20, WIDTH(scrollViewPerson)-40, 0)];
    label.font = SYSTEMFONT(12);
    label.userInteractionEnabled = YES;
    label.textColor = [UIColor blueColor];
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(protocolAction:)]];
    label.textAlignment = NSTextAlignmentLeft;
    content =@"《投资风险提示书》";
    [TDUtil setLabelMutableText:label content:content lineSpacing:0 headIndent:0];
    
    [label setFrame:CGRectMake(X(label), Y(label), WIDTH(label), 40)];
    
    [scrollViewPerson addSubview:label];
    
    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, Y(label)+10, 15, 15)];
    imgView.image = IMAGENAMED(@"queren");
    imgView.tag  =700001;
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(check:)]];
    [scrollViewPerson addSubview:imgView];
    
    
    NSString * title = @"提交资料";
    if (self.type==0) {
        title = @"下一步";
    }
    
    
    UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(60, POS_Y(label)+20, WIDTH(scrollViewPerson)-120, 35)];
    btnAction.layer.cornerRadius =5;
    btnAction.backgroundColor = AppColorTheme;
    [btnAction setTitle:title forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
    [scrollViewPerson addSubview:btnAction];
    
    [scrollViewPerson setupAutoContentSizeWithBottomView:btnAction bottomMargin:100];

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
    PhotoAdd * instance = [scrollViewPerson viewWithTag:20003];
    //检测是否已选择身份证
    if (!instance.image) {
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择上传身份证照片" ];
        return NO;
    }
    instance = [scrollViewPerson viewWithTag:20004];
    
    if (self.type!=1) {
        //检测是否已选择头像
        if (!instance.image) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请选择上传头像" ];
            return NO;
        }
        
        NSString * introduceStr = nameTextField.text;
        if (![TDUtil isValidString:introduceStr]) {
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入个人介绍" ];
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
    
    NSMutableDictionary* dataDic = [[NSMutableDictionary alloc]init];
    [dataDic setValue:str forKey:@"qualification"];
    
    [dataDic setValue:nameTextField.text forKey:@"profile"];
    [self.httpUtil getDataFromAPIWithOps:@"auth/" postParam:dataDic files:[NSDictionary dictionaryWithObjectsAndKeys:STATIC_USER_DEFAULT_ID_PIC,@"idpic",STATIC_USER_AUTH_ID_PIC,@"img", nil] type:0 delegate:self sel:@selector(requestUserInfo:)];
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
        CGRect frame=self.tableView.frame;
        frame.size.height=60;
        Cell=[[FinialProctoTableViewCell alloc]initWithFrame:frame];
    }
    NSInteger row = indexPath.row;
    row++;
    NSString* str = [NSString stringWithFormat:@"renzheng%ld 1",(long)row];
    NSDictionary* dic =[self.dataArray objectAtIndex:row-1];
    
    //填充行的详细内容
    [Cell setImageWithName:str setText:[dic valueForKey:@"value"]];
    
    //设置是否已经选择
    if ([array containsObject:dic]) {
        Cell.isSelected = YES;
    }
    
    //设置Cell背景颜色
    Cell.backgroundColor = ClearColor;
    
    //设置Cell样式
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
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
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger row =indexPath.row;
//    if (self.dataArray.count>0) {
//        NSDictionary* dic =[self.dataArray objectAtIndex:row];
//        
//        NSString* str = [dic valueForKey:@"value"];
//        if(str){
//            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, WIDTH(self.view)-100, 50)];
//            label.numberOfLines = 0 ;
//            label.font = SYSTEMFONT(14);
//            label.textColor =FONT_COLOR_GRAY;
//            label.lineBreakMode = NSLineBreakByWordWrapping;
//            
//            [TDUtil setLabelMutableText:label content:str lineSpacing:3 headIndent:0];
//            
//            heightsArray[row] =[NSString stringWithFormat:@"%f", POS_Y(label)+10];
//            
//            if (row==self.dataArray.count-1) {
//                float height;
//                for (int i = 0 ; i<self.dataArray.count;i++) {
//                    height += [heightsArray[i] floatValue];
//                }
//                
//                CGRect frame =self.tableView.frame;
//                frame.size.height = height+50;
//                [self.tableView setFrame:frame];
//                UIView* view =[scrollViewPerson viewWithTag:30003];
//                if (!view) {
//                    
//                    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(40, POS_Y(self.tableView)+20, WIDTH(scrollViewPerson)-40, 20)];
//                    label.font = SYSTEMFONT(12);
//                    label.userInteractionEnabled = YES;
//                    [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(protocolAction:)]];
//                    label.textAlignment = NSTextAlignmentLeft;
//                    NSString* content =@"我已经认真阅读并同意 《投资风险提示书》";
//                    
//                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
//                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(10, [content length]-10)];
//                    
//                    label.attributedText = attributedString;//ios 6
//                    [scrollViewPerson addSubview:label];
//                    
//                    UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, Y(label)+5, 15, 15)];
//                    imgView.image = IMAGENAMED(@"queren");
//                    imgView.tag  =700001;
//                    imgView.userInteractionEnabled = YES;
//                    [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(check:)]];
//                    [scrollViewPerson addSubview:imgView];
//                    
//                    
//                    
//                    UIButton* btnAction =[[UIButton alloc]initWithFrame:CGRectMake(60, POS_Y(label)+20, WIDTH(scrollViewPerson)-120, 35)];
//                    btnAction.layer.cornerRadius =5;
//                    btnAction.backgroundColor = AppColorTheme;
//                    [btnAction setTitle:@"提交资料" forState:UIControlStateNormal];
//                    [btnAction addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
//                    [scrollViewPerson addSubview:btnAction];
//                }
//            }
//            return POS_Y(label)+10;
//        }else{
//            return 0;
//        }
//        
//    }
//    
//    
//    return 0;
//}
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    float width = self.tableView.frame.size.width;
    CGFloat h = [self cellHeightForIndexPath:indexPath cellContentViewWidth:width];
    return h;
}


- (CGFloat)cellHeightForIndexPath:(NSIndexPath *)indexPath cellContentViewWidth:(CGFloat)width
{
    
    if (!self.tableView.cellAutoHeightManager) {
        self.tableView.cellAutoHeightManager = [[SDCellAutoHeightManager alloc] init];
    }
    if (self.tableView.cellAutoHeightManager.contentViewWidth != width) {
        self.tableView.cellAutoHeightManager.contentViewWidth = width;
        [self.tableView.cellAutoHeightManager clearHeightCache];
    }
    UITableViewCell *cell = [self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:indexPath];
    self.tableView.cellAutoHeightManager.modelCell = cell;
    if (cell.contentView.width != width) {
        cell.contentView.width = width;
    }
    return [[self.tableView cellAutoHeightManager] cellHeightForIndexPath:indexPath model:nil keyPath:nil];
}



-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray=dataArray;
    [self.tableView reloadData];
}

/**
 *  刷新、重新加载数据
 */
-(void)refresh
{
    [super refresh];
    
    //重新加载数据
    [self loadData];
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
    if (currentPhotoTag==20003) {
        //保存头像
       [TDUtil saveCameraPicture:croppedImage fileName:STATIC_USER_DEFAULT_ID_PIC];
    }else{
        [TDUtil saveCameraPicture:croppedImage fileName:STATIC_USER_AUTH_ID_PIC];
        
    }
    
    photoView =(PhotoAdd*)[scrollViewPerson viewWithTag:currentPhotoTag];
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
            
            self.isNetRequestError  =YES;
        }else{
            //出错，网络请求出错
            self.isNetRequestError  =YES;
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
            if (self.type != 0) {
                //进度查看
                double delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    UserInfoAuthController* controller = [[UserInfoAuthController alloc]init];
                    controller.type=1;
                    [self.navigationController pushViewController:controller animated:YES];
                    [self removeFromParentViewController];
                });
                
                NSUserDefaults* dataStore = [NSUserDefaults standardUserDefaults];
                [dataStore setValue:@"None" forKey:@"auth"];
            }else{
                PersonalFinanceAuthViewController * controller = [[PersonalFinanceAuthViewController alloc]init];
                [self.navigationController pushViewController:controller animated:YES];
            }
            
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
        }else{
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
        }
        self.startLoading  = NO;
    }else{
        self.startLoading  = NO;
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络请求错误，请检查网络连接!"];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString* jsonString =[TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    self.isNetRequestError = YES;
    [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络请求错误，请检查网络连接!"];
}
//*********************************************************网络请求结束*****************************************************//

//*********************************************************UiTextField *****************************************************//
#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (selectedIndex ==0) {
        [scrollViewPerson setContentOffset:CGPointMake(0, 200) animated:YES];
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
