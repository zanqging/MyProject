

#import "SlideTableViewCell.h"
#import "UIImageView+WebCache.h"
@interface MyTableViewCell : SlideTableViewCell
{
    
}
@property(retain,nonatomic)UIImageView* imgView;
@property(retain,nonatomic)UILabel* nameLabel;
@property(retain,nonatomic)UILabel* timeLabel;
@property(retain,nonatomic)UILabel* contextLabel;
@property(retain,nonatomic)NSString* name;
@property(retain,nonatomic)NSString* content;

@end
