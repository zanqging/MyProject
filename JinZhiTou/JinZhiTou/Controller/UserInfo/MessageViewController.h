#import <UIKit/UIKit.h>
#import "NavView.h"
#import "CustomTableView.h"

@interface MessageViewController : UIViewController<CustomTableViewDataSource,CustomTableViewDelegate>
@property (nonatomic,retain) CustomTableView *customTableView;
@property(assign,nonatomic)NSInteger type;
@property(retain,nonatomic)NavView* navView;
@property(retain,nonatomic)NSString* titleStr;
@property(assign,nonatomic)NSInteger project_id;
@property(assign,nonatomic)BOOL isEndOfPageSize;
@property(retain,nonatomic)NSMutableArray* dataArray;
@end
