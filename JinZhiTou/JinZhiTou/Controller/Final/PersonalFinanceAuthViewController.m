//
//  PersonalFinanceAuthViewController.m
//  JinZhiTou
//
//  Created by air on 16/1/16.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import "PersonalFinanceAuthViewController.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import "UIView+SDAutoLayout.h"
#import "UserInfoAuthController.h"
#import <QuartzCore/QuartzCore.h>
@implementation PersonalFinanceAuthViewController
-(id)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

/**
 *  初始化设置
 */
-(void)setup
{
    //1.初始化控件
    _scrollView = [UIScrollView new];
    
    labelComment = [UILabel new];
    labelFoundSize = [UILabel new];
    labelFinanceCase = [UILabel new];
    
    textComment = [UITextView new];
    textFoundSize = [UITextView new];
    textFinanceCase = [UITextView new];
    
    commentLineView = [UIView new];
    sizeIntroduceLineView = [UIView new];
    caseLineView = [UIView new];
    
    contentView = [UIView new];
    
    bottomView = [UIView new];
    
    btnSubmit = [UIButton new];
    
    //2.设置属性
    _scrollView.backgroundColor = BackColor;
    labelComment.text = @"寄语";
    labelFoundSize.text = @"投资规模";
    labelFinanceCase.text = @"投资案例";
    
    labelComment.font = SYSTEMFONT(14);
    labelFoundSize.font = SYSTEMFONT(14);
    labelFinanceCase.font = SYSTEMFONT(14);
    
    
    textComment.tag = 1002;
    textComment.text = @"寄语";
    textComment.delegate = self;
    textComment.font = SYSTEMFONT(13);
    textComment.textColor = FONT_COLOR_GRAY;
    textComment.returnKeyType = UIReturnKeyDone;
    
    textFoundSize.tag = 1003;
    textFoundSize.delegate = self;
    textFoundSize.textColor = FONT_COLOR_GRAY;
    textFoundSize.text = @"请输入投资规模";
    textFoundSize.font = SYSTEMFONT(13);
    textFoundSize.returnKeyType = UIReturnKeyDone;
    
    textFinanceCase.tag = 1004;
    textFinanceCase.delegate = self;
    textFinanceCase.text = @"请输入投资案例";
    textFinanceCase.font = SYSTEMFONT(13);
    textFinanceCase.textColor = FONT_COLOR_GRAY;
    textFinanceCase.returnKeyType = UIReturnKeyDone;
    
    commentLineView.backgroundColor = FONT_COLOR_GRAY;
    sizeIntroduceLineView.backgroundColor = FONT_COLOR_GRAY;
    caseLineView.backgroundColor = FONT_COLOR_GRAY;
    
    contentView.backgroundColor = WriteColor;
    
    bottomView.backgroundColor = WriteColor;
    
    [btnSubmit addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setTitle:@"提交资料" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:WriteColor forState:UIControlStateNormal];
    [btnSubmit setBackgroundColor:AppColorTheme];
    btnSubmit.layer.cornerRadius = 5;
    
    //3.添加到试图
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:contentView];
    
    [contentView addSubview:labelComment];
    [contentView addSubview:labelFoundSize];
    [contentView addSubview:labelFinanceCase];
    
    [contentView addSubview:textComment];
    [contentView addSubview:textFoundSize];
    [contentView addSubview:textFinanceCase];
    
    
    [contentView addSubview:caseLineView];
    [contentView addSubview:commentLineView];
    [contentView addSubview:sizeIntroduceLineView];
    
    [_scrollView addSubview:bottomView];
    
    [bottomView addSubview:btnSubmit];
    
    //自适应
    _scrollView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(kTopBarHeight+kStatusBarHeight,0, 0, 0));
    
    contentView.sd_layout
    .leftSpaceToView(_scrollView, 20)
    .rightSpaceToView(_scrollView, 20)
    .topSpaceToView(_scrollView, 20);
    
    
    labelComment.sd_layout
    .topSpaceToView(contentView,20)
    .leftSpaceToView(contentView,20)
    .autoHeightRatio(0);
    
    [labelComment setSingleLineAutoResizeWithMaxWidth:200];
    
    textComment.sd_layout
    .leftEqualToView(labelComment)
    .topSpaceToView(labelComment,5)
    .widthIs(WIDTH(self.view)-80)
    .heightIs(30);
    
    commentLineView.sd_layout
    .topSpaceToView(textComment,5)
    .leftEqualToView(textComment)
    .widthRatioToView(textComment,1)
    .heightIs(1);
    
    labelFoundSize.sd_layout
    .topSpaceToView(commentLineView,20)
    .leftEqualToView(labelComment)
    .autoHeightRatio(0);
    
    [labelFoundSize setSingleLineAutoResizeWithMaxWidth:200];
    
    textFoundSize.sd_layout
    .leftEqualToView(labelFoundSize)
    .topSpaceToView(labelFoundSize,5)
    .widthIs(WIDTH(self.view)-80)
    .heightIs(30);
    
    sizeIntroduceLineView.sd_layout
    .topSpaceToView(textFoundSize,5)
    .leftEqualToView(textFoundSize)
    .widthRatioToView(textFoundSize,1)
    .heightIs(1);
    
    labelFinanceCase.sd_layout
    .topSpaceToView(sizeIntroduceLineView,20)
    .leftEqualToView(labelComment)
    .autoHeightRatio(0);
    
    [labelFinanceCase setSingleLineAutoResizeWithMaxWidth:200];
    
    textFinanceCase.sd_layout
    .leftEqualToView(labelFinanceCase)
    .topSpaceToView(labelFinanceCase,5)
    .widthIs(WIDTH(self.view)-80)
    .heightIs(30);
    
    caseLineView.sd_layout
    .topSpaceToView(textFinanceCase,5)
    .leftEqualToView(textFinanceCase)
    .widthRatioToView(textFinanceCase,1)
    .heightIs(1);
    
    [contentView setupAutoHeightWithBottomView:caseLineView bottomMargin:20];
    
    //底部视图
    bottomView.sd_layout
    .leftEqualToView(_scrollView)
    .topSpaceToView(contentView,50)
    .rightEqualToView(_scrollView)
    .heightIs(60);
    
    btnSubmit.sd_layout
    .topSpaceToView(bottomView,10)
    .bottomSpaceToView(bottomView,10)
    .leftSpaceToView(bottomView,30)
    .rightSpaceToView(bottomView,30);
    
    
    [_scrollView setupAutoContentSizeWithBottomView:bottomView bottomMargin:50];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    //网络初始化
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"提交信息"];
    self.navView.titleLable.textColor=WriteColor;
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"认证" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
}

