//
//  WeiboTableViewCell.m
//  Cycle
//
//  Created by air on 15/10/12.
//  Copyright © 2015年 csz. All rights reserved.
//

#import "WeiboTableViewCell.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "DialogUtil.h"
#import "GlobalDefine.h"
#import "UIReplyLabel.h"
#import "UILabel+Data.h"
#import "NSString+SBJSON.h"
#import <QuartzCore/QuartzCore.h>
@implementation WeiboTableViewCell

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //头像
        self.headerImgView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.headerImgView.image  =IMAGENAMED(@"coremember");
        self.headerImgView.userInteractionEnabled  =YES;
        [self addSubview:self.headerImgView];
        
        //名称
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.headerImgView)+10, Y(self.headerImgView), 50, 14)];
        self.nameLabel.font = FONT(@"Arial", 14);
        self.nameLabel.textColor = [UIColor colorWithRed:211.0f/255.0 green:161.0f/255.0 blue:36.0f/255.0 alpha:1];
        self.nameLabel.userInteractionEnabled = YES;
        [self addSubview:self.nameLabel];
        
        //公司
        self.companyLabel  = [[ UILabel alloc]initWithFrame:CGRectMake(POS_X(self.nameLabel), Y(self.nameLabel), 5, HEIGHT(self.nameLabel))];
        self.companyLabel.font  =FONT(@"Arial", 14);
        self.companyLabel.textColor  =FONT_COLOR_GRAY;
        [self addSubview:self.companyLabel];
        
        float position1 =WIDTH(self);
        float position2 =POS_X(self.companyLabel);
        //职务
        self.jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.companyLabel), Y(self.companyLabel), position1-position2-30, HEIGHT(self.companyLabel))];
        self.jobLabel.font = FONT(@"Arial", 14);
        self.jobLabel.textColor  = FONT_COLOR_GRAY;
        [self addSubview:self.jobLabel];
        
        //行业
        position1 =WIDTH(self);
        position2 =X(self.nameLabel);
        self.industryLabel  =[[ UILabel alloc]initWithFrame:CGRectMake(X(self.nameLabel), POS_Y(self.nameLabel)+10, position1-position2-10, HEIGHT(self.nameLabel))];
        self.industryLabel.font = FONT(@"Arial", 14);
        self.industryLabel.textColor = FONT_COLOR_GRAY;
        [self addSubview:self.industryLabel];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.industryLabel), POS_Y(self.industryLabel)+5, WIDTH(self.industryLabel), 80)];
        self.contentLabel.font  =FONT(@"Arial", 14);
        self.contentLabel.textColor  =FONT_COLOR_BLACK;
        self.contentLabel.numberOfLines  =5;
        self.contentLabel.userInteractionEnabled  =YES;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.contentLabel];
        
    }
    return self;
}

-(void)setTableViewFrame:(UIView*)v replyDataHeigt:(NSInteger)height
{
    if (!self.tableView) {
        if (self.dataArray.count>0) {
            if (v.frame.size.height>0) {
                self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , POS_Y(v), WIDTH(self.priseView),height)];
            }else{
                self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0 ,10, WIDTH(self.priseView), height)];
            }
        }else{
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , POS_Y(v)+5, WIDTH(self.priseView), 0)];
        }
        NSLog(@"tableView frame:%@",NSStringFromCGRect(self.tableView.frame));
        self.tableView.bounces=NO;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.scrollEnabled =  NO;
        self.tableView.allowsSelection=YES;
        self.tableView.delaysContentTouches=NO;
        self.tableView.showsVerticalScrollIndicator=NO;
        self.tableView.showsHorizontalScrollIndicator=NO;
        self.tableView.backgroundColor = ClearColor;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self.priseView addSubview:self.tableView];
    }else{
        if (self.dataArray.count>0) {
            [self.tableView setFrame:CGRectMake(0 , POS_Y(v)+15, WIDTH(self.priseView), HEIGHT(self.priseView)-10)];
        }else{
            [self.tableView setFrame:CGRectMake(0 , POS_Y(v)+5, WIDTH(self.priseView), 0)];
        }
    }
   
   
}
-(void)commentAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(weiboTableViewCell:contentId:atId:isSelf:)]) {
        [_delegate weiboTableViewCell:self contentId:[self.dic valueForKey:@"id"] atId:nil isSelf:NO];
    }
}

