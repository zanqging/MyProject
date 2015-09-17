//
//  MyTableViewCell.m
//  测试滑动删除Cell
//
//  Created by lin on 14-8-19.
//  Copyright (c) 2014年 lin. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MyTableViewCell.h"

@implementation MyTableViewCell

//继承于SliderTableViewCell ，我们可以在这里自定义自己的Cell界面
//subview必须加在moveContentView上，这样才可以有滑动删除效果
-(void)addControl{
    [super addControl];
    UIButton *vTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vTestButton setFrame:CGRectMake(100, 20, 64, 44)];
    [vTestButton setTitle:@"点我吧" forState:UIControlStateNormal];
    [vTestButton addTarget:self action:@selector(testButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [vTestButton setBackgroundColor:[UIColor lightGrayColor]];
//    vTestButton.center = self.moveContentView.center;
    
    UIImageView *vImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"haha"]];
    vImageView.frame = CGRectMake(200, 0, 320-200, 88);
    [self.moveContentView addSubview:vImageView];
    [self.moveContentView addSubview:vTestButton];
    [vImageView release];
}

-(void)testButtonClicked:(id)sender{
    NSLog(@"点我了");
}

@end
