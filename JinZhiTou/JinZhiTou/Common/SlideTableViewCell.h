#import <UIKit/UIKit.h>

@protocol SlideTableViewCellDelegate <NSObject>

-(void)didCellWillHide:(id)aSender;
-(void)didCellHided:(id)aSender;
-(void)didCellWillShow:(id)aSender;
-(void)didCellShowed:(id)aSender;
-(void)didCellClickedDeleteButton:(id)aSender;
-(void)didCellClickedMoreButton:(id)aSender;
@end

@interface SlideTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>
{
    CGFloat startLocation;
    BOOL    hideMenuView;
    UIButton *vDeleteButton;
    UIButton *vMoreButton;
}



@property (retain, nonatomic) IBOutlet UIView *moveContentView;

@property (nonatomic,assign) id<SlideTableViewCellDelegate> delegate;
@property(assign,nonatomic)BOOL isHideMoreButtom;
-(void)hideMenuView:(BOOL)aHide Animated:(BOOL)aAnimate;
-(void)addControl;
-(void)hiddenMoreButton;
@end