-(void)priseAction:(id)sender
{
    if (!httpUtils) {
        httpUtils = [[HttpUtils alloc]init];
    }
    if([self.dic valueForKey:@"id"]){
        NSString* serverUrl = [CYCLE_CONTENT_PRISE stringByAppendingFormat:@"%@/%d/",[self.dic
                                                                                      valueForKey:@"id"],[[self.dic valueForKey:@"is_like"] boolValue]];
        [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestPriseFinished:)];
    }
    
}

-(void)shareAction:(id)sender
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"分享消息" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)deleteAction:(id)sender
{
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alertView.tag  = [[self.dic valueForKey:@"id"] integerValue];
    alertView.delegate = self;
    [alertView show];
    currentTag =1;

}

-(void)showContent:(id)sender
{
    if ([_delegate respondsToSelector:@selector(weiboTableViewCell:didSelectedContent:)]) {
        [_delegate weiboTableViewCell:self didSelectedContent:YES];
    }
}

- (IBAction)expandAction:(id)sender {
//    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"展开/收缩:%d",self.expandButton.isSelected] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alertView show];
    //[self UserInfoAction:self.nameLabel.gestureRecognizers[0]];
    [self showContent:nil];
}

-(void)UserInfoAction:(UITapGestureRecognizer*)sender
{
    UILabel* label = (UILabel*)sender.view;
    if ([_delegate respondsToSelector:@selector(weiboTableViewCell:userId:isSelf:)]) {
        NSString* userId =@"";
        if ([label isKindOfClass:UILabel.class]) {
            userId = label.index;
        }else{
            UIView* v =sender.view;
            userId = [NSString stringWithFormat:@"%ld", v.tag];
        }
        
        [_delegate weiboTableViewCell:self userId:userId isSelf:NO];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic =self.dataArray[indexPath.row];
    currentSelectedCellIndex = indexPath;
    if(![[dic valueForKey:@"flag"] boolValue]){
        if ([_delegate respondsToSelector:@selector(weiboTableViewCell:contentId:atId:isSelf:)]) {
            [_delegate weiboTableViewCell:self contentId:[self.dic valueForKey:@"id"] atId:[dic valueForKey:@"id"] isSelf:NO];
        }
    }else{
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:@"删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        alertView.tag  = [[dic valueForKey:@"id"] integerValue];
        alertView.delegate = self;
        [alertView show];
        currentTag = 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dic  = self.dataArray[indexPath.row];
    NSString* name  = [dic valueForKey:@"name"];
    NSString* atLabel = [dic valueForKey:@"at_label"];
    NSString* atName = [dic valueForKey:@"at_name"];
    NSString* suffix =  [dic valueForKey:@"label_suffix"];
    NSString* content =  [dic valueForKey:@"content"];
    NSString* str = name;
    if (atLabel) {
        str = [str stringByAppendingString:atLabel];
    }
    
    if (atName) {
        str = [str stringByAppendingString:atName];
    }
    
    if (suffix) {
        str = [str stringByAppendingString:suffix];
    }
    
    if (content) {
        str = [str stringByAppendingString:content];
    }

    NSInteger line = [TDUtil convertToInt:str]/17;
    if (line>0) {
        return (line+1)*13+10;
    }else{
        return 23;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //声明静态字符串对象，用来标记重用单元格
    NSString* TableDataIdentifier=@"ReplyTableViewCell";
    //用TableDataIdentifier标记重用单元格
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:TableDataIdentifier];
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    if (!cell) {
        //cell  =  [[ReplyTableViewCell alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableDataIdentifier];
    }
    
    UIReplyLabel* label = [[UIReplyLabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.tableView), height)];
    label.userInteractionEnabled = YES;
    
    NSDictionary* dic  = self.dataArray[indexPath.row];
    NSString* name  = [dic valueForKey:@"name"];
    NSString* atLabel = [dic valueForKey:@"at_label"];
    NSString* atName = [dic valueForKey:@"at_name"];
    NSString* suffix =  [dic valueForKey:@"label_suffix"];
    NSString* content =  [dic valueForKey:@"content"];
    NSString* str = name;
    if (name) {
        //监听事件
        label.nameLabel.userInteractionEnabled  =YES;
        [label.nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UserInfoAction:)]];
        [label setName:name];
    }
    
    if (atLabel) {
        str = [str stringByAppendingString:atLabel];
        [label setAtString:atLabel];
    }
    
    if (atName) {
        str = [str stringByAppendingString:atName];
        label.atNameLabel.userInteractionEnabled  =YES;
        [label.atNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UserInfoAction:)]];
        [label setAtName:atName];
    }
    
    if (suffix) {
        str = [str stringByAppendingString:suffix];
        [label setSuffix:suffix];
    }
    
    if (content) {
        str = [str stringByAppendingString:content];
        [label setContent:content];
    }
    
    
    [cell addSubview:label];
    //cell.backgroundColor = [UIColor colorWithRed:238.0f/255.0 green:238.0f/255.0 blue:238.0f/255.0 alpha:1];
    cell.backgroundColor = ClearColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}



