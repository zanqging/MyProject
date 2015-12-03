//
//  ReplyViewController.m
//  JinZhiTou
//
//  Created by air on 15/8/29.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "ReplyViewController.h"
#import "WeiboViewControlle.h"
#import <QuartzCore/QuartzCore.h>
@interface ReplyViewController ()<UITextViewDelegate,ASIHTTPRequestDelegate,UITextViewDelegate>
{
    UIButton* btnAction;
    UITextView* textView;
}
@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor=ColorTheme;
    //隐藏导航栏
    [self.navigationController.navigationBar setHidden:YES];
    //设置标题
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"撰写评论"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"投融资" forState:UIControlStateNormal];
    [self.navView.leftTouchView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];

    UIView* view  = [[UIView alloc]initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view)-POS_Y(self.navView))];
    view.backgroundColor = BackColor;
    [self.view addSubview:view];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(self.view)-20, 150)];
    textView.backgroundColor  = WriteColor;
    textView.delegate =self;
    textView.font = SYSTEMFONT(16);
    textView.returnKeyType = UIReturnKeyDone;
    [view addSubview:textView];
    
    btnAction = [[UIButton alloc]initWithFrame:CGRectMake(30, POS_Y(textView)+20, WIDTH(self.view)-60, 35)];
    btnAction.backgroundColor = AppColorTheme;
    btnAction.layer.cornerRadius = 5;
    [btnAction setTitle:@"发表" forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnAction setTitleColor:WriteColor forState:UIControlStateNormal];
    [view addSubview:btnAction];
}

-(void)back:(id)sender
{
    for (UIViewController* v in self.navigationController.childViewControllers) {
        if ([v isKindOfClass:WeiboViewControlle.class]) {
            WeiboViewControlle* controller = (WeiboViewControlle*)v;
            [controller loadData];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnAction:(id)sender
{
    //获取评论内容
    NSString* content = textView.text;
    
    //验证
    if ([TDUtil isValidString:content]) {
        NSString* url  =[TOPIC stringByAppendingFormat:@"%ld/",(long)self.project_id];
        [self.httpUtil getDataFromAPIWithOps:url postParam:[NSDictionary dictionaryWithObject:textView.text forKey:@"content"] type:0 delegate:self sel:@selector(requestSubmmit:)];
        self.startLoading =YES;
        self.isTransparent=YES;
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请输入评论内容"];
    }
}

-(void)requestSubmmit:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* code = [jsonDic valueForKey:@"code"];
        if ([code intValue] == 0) {
            self.isNetRequestError  =NO;
            [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            self.startLoading = NO;
            
            double delayInSeconds = 1.0;
            __block ReplyViewController* bself = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [bself back:nil];
            });
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textViewInstance
{
    [textViewInstance resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textViewInstance shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textViewInstance resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
