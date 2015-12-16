//
//  ReplyView.h
//  JinZhiTou
//
//  Created by air on 15/10/8.
//  Copyright © 2015年 金指投. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol ReplyDelegate <NSObject>
@required
-(void)replyView:(id)replyView text:(NSString*)text;
@end



@interface ReplyView : UIView<UITextViewDelegate>
{
    UILabel* labelTextCount;
    UIScrollView* scrollView;
}
@property(retain,nonatomic)UIView* contentView;
@property(retain,nonatomic)UITextView* textView;
@property(weak,nonatomic)id <ReplyDelegate> delegate;

-(void)resetLayout;
@end