-(void)showImage:(UITapGestureRecognizer*)sender
{
    NSMutableArray* dataArray = [self.dic valueForKey:@"pics"];
    
    MWPhoto* photo;
    NSMutableArray* thumbs = [NSMutableArray new];
    
    for (int i= 0 ; i <dataArray.count;i++) {
        if ([dataArray[i] isKindOfClass:NSString.class]) {
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:dataArray[i]]];
        }else if ([dataArray[i] isKindOfClass:UIImage.class]){
             photo = [MWPhoto photoWithImage:dataArray[i]];
        }
        [thumbs addObject:photo];
    }
    self.thumbs = thumbs;
    
    UIImageView* imageView = (UIImageView*)(sender.view);
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    BOOL autoPlayOnAppear = NO;
    
    displayActionButton = NO;
    displaySelectionButtons = NO;
    startOnGrid = YES;
    enableGrid = YES;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableSwipeToDismiss = NO;
    browser.displayNavArrows = displayNavArrows;
    browser.autoPlayOnAppear = autoPlayOnAppear;
    browser.displayActionButton = displayActionButton;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.displaySelectionButtons = displaySelectionButtons;
    [browser setCurrentPhotoIndex:imageView.tag];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [[UIApplication sharedApplication].windows[0].rootViewController presentViewController:nc animated:YES completion:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (currentTag==0) {
            if (!httpUtils) {
                httpUtils = [[HttpUtils alloc]init];
            }
            NSString* serverUrl = [CYCLE_CONTENT_REPLY_DELETE stringByAppendingFormat:@"%ld/",alertView.tag];
            [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestDeleteReplyFinished:)];
        }else{
            if (!httpUtils) {
                httpUtils = [[HttpUtils alloc]init];
            }
            NSString* serverUrl = [CYCLE_CONTENT_DELETE stringByAppendingFormat:@"%@/",[self.dic
                                                                                        valueForKey:@"id"]];
            [httpUtils getDataFromAPIWithOps:serverUrl postParam:nil type:0 delegate:self sel:@selector(requestDeleteFinished:)];
        }
        
    }
}

