

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#import "MessageViewController.h"
#import "TDUtil.h"
#import "HttpUtils.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "LoadingUtil.h"
#import "LoadingView.h"
#import "GlobalDefine.h"
#import "NSString+SBJSON.h"
#import "MyTableViewCell.h"
#import "ASIFormDataRequest.h"
#import "DAKeyboardControl.h"
@interface MessageViewController ()<ASIHTTPRequestDelegate,UITextViewDelegate>
{
    NSInteger rowCount;
    BOOL isRefresh;
    int currentPage;
    UITextView *textView;
    HttpUtils* httpUtils;
    LoadingView* loadingView;
    NSString* atTopId;
}
@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setHidden:YES];
    [super viewDidLoad];
    self.view.backgroundColor = ColorTheme;
    //设置标题
    self.navView=[[NavView alloc]initWithFrame:CGRectMake(0,NAVVIEW_POSITION_Y,self.view.frame.size.width,NAVVIEW_HEIGHT)];
    self.navView.imageView.alpha=1;
    [self.navView setTitle:@"消息回复"];
    self.navView.titleLable.textColor=WriteColor;
    
    [self.navView.leftButton setImage:nil forState:UIControlStateNormal];
    [self.navView.leftButton setTitle:@"与我相关" forState:UIControlStateNormal];
    [self.navView.leftButton addTarget:self action:@selector(back:)forControlEvents:UIControlEventTouchUpInside];
    
    self.navView.title  =self.titleStr;
    
    [self.navView.backView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back:)]];
    [self.view addSubview:self.navView];

    
    if (_customTableView == nil) {
        _customTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, POS_Y(self.navView), WIDTH(self.view), HEIGHT(self.view) -POS_Y(self.navView))];
        _customTableView.delegate = self;
        _customTableView.dataSource = self;
        _customTableView.backgroundColor = WriteColor;
        
        [TDUtil tableView:_customTableView.homeTableView target:self refreshAction:@selector(refreshProject) loadAction:@selector(loadProject)];
    }
    rowCount = 0;
    [self.view addSubview:_customTableView];
    
    httpUtils = [[HttpUtils alloc]init];
    loadingView = [LoadingUtil shareinstance:self.view];
    [LoadingUtil show:loadingView];
    
    [self refreshProject];
    
    if (self.type==0) {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                         self.view.bounds.size.height - 40.0f,
                                                                         self.view.bounds.size.width,
                                                                         40.0f)];
        toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:toolBar];
        
        textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f,
                                                                6.0f,
                                                                toolBar.bounds.size.width - 20.0f - 68.0f,
                                                                30.0f)];
        textView.delegate =self;
        textView.font =SYSTEMFONT(18);
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [toolBar addSubview:textView];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [sendButton setTitle:@"发表" forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(submmit:) forControlEvents:UIControlEventTouchUpInside];
        sendButton.frame = CGRectMake(toolBar.bounds.size.width - 68.0f,
                                      6.0f,
                                      58.0f,
                                      29.0f);
        [toolBar addSubview:sendButton];
        
        
        self.view.keyboardTriggerOffset = toolBar.bounds.size.height;
        
        [self.view addKeyboardPanningWithActionHandler:^(CGRect keyboardFrameInView) {
            CGRect toolBarFrame = toolBar.frame;
            toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
            toolBar.frame = toolBarFrame;
        }];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showyboard:) name:@"showKeyboard" object:nil];
        
        [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddeKeyboard:)]];
    }
    
}

-(void)showyboard:(id)sender
{
    if ([sender isKindOfClass:NSNotification.class]) {
        NSDictionary* dic =  (NSDictionary* )sender;
        atTopId = [[dic valueForKey:@"userInfo"] valueForKey:@"id"];
        self.project_id =[[[dic valueForKey:@"userInfo"] valueForKey:@"pid"] integerValue];
    }
    [textView becomeFirstResponder];
}

-(void)hiddeKeyboard:(id)sender
{
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
}

-(void)submmit:(NSDictionary* )userInfo
{
    NSString* str = textView.text;
    
    if ([TDUtil isValidString:str]) {
        NSString* url  =[TOPIC stringByAppendingFormat:@"%ld/",(long)self.project_id];
        NSMutableDictionary* dic  =[[NSMutableDictionary alloc]init];
        [dic setValue:textView.text forKey:@"content"];
        [dic setValue:atTopId forKey:@"at_topic"];

        [httpUtils getDataFromAPIWithOps:url postParam:dic type:0 delegate:self sel:@selector(requestSubmmit:)];
    }else{
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:@"请先输入内容"];
    }
    
}


