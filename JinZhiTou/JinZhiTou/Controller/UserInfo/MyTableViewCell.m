
#import "MyTableViewCell.h"
#import "UConstants.h"
#import "GlobalDefine.h"
@implementation MyTableViewCell

//继承于SliderTableViewCell ，我们可以在这里自定义自己的Cell界面
//subview必须加在moveContentView上，这样才可以有滑动删除效果
-(void)addControl{
    [super addControl];
    
    
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(self)/4, WIDTH(self)/4)];
    [self.moveContentView addSubview:self.imgView];
    
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+10, 10, 70, 21)];
    self.nameLabel.font = SYSTEMFONT(16);
    self.nameLabel.textColor =BACKGROUND_LIGHT_GRAY_COLOR;
    [self.moveContentView addSubview:self.nameLabel];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.nameLabel)+5, Y(self.nameLabel), WIDTH(self)-POS_X(self.nameLabel), HEIGHT(self.nameLabel))];
    label.text =@"回复了您";
    label.textColor = BACKGROUND_LIGHT_GRAY_COLOR;
    [self.moveContentView addSubview:label];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.nameLabel), POS_Y(self.nameLabel)+5, WIDTH(self)-POS_X(self.imgView)-100, 21)];
    self.timeLabel.textColor=BACKGROUND_LIGHT_GRAY_COLOR;
    self.timeLabel.font = SYSTEMFONT(16);
    [self.moveContentView addSubview:self.timeLabel];
    
    self.contextLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.nameLabel), POS_Y(self.timeLabel), 210, 60)];
    self.contextLabel.numberOfLines = 0;
    self.contextLabel.font = SYSTEMFONT(14);
    self.contextLabel.textColor=BACKGROUND_LIGHT_GRAY_COLOR;
    self.contextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.moveContentView addSubview:self.contextLabel];
}

@end