-(void)setDic:(NSMutableDictionary *)dic
{
    if (dic) {
        self->_dic =dic;
        //事件
        if ([dic valueForKey:@"id"]) {
            [self.headerImgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UserInfoAction:)]];
            [self.nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UserInfoAction:)]];
        }
        
        //头像
        NSURL* url = [NSURL URLWithString:[dic valueForKey:@"photo"]];
        self.headerImgView.tag = [[self.dic valueForKey:@"uid"] integerValue];
        [self.headerImgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember")];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        [paragraphStyle setLineSpacing:5.f];//调整行间距
        
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        
        [paragraphStyle setHeadIndent:-50];
        
        NSString* content = [dic valueForKey:@"name"];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        self.nameLabel.attributedText = attributedString;//ios 6
        self.nameLabel.tag = [[self.dic valueForKey:@"uid"] integerValue];
        self.nameLabel.index =[self.dic valueForKey:@"uid"];
        [self.nameLabel sizeToFit];
        
        //内容
        content = [[dic valueForKey:@"position"] objectAtIndex:0];
        if (content) {
            attributedString = [[NSMutableAttributedString alloc] initWithString:content];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
            self.jobLabel.attributedText = attributedString;//ios 6
            [self.jobLabel sizeToFit];
        }

        
        [self.jobLabel setFrame:CGRectMake(POS_X(self.nameLabel)+5, Y(self.nameLabel),WIDTH(self.jobLabel), HEIGHT(self.jobLabel))];
        
        self.industryLabel.text = [dic valueForKey:@"city"];
        
        //内容
        content = [dic valueForKey:@"content"];
        attributedString = [[NSMutableAttributedString alloc] initWithString:content];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
        self.contentLabel.attributedText = attributedString;//ios 6
        [self.contentLabel sizeToFit];
        
        int numlines = [TDUtil  convertToInt:content]/17;
        
        if (numlines>5) {
            self.expandButton = [[UIButton alloc]initWithFrame:CGRectMake(X(self.contentLabel)-15, POS_Y(self.contentLabel)-15, 50, 50)];
            self.expandButton.titleLabel.font  =FONT(@"Arial", 12);
            [self.expandButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.expandButton setTitle:@"全文" forState:UIControlStateNormal];
            [self.expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.expandButton];
            
            [self.contentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showContent:)]];
        }
        

        
        if ([[dic valueForKey:@"flag"] boolValue] && [dic valueForKey:@"id"]) {
            if (self.expandButton) {
                self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(POS_X(self.expandButton), Y(self.expandButton), 50, 50)];
            }else{
                self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(X(self.contentLabel)-15, POS_Y(self.contentLabel)-15, 50, 50)];
            }
            self.deleteButton.titleLabel.font  =FONT(@"Arial", 12);
            [self.deleteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
            [self.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.deleteButton];
        }
        //时间
        if (self.expandButton || self.deleteButton) {
            self.dateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.contentLabel), POS_Y(self.contentLabel)+20, 100, 20)];
        }else{
            self.dateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.contentLabel), POS_Y(self.contentLabel)+5, 100, 20)];
        }
        self.dateTimeLabel.font  =FONT(@"Arial", 10);
        self.dateTimeLabel.text = [dic valueForKey:@"datetime"];
        self.dateTimeLabel.textColor  =FONT_COLOR_GRAY;
        [self addSubview:self.dateTimeLabel];
        
        
        NSArray* pics =[self.dic valueForKey:@"pics"];
        NSInteger value = pics.count;
        NSInteger number = value/3;
        
        if ( value % 3 !=0) {
            number++;
        }else if (value<3 && value >0){
            number++;
        }
        self.imgContentView = [[UIView alloc]initWithFrame:CGRectMake(X(self.contentLabel), POS_Y(self.dateTimeLabel)+10,240, number*80)];
        [self addSubview:self.imgContentView];
        
        UIImageView* imgView;
        float pos_x =0,pos_y=0;
        number = 0;
        NSMutableArray* array =[NSMutableArray new];
        for (int i = 0; i < value; i ++) {
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(pos_x, pos_y, 70, 70)];
            imgView.tag = i;
            imgView.layer.masksToBounds = YES;
            imgView.userInteractionEnabled  = YES;
            [self.imgContentView addSubview:imgView];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            id obj =[pics objectAtIndex:i];
            if ([obj isKindOfClass:NSString.class]) {
                NSURL* url =[NSURL URLWithString:[pics objectAtIndex:i]];
                [imgView sd_setImageWithURL:url placeholderImage:IMAGENAMED(@"coremember")];
            }else if ([obj isKindOfClass:UIImage.class]){
                [imgView setImage:[pics objectAtIndex:i]];
            }
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImage:)]];
            
            [array addObject:[NSString stringWithFormat:@"%d",i+1]];
            pos_x += 70+10;
            
            if ((i+1)%3==0) {
                pos_x = 0;
                pos_y += 70+10;
                number++;
            }
        }
        