-(void)submitAction:(id)sender
{
    // 提交认证数据
    NSMutableDictionary * postDic = [[NSMutableDictionary alloc]init];
    [postDic setValue:textComment.text forKey:@"signature"];
    [postDic setValue:textFoundSize.text forKey:@"investplan"];
    [postDic setValue:textFinanceCase.text forKey:@"investcase"];
    [self.httpUtil getDataFromAPIWithOps:@"authpersonoptional/" postParam:postDic type:0 delegate:self sel:@selector(requestFinished:)];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)tv
{
    NSInteger  tag = tv.tag;
    switch (tag) {
        case 1001:
            replyContent = @"请您输入简单个人介绍";
            break;
        case 1002:
            replyContent = @"寄语";
            break;
        case 1003:
            replyContent = @"请输入投资规模";
            [_scrollView setContentOffset:CGPointMake(0, 50)];
            break;
        case 1004:
            replyContent = @"请输入投资案例";
            [_scrollView setContentOffset:CGPointMake(0, 100)];
            break;
        default:
            replyContent = @"请您输入简单个人介绍";
            break;
    }
    //获取UiTextView 提示内容
    if ([tv.text isEqualToString:replyContent]) {
        tv.text = @"";
    }
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)tv
{
    
}

-(void)textViewDidEndEditing:(UITextView *)tv
{
    if ([tv.text isEqualToString:@""]) {
        tv.text=replyContent;
        tv.textColor  =LightGrayColor;
    }
}


-(void)textViewDidChange:(UITextView *)tv
{
    if ([tv.text containsString:replyContent]) {
        tv.text=@"";
        tv.textColor  =FONT_COLOR_BLACK;
    }else if ([tv.text isEqualToString:@""]){
        tv.text=replyContent;
        tv.textColor  =LightGrayColor;
    }
    
    tv.sd_layout
    .heightIs(tv.contentSize.height);
    
    NSInteger  tag = tv.tag;
    CGFloat move_y = 0;
    switch (tag) {
        case 1002:
            move_y = HEIGHT(tv);
            break;
        case 1003:
            move_y = HEIGHT(tv)+50;
            break;
        case 1004:
            move_y = HEIGHT(tv)+100;
            break;
        default:
            break;
    }
    [_scrollView setContentOffset:CGPointMake(0, move_y)];
}

-(void)textViewDidChangeSelection:(UITextView *)tv
{
    //    NSLog(@"-----%@",tv.text);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [textView resignFirstResponder];
        
        NSInteger tag = textView.tag;
        
        if (tag==1004) {
            [_scrollView setContentOffset:CGPointMake(0, 0)];
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


#pragma ASIHttpRequest
-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* code = [dic valueForKey:@"code"];
        if ([code integerValue] == 0) {
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

        }
        
        self.startLoading = NO;
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[dic valueForKey:@"msg"]];
    }
}


-(void)requestFailed:(ASIFormDataRequest*)request
{
//    self.isNetRequestError = YES;
     [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"网络请求失败，请重新提交!"];
}
@end
