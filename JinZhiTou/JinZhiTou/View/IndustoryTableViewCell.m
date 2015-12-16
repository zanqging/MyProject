//
//  IndustoryTableViewCell.m
//  JinZhiTou
//
//  Created by air on 15/9/9.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import "IndustoryTableViewCell.h"
#import "GlobalDefine.h"
#import "UConstants.h"
#import "IndustoryLabel.h"

@implementation IndustoryTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UITapGestureRecognizer* recognizer;
        UIImageView* imageView;
        recognizer  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action:)];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.frame.size.height/2-10, 20, 20)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = IMAGENAMED(@"dianxuankuang 1");
        imageView.userInteractionEnabled = YES;
        imageView.tag = 20001;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        recognizer  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action:)];
        IndustoryLabel* label = [[IndustoryLabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+5, 0,80, self.frame.size.height)];
        label.tag=10001;
        label.sender = imageView;
        label.font = SYSTEMFONT(14);
        label.userInteractionEnabled  = YES;
        [label addGestureRecognizer:recognizer];
        [self addSubview:label];
        
        recognizer  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action:)];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20+POS_X(label), self.frame.size.height/2-10, 20, 20)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = IMAGENAMED(@"dianxuankuang 1");
        imageView.userInteractionEnabled = YES;
        imageView.tag = 20002;
        [imageView addGestureRecognizer:recognizer];
        [self addSubview:imageView];
        
        recognizer  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action:)];
        label = [[IndustoryLabel alloc]initWithFrame:CGRectMake(POS_X(imageView)+5, 0,80, self.frame.size.height)];
        label.tag=10002;
        label.sender = imageView;
        label.font = SYSTEMFONT(14);
        label.userInteractionEnabled  = YES;
        [label addGestureRecognizer:recognizer];
        [self addSubview:label];

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    self->_dataArray = dataArray;
    UILabel* label;
    NSDictionary* dic;
    
    dic = self.dataArray[0];
    label = (UILabel*)[self viewWithTag:10001];
    label.text = [dic valueForKey:@"type_name"];
    
    dic = self.dataArray[1];
    label = (UILabel*)[self viewWithTag:10002];
    label.text = [dic valueForKey:@"type_name"];
    
}

-(void)action:(UITapGestureRecognizer*)sender
{
     NSDictionary* dic;
    if ([sender.view  isKindOfClass:UIImageView.class]) {
        UIImageView* imgView =(UIImageView*)sender.view;
        NSInteger tag  =imgView.tag;
        
        if (tag == 20001) {
            dic = self.dataArray[0];
        }else{
            dic = self.dataArray[1];
        }
        
        BOOL isSelected =[[dic valueForKey:@"isSelected"]boolValue];
        NSString* fileName=@"";
        if (!isSelected) {
            fileName =@"dianxuankuang";
            [dic setValue:@"true" forKey:@"isSelected"];
        }else{
            fileName =@"dianxuankuang 1";
            [dic setValue:@"false" forKey:@"isSelected"];
        }
        imgView.image = IMAGENAMED(fileName);
        
    }else{
        UILabel* label =(UILabel*)sender.view;
        NSInteger tag  =label.tag;
        
       
        UIImageView* imgView;
        if (tag == 10001) {
            imgView = (UIImageView*)[self viewWithTag:20001];
            dic = self.dataArray[0];
        }else{
            imgView = (UIImageView*)[self viewWithTag:20002];
            dic = self.dataArray[1];
        }
        
        BOOL isSelected =[[dic valueForKey:@"isSelected"]boolValue];
        NSString* fileName=@"";
        if (!isSelected) {
            fileName =@"dianxuankuang";
            [dic setValue:@"YES" forKey:@"isSelected"];
        }else{
            fileName =@"dianxuankuang 1";
            [dic setValue:@"NO" forKey:@"isSelected"];
        }
        imgView.image = IMAGENAMED(fileName);
        
    }
    if ([_delegate respondsToSelector:@selector(IndustoryTableViewCell:data:)]) {
        [_delegate IndustoryTableViewCell:self data:dic];
    }
}

@end