//        NSMutableDictionary* dictemp = [[NSMutableDictionary alloc]init];
//        
//        [dictemp setValue:array forKey:@"imageName"];
        
        //分享点赞
        self.funView = [[UIView alloc]initWithFrame:CGRectMake(X(self.contentLabel), POS_Y(self.imgContentView), WIDTH(self)-80, 30)];
        [self addSubview:self.funView];
        
        
        //点赞，分享,评论
        NSMutableArray* dataCriticalArray = [self.dic valueForKey:@"comment"];
        self.dataArray = dataCriticalArray;
        
        //评论
        self.criticalButton = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH(self.funView)-70, 0, 50, 30)];
        [self.criticalButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [self.criticalButton setTitle:[NSString stringWithFormat:@"%ld",dataCriticalArray.count] forState:UIControlStateNormal];
        [self.criticalButton.titleLabel setFont:FONT(@"Arial", 13)];
        [self.criticalButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.criticalButton setImage:IMAGENAMED(@"gossip_comment") forState:UIControlStateNormal];
        [self.funView addSubview:self.criticalButton];
        
        
        //点赞
        NSMutableArray* dataPriseArray = [self.dic valueForKey:@"likers"];
        self.priseButton = [[UIButton alloc]initWithFrame:CGRectMake(X(self.criticalButton)-50, Y(self.criticalButton), WIDTH(self.criticalButton), HEIGHT(self.criticalButton))];
        [self.priseButton setTitleColor:FONT_COLOR_GRAY forState:UIControlStateNormal];
        [self.priseButton setTitle:[NSString stringWithFormat:@"%ld",dataPriseArray.count] forState:UIControlStateNormal];
        [self.priseButton.titleLabel setFont:FONT(@"Arial", 13)];
        [self.priseButton addTarget:self action:@selector(priseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.priseButton setImage:IMAGENAMED(@"gossip_like_normal") forState:UIControlStateNormal];
        [self.funView addSubview:self.priseButton];
        
        [self setPriseListData];
        
    
    }
}

-(void)setPriseListData
{
    //点赞评论区域
    NSArray* dataPriseArray = [self.dic valueForKey:@"likers"];
    if (!self.priseView) {
        self.priseView = [[UIView alloc]initWithFrame:CGRectMake(X(self.contentLabel), POS_Y(self.funView)+5, WIDTH(self.funView), 13)];
        [self addSubview:self.priseView];
    }else{
        [self.priseView setFrame:CGRectMake(X(self.contentLabel), POS_Y(self.funView), WIDTH(self.funView), 10)];
    }
    
    self.priseView.layer.cornerRadius = 5;
//    self.priseView.backgroundColor = [UIColor colorWithRed:238.0f/255.0 green:238.0f/255.0 blue:238.0f/255.0 alpha:1];
    
    self.priseListView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.priseView),20)];
    [self.priseView addSubview:self.priseListView];
    
    UILabel* label;
    float pos_x =30,pos_y =5;
    NSDictionary* dic;
    int num=0;
    for (int i = 0; i<dataPriseArray.count; i++) {
        dic =dataPriseArray[i];
        label = [[UILabel alloc]initWithFrame:CGRectMake(pos_x,pos_y, 50, 15)];
        label.index =[NSString stringWithFormat:@"%@",[dic valueForKey:@"uid"]];
        NSString* str;
        if (dataPriseArray.count>1) {
            str = [NSString stringWithFormat:@"%@,",[dic valueForKey:@"name"]];
        }else{
            str = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
        }
        label.text  =str;
        label.font  = FONT(@"Arial", 13);
        label.textColor = [UIColor colorWithRed:211.0f/255.0 green:161.0f/255.0 blue:36.0f/255.0 alpha:1];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UserInfoAction:)]];
        [self.priseListView addSubview:label];
        pos_x+=WIDTH(label);
        if (pos_x > WIDTH(self.priseListView)-40) {
            pos_y+=HEIGHT(label)+5;
            pos_x = 10;
            num++;
        }
    }
    if (dataPriseArray.count>0) {
        [self.priseListView setFrame:CGRectMake(0,0, WIDTH(self.priseView),(num+1)*20)];
    }else{
        [self.priseListView setFrame:CGRectMake(0, 0, WIDTH(self.priseView),num*30)];
    }
    
    float comment_height =0;
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary* dic  = self.dataArray[i];
        NSString* name  = [dic valueForKey:@"name"];
        NSString* atLabel = [dic valueForKey:@"at_label"];
        NSString* atName = [dic valueForKey:@"at_name"];
        NSString* suffix =  [dic valueForKey:@"label_suffix"];
        NSString* content =  [dic valueForKey:@"content"];
        NSString* str = name;
        if (atLabel) {
            str = [str stringByAppendingString:atLabel];
        }
        
        if (atName) {
            str = [str stringByAppendingString:atName];
        }
        
        if (suffix) {
            str = [str stringByAppendingString:suffix];
        }
        
        if (content) {
            str = [str stringByAppendingString:content];
        }
        
        NSInteger line = [TDUtil convertToInt:str]/17;
        
        if (line>0) {
            comment_height+=(line+1)*13+10;
        }else{
            comment_height += 23;
        }
    }
    
    if (dataPriseArray.count>0 && self.dataArray.count>0) {
        [self.priseView setFrame:CGRectMake(X(self.contentLabel), POS_Y(self.funView), WIDTH(self.funView), num*25+comment_height+HEIGHT(self.priseListView)+10)];
    }else{
        float height = 0;
        if (!dataPriseArray.count>0) {
            if (self.dataArray.count>0) {
                height = 20;
            }
        }
        [self.priseView setFrame:CGRectMake(X(self.contentLabel), POS_Y(self.funView), WIDTH(self.funView),comment_height+HEIGHT(self.priseListView)+height)];
    }
    if (dataPriseArray.count>0 || self.dataArray.count>0) {
        UIImage* image = IMAGENAMED(@"message_reply");
        image  =[image stretchableImageWithLeftCapWidth:image.size.width/2+10 topCapHeight:20];
        UIImageView *imgView=[[UIImageView alloc]initWithImage:image];
        [imgView setFrame:CGRectMake(X(self.priseView), Y(self.priseView)-10, WIDTH(self.priseView), HEIGHT(self.priseView)+10)];
        [self addSubview:imgView];
        [self sendSubviewToBack:imgView];
    }
    
  
    
    if (dataPriseArray.count>0) {
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
        imgview.image = IMAGENAMED(@"like_white");
        [self.priseView addSubview:imgview];
    }
    
    [self setTableViewFrame:self.priseListView replyDataHeigt:comment_height];
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.thumbs.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    return [self.thumbs objectAtIndex:index];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [[UIApplication sharedApplication].windows[0].rootViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma ASIHttpRequest
-(void)requestData:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            self.dataArray  = [dic valueForKey:@"data"];
        }else{
            
        }
        [[DialogUtil sharedInstance]showDlg:self.superview textOnly:[dic valueForKey:@"msg"]];
    }
}

