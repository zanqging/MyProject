#import <UIKit/UIKit.h>

@protocol HitViewDelegate <NSObject>

-(UIView *)hitViewHitTest:(CGPoint)point withEvent:(UIEvent *)event TouchView:(UIView *)aView;

@end
@interface HitView : UIView

@property (nonatomic,assign) id<HitViewDelegate> delegate;
@end
