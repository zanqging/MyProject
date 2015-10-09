#import "HitView.h"

@implementation HitView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([_delegate respondsToSelector:@selector(hitViewHitTest:withEvent:TouchView:)]) {
       return  [_delegate hitViewHitTest:point withEvent:event TouchView:self];
    }
    return nil;
}

@end
