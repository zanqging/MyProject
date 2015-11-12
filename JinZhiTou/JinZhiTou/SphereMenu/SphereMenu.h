#import <UIKit/UIKit.h>

@protocol SphereMenuDelegate <NSObject>

- (void)sphereDidSelected:(int)index;

-(void)sphereIsDidSelected:(BOOL)selected;
@end

@interface SphereMenu : UIView
{
    float angleNum;
}
@property (weak, nonatomic) id<SphereMenuDelegate> delegate;
@property(assign,nonatomic)BOOL selected;
- (instancetype)initWithStartPoint:(CGPoint)startPoint
                        startImage:(UIImage *)startImage
                     submenuImages:(NSArray *)images;
- (instancetype)initWithStartPoint:(CGPoint)startPoint
                        startImage:(UIImage *)startImage
                              data:(NSMutableArray*)dataArray;
@end