-(void)requestPriseFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            BOOL flag = ![[self.dic valueForKey:@"is_like"] boolValue];
            NSString* flagStr = flag==true?@"True":@"False";
            [self.dic setValue:flagStr forKey:@"is_like"];
            NSInteger num = [self.priseButton.titleLabel.text integerValue];
            if ([[self.dic valueForKey:@"is_like"]boolValue]) {
                [self.priseButton setTitle:[NSString stringWithFormat:@"%ld",++num] forState:UIControlStateNormal];
            }else{
                [self.priseButton setTitle:[NSString stringWithFormat:@"%ld",--num] forState:UIControlStateNormal];
            }
            
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:priseDic:msg:)]) {
                [_delegate weiboTableViewCell:self  priseDic:[dic valueForKey:@"data"] msg:[dic valueForKey:@"msg"]];
            }
        }

    }
}

-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:refresh:)]) {
                [_delegate weiboTableViewCell:self refresh:YES];
            }
        }
        [[DialogUtil sharedInstance]showDlg:self.superview textOnly:[dic valueForKey:@"msg"]];
    }
}

-(void)requestDeleteReplyFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            NSDictionary* tempDic =self.dataArray[currentSelectedCellIndex.row];
            if ([self.dataArray containsObject:tempDic]) {
                [self.dataArray removeObject:tempDic];
                if ([_delegate respondsToSelector:@selector(weiboTableViewCell:refresh:)]) {
                    [_delegate weiboTableViewCell:self refresh:YES];
                }
            }
        }
    }
}

-(void)requestDeleteFinished:(ASIHTTPRequest*)request
{
    NSString* jsonString = [TDUtil convertGBKDataToUTF8String:request.responseData];
    
    NSLog(@"返回:%@",jsonString);
    NSMutableDictionary * dic =[jsonString JSONValue];
    if (dic!=nil) {
        NSString* status = [dic valueForKey:@"status"];
        if ([status integerValue]==0) {
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:deleteDic:)]) {
                [_delegate weiboTableViewCell:self deleteDic:self.dic];
            }
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
}

@end
