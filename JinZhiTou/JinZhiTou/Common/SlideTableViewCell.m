

#import "SlideTableViewCell.h"
#import "GlobalDefine.h"
#import "GlobalDefine.h"
#import "UConstants.h"
#define DELETE_BUTTON_WIDHT 80
#define MORE_BUTTON_WIDTH   80
#define BOUNENCE            0

@implementation SlideTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if (_moveContentView == nil) {
            _moveContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height-20)];
            _moveContentView.backgroundColor = [UIColor whiteColor];
        }
        [self.contentView addSubview:_moveContentView];
        [self setBackgroundColor:[UIColor clearColor]];
        [self addControl];
        
    }
    return self;
}

- (void)awakeFromNib
{
    [self addControl];
}

-(void)addControl{
    self.backgroundColor = BackColor;
    self.contentView.backgroundColor=BackColor;
    UIView *menuContetnView = [[UIView alloc] init];
    menuContetnView.hidden = YES;
    menuContetnView.tag = 100;
    
    vDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vDeleteButton setBackgroundColor:BackColor];
    [vDeleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [vDeleteButton setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    [vDeleteButton setTitleColor:ColorTheme forState:UIControlStateNormal];
    [vDeleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [vDeleteButton setShowsTouchWhenHighlighted:YES];
    [vDeleteButton setContentMode:UIViewContentModeCenter];
    [vDeleteButton setTag:1001];
    
    vMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [vMoreButton setBackgroundColor:BackColor];
    [vMoreButton setTitle:@"回复" forState:UIControlStateNormal];
    [vMoreButton setImage:[UIImage imageNamed:@"huifu"] forState:UIControlStateNormal];
    [vMoreButton setTitleColor:ColorTheme forState:UIControlStateNormal];
    [vMoreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [vMoreButton setTag:1002];
    
    menuContetnView.backgroundColor =BackColor;
    [menuContetnView addSubview:vDeleteButton];
    [menuContetnView addSubview:vMoreButton];
    [self.contentView insertSubview:menuContetnView atIndex:0];
    UIPanGestureRecognizer *vPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    vPanGesture.delegate = self;
    [self.contentView addGestureRecognizer:vPanGesture];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"layoutSubviews:_moveContentView:%@",NSStringFromCGRect(self.contentView.frame));
    [_moveContentView setFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height-20)];
    
    UIView *vMenuView = [self.contentView viewWithTag:100];
    vMenuView.frame =CGRectMake(self.frame.size.width - DELETE_BUTTON_WIDHT - MORE_BUTTON_WIDTH, 0, DELETE_BUTTON_WIDHT + MORE_BUTTON_WIDTH, self.frame.size.height);
    
    vDeleteButton = (UIButton*)[self.contentView viewWithTag:1001];
    vDeleteButton.frame = CGRectMake(MORE_BUTTON_WIDTH, 0, DELETE_BUTTON_WIDHT, self.frame.size.height);
    vMoreButton = (UIButton*)[self.contentView viewWithTag:1002];
    vMoreButton.frame = CGRectMake(0, 0, MORE_BUTTON_WIDTH, self.frame.size.height);
    if (self.isHideMoreButtom) {
        [vDeleteButton setFrame:CGRectMake(X(vMoreButton), Y(vDeleteButton), WIDTH(vMoreButton)+WIDTH(vMoreButton), HEIGHT(vDeleteButton))];
        [vMoreButton removeFromSuperview];
    }
}

//此方法和下面的方法很重要,对ios 5SDK 设置不被Helighted
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
    UIView *vMenuView = [self.contentView viewWithTag:100];
    if (vMenuView.hidden == YES) {
        [super setSelected:selected animated:animated];
        self.backgroundColor = [UIColor whiteColor];
    }
}
//此方法和上面的方法很重要，对ios 5SDK 设置不被Helighted
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    UIView *vMenuView = [self.contentView viewWithTag:100];
    if (vMenuView.hidden == YES) {
        [super setHighlighted:highlighted animated:animated];
    }
}

-(void)prepareForReuse{
    self.contentView.clipsToBounds = YES;
    [self hideMenuView:YES Animated:NO];
}


-(CGFloat)getMaxMenuWidth{
    return DELETE_BUTTON_WIDHT + MORE_BUTTON_WIDTH;
}

