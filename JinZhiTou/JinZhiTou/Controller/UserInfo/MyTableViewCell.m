
#import "MyTableViewCell.h"
#import "TDUtil.h"
#import "UConstants.h"
#import "GlobalDefine.h"
#import <QuartzCore/QuartzCore.h>
@implementation MyTableViewCell

//继承于SliderTableViewCell ，我们可以在这里自定义自己的Cell界面
//subview必须加在moveContentView上，这样才可以有滑动删除效果
-(void)addControl{
    [super addControl];
    
    
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, WIDTH(self)/6, WIDTH(self)/6)];
    self.imgView.layer.cornerRadius =WIDTH(self)/12;
    self.imgView.layer.masksToBounds = YES;
    [self.moveContentView addSubview:self.imgView];
    
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(POS_X(self.imgView)+10, 10, 70, 21)];
    self.nameLabel.font = SYSTEMFONT(16);
    self.nameLabel.textColor =FONT_COLOR_RED;
    [self.moveContentView addSubview:self.nameLabel];
    
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.nameLabel), POS_Y(self.nameLabel)+5, WIDTH(self)-POS_X(self.imgView)-100, 21)];
    self.timeLabel.textColor=FONT_COLOR_GRAY;
    self.timeLabel.font = SYSTEMFONT(12);
    [self.moveContentView addSubview:self.timeLabel];
    
    self.contextLabel = [[UILabel alloc]initWithFrame:CGRectMake(X(self.nameLabel), POS_Y(self.timeLabel)+5, WIDTH(self)-X(self.timeLabel)-20, 20)];
    self.contextLabel.numberOfLines = 0;
    self.contextLabel.font = SYSTEMFONT(14);
    self.contextLabel.textColor=FONT_COLOR_GRAY;
    self.contextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.moveContentView addSubview:self.contextLabel];
}

-(void)setName:(NSString *)name
{
    self->_name = name;
    if (self.name) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
        
        [paragraphStyle setLineSpacing:8.f];//调整行间距
        [paragraphStyle setAlignment:NSTextAlignmentJustified];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:name];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [name length])];
        
        self.nameLabel.attributedText = attributedString;//ios 6
        [self.nameLabel sizeToFit];
    }
}


-(void)setContent:(NSString *)content
{
    self->_content = content;
    if (self.content) {
        NSInteger lenght = [TDUtil convertToInt:content];
        NSInteger lines = lenght / 16;
        if (lines<=0) {
            lines = 1;
        }
        float height = lines *20;
        
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        
//        //注意，每一行的行间距分两部分，topSpacing和bottomSpacing。
//        
//        [paragraphStyle setLineSpacing:8.f];//调整行间距
//        [paragraphStyle setAlignment:NSTextAlignmentJustified];
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
//        
//        self.contextLabel.attributedText = attributedString;//ios 6
//        [self.contextLabel sizeToFit];
        self.contextLabel.text =content;
        self.contextLabel.numberOfLines =lines;
        [self.contextLabel setFrame:CGRectMake(X(self.contextLabel),Y(self.contextLabel),WIDTH(self.contextLabel),height) ];

    }
}

@end