-(void)refreshProject
{
    isRefresh =YES;
    currentPage = 0;
    [_customTableView.homeTableView.header endRefreshing];
    
     if (self.type==0) {
         NSString * url = [MY_TOPIC_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
         [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
     }else{
         NSString * url = [MY_SYSTEM_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
         [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
     }
    
}

-(void)loadProject
{
    isRefresh =NO;
    if (self.type==0) {
        //消息回复
        if (!self.isEndOfPageSize) {
            currentPage++;
            NSString * url = [MY_TOPIC_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
            [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
        }else{
            [self.customTableView.homeTableView.footer endRefreshing];
            isRefresh =NO;
        }

    }else{
        if (!self.isEndOfPageSize) {
            currentPage++;
            NSString * url = [MY_SYSTEM_LIST stringByAppendingString:[NSString stringWithFormat:@"%ld/",(long)currentPage]];
            [httpUtils getDataFromAPIWithOps:url postParam:nil type:0 delegate:self sel:@selector(requestTopicList:)];
        }else{
            [self.customTableView.homeTableView.footer endRefreshing];
            isRefresh =NO;
        }
    }
    [_customTableView.homeTableView.footer endRefreshing];
}


-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray  = dataArray;
    if (self.dataArray.count>0) {
         rowCount  =self.dataArray.count;
    }else{
        [self.customTableView.homeTableView setContent:@"暂无数据"];
    }
    [self.customTableView.homeTableView reloadData];
}

-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    
    NSInteger row  = aIndexPath.row;
    NSDictionary* dic  =self.dataArray[row];
    NSString* content =[dic valueForKey:@"content"];
    
    NSInteger lenght = [TDUtil convertToInt:content];
    NSInteger lines = lenght / 16;
    if (lines<=0) {
        lines = 1;
    }
    float height = lines *20;
    return height+80;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
}

-(void)didDeleteCellAtIndexpath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    NSLog(@"删除");
    NSDictionary* dic =self.dataArray[aIndexPath.row];
    NSString* serverUrl;
    if (self.type==0) {
        serverUrl= [settopicread stringByAppendingFormat:@"%@/",[dic valueForKey:@"id"]];
    }else{
        serverUrl= [deletemsgread stringByAppendingFormat:@"%@/",[dic valueForKey:@"id"]];
    }
    
    [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestFinished:)];
}

-(void)didMoreCellAtIndexpath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView
{
    NSDictionary* dic  =self.dataArray[aIndexPath.row];
    [[NSNotificationCenter  defaultCenter]postNotificationName:@"showKeyboard" object:nil userInfo:dic];
}

-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView{
    return self.dataArray.count;
}

-(SlideTableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    static NSString *vCellIdentify = @"sliderCell";
    
    MyTableViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vCellIdentify];
        if (self.type!=0) {
            [vCell hiddenMoreButton];
        }
    }
    NSInteger row  = aIndexPath.row;
    NSDictionary* dic  =self.dataArray[row];
    [vCell setName: [dic valueForKey:@"name"]];
    [vCell setContent:[dic valueForKey:@"content"]];
    vCell.timeLabel.text = [dic valueForKey:@"create_datetime"];
    
    NSURL* url = [NSURL URLWithString:[dic valueForKey:@"img"]];
    [vCell.imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember")];
    aTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    return vCell;
}

-(void)refreshData:(void (^)())complete FromView:(CustomTableView *)aView
{
    
}

-(void)loadData:(void (^)(int))complete FromView:(CustomTableView *)aView
{
    
}
- (IBAction)touched:(UIButton *)sender {

}

-(void)requestFinished:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"updateStatus" object:nil];
        }
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
        [self refreshProject];
    }
}

-(void)requestTopicList:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0 || [status intValue] == -1) {
            if (isRefresh) {
                self.dataArray =nil;
                self.dataArray = [jsonDic valueForKey:@"data"];
            }else{
                if (!self.dataArray) {
                    self.dataArray = [jsonDic valueForKey:@"data"];
                }else{
                    [self.dataArray addObjectsFromArray:[jsonDic valueForKey:@"data"]];
                    [self.customTableView.homeTableView reloadData];
                }
            }
            [LoadingUtil close:loadingView];
            
            if ([status integerValue]==-1) {
                [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
            }
        }
    }
}

-(void)requestSubmmit:(ASIHTTPRequest *)request{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary* jsonDic = [jsonString JSONValue];
    
    if(jsonDic!=nil)
    {
        NSString* status = [jsonDic valueForKey:@"status"];
        if ([status intValue] == 0) {
            loadingView.isError = NO;
            self.customTableView.homeTableView.content = [jsonDic valueForKey:@"msg"];
            
            currentPage = 0;
            [self refreshProject];
        }
        
        //隐藏键盘
        [self hiddeKeyboard:nil];
        //清空数据
        textView.text =@"";
        
        [[DialogUtil sharedInstance]showDlg:self.view textOnly:[jsonDic valueForKey:@"msg"]];
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    NSLog(@"返回:%@",jsonString);
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