-(void)enableSubviewUserInteraction:(BOOL)aEnable{
    if (aEnable) {
        for (UIView *aSubView in self.contentView.subviews) {
            aSubView.userInteractionEnabled = YES;
        }
    }else{
        for (UIView *aSubView in self.contentView.subviews) {
            UIView *vDeleteButtonView = [self.contentView viewWithTag:100];
            if (aSubView != vDeleteButtonView) {
                aSubView.userInteractionEnabled = NO;
            }
        }
    }
}

-(void)hideMenuView:(BOOL)aHide Animated:(BOOL)aAnimate{
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    CGRect vDestinaRect = CGRectZero;
    if (aHide) {
        vDestinaRect = self.contentView.frame;
        [self enableSubviewUserInteraction:YES];
    }else{
        vDestinaRect = CGRectMake(-[self getMaxMenuWidth], self.contentView.frame.origin.x, self.contentView.frame.size.width, self.contentView.frame.size.height);
        [self enableSubviewUserInteraction:NO];
    }
    
    CGFloat vDuration = aAnimate? 0.4 : 0.0;
    vDestinaRect.origin.y=10;
    vDestinaRect.size.height-=20;
    [UIView animateWithDuration:vDuration animations:^{
        _moveContentView.frame = vDestinaRect;
    } completion:^(BOOL finished) {
        if (aHide) {
            if ([_delegate respondsToSelector:@selector(didCellHided:)]) {
                [_delegate didCellHided:self];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(didCellShowed:)]) {
                [_delegate didCellShowed:self];
            }
        }
        UIView *vMenuView = [self.contentView viewWithTag:100];
        vMenuView.hidden = aHide;
    }];
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint vTranslationPoint = [gestureRecognizer translationInView:self.contentView];
        return fabs(vTranslationPoint.x) > fabs(vTranslationPoint.y);
    }
    return YES;
}

-(void)handlePan:(UIPanGestureRecognizer *)sender{

    if (sender.state == UIGestureRecognizerStateBegan) {
        startLocation = [sender locationInView:self.contentView].x;
        CGFloat direction = [sender velocityInView:self.contentView].x;
        if (direction < 0) {
            if ([_delegate respondsToSelector:@selector(didCellWillShow:)]) {
                [_delegate didCellWillShow:self];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(didCellWillHide:)]) {
                [_delegate didCellWillHide:self];
            }
        }
    }else if (sender.state == UIGestureRecognizerStateChanged){
        CGFloat vCurrentLocation = [sender locationInView:self.contentView].x;
        CGFloat vDistance = vCurrentLocation - startLocation;
        startLocation = vCurrentLocation;

        CGRect vCurrentRect = _moveContentView.frame;
        CGFloat vOriginX = MAX(-[self getMaxMenuWidth] - BOUNENCE, vCurrentRect.origin.x + vDistance);
        vOriginX = MIN(0 + BOUNENCE, vOriginX);
        _moveContentView.frame = CGRectMake(vOriginX, vCurrentRect.origin.y, vCurrentRect.size.width, vCurrentRect.size.height);
        
        CGFloat direction = [sender velocityInView:self.contentView].x;
        NSLog(@"direction:%f",direction);
        NSLog(@"vOriginX:%f",vOriginX);
        if (direction < -40.0 || vOriginX <  - (0.5 * [self getMaxMenuWidth])) {
            hideMenuView = NO;
            UIView *vMenuView = [self.contentView viewWithTag:100];
            vMenuView.hidden = hideMenuView;
        }else if(direction > 20.0 || vOriginX >  - (0.5 * [self getMaxMenuWidth])){
            hideMenuView = YES;
        }
    }else if (sender.state == UIGestureRecognizerStateEnded){
        [self hideMenuView:hideMenuView Animated:YES];
    }
}

- (IBAction)cellButtonClicked:(id)sender {
    NSLog(@"点击CellButton");

}

#pragma mark  点击更多
-(void)moreButtonClicked:(id)sender{
    NSLog(@"点击更多");
    if ([_delegate respondsToSelector:@selector(didCellClickedMoreButton:)]) {
        [_delegate didCellClickedMoreButton:self];
    }
}

#pragma mark 点击删除
-(void)deleteButtonClicked:(id)sender{
    NSLog(@"点击删除");
    [self.superview sendSubviewToBack:self];
    if ([_delegate respondsToSelector:@selector(didCellClickedDeleteButton:)]) {
        [_delegate didCellClickedDeleteButton:self];
    }
}

-(void)hiddenMoreButton
{
    [vMoreButton setEnabled:NO];
    [vMoreButton setAlpha:0];
    self.isHideMoreButtom =YES;
}

@end
