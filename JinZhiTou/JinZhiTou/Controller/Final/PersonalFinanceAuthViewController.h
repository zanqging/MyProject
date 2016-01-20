//
//  PersonalFinanceAuthViewController.h
//  JinZhiTou
//
//  Created by air on 16/1/16.
//  Copyright © 2016年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface PersonalFinanceAuthViewController : RootViewController <UITextViewDelegate>
{
    UIScrollView * _scrollView;  //滚动视图
    
    //寄语
    UILabel * labelComment; // 寄语
    //投资规模
    UILabel * labelFoundSize; //投资规模
    //投资案例
    UILabel * labelFinanceCase; //投资案例
    
    
    //UITextView
    UITextView * textComment;
    UITextView * textFoundSize;
    UITextView * textFinanceCase;
    
    
    //UIView
    UIView * commentLineView;
    UIView * sizeIntroduceLineView;
    UIView * caseLineView;
    
    UIView * contentView;
    
    UIView * bottomView;
    
    UIButton * btnSubmit;
    
    NSString * replyContent; //提示语
}
@end
