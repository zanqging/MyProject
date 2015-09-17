//
//  SphereMenu.m
//  SphereMenu
//
//  Created by Tu You on 14-8-24.
//  Copyright (c) 2014年 TU YOU. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "SphereMenu.h"
#import "DataModel.h"
#import "GlobalDefine.h"
#import "SphereMenuItemView.h"

static const CGFloat kSphereLength = 120;
static const float kSphereDamping = 0.3;

@interface SphereMenu () <UICollisionBehaviorDelegate>

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *dataArray;
@property (assign, nonatomic) NSUInteger count ;
@property (strong, nonatomic) UIImageView *start;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *positions;

// animator and behaviors
@property (strong, nonatomic) NSMutableArray *snaps;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;

@property (strong, nonatomic) UITapGestureRecognizer *tapOnStart;

@property (assign, nonatomic) BOOL expanded;
@property (strong, nonatomic) id<UIDynamicItem> bumper;

@end


@implementation SphereMenu

- (instancetype)initWithStartPoint:(CGPoint)startPoint startImage:(UIImage *)startImage submenuImages:(NSArray *)images
{
    if (self = [super init]) {
        
        self.bounds = CGRectMake(0, 0, startImage.size.width, startImage.size.height);
        self.center = startPoint;
        
        self.images = images;
        self.count = self.images.count;
        self.start = [[UIImageView alloc] initWithImage:startImage];
        self.start.userInteractionEnabled = YES;
        self.tapOnStart = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(startTapped:)];
        [self.start addGestureRecognizer:self.tapOnStart];
        [self addSubview:self.start];
        self.backgroundColor=WriteColor;
    }
    return self;
}


-(instancetype)initWithStartPoint:(CGPoint)startPoint startImage:(UIImage *)startImage data:(NSMutableArray *)dataArray
{
    if (self = [super init]) {
        
        self.bounds = CGRectMake(0, 0, startImage.size.width, startImage.size.height);
        self.center = startPoint;
        
        //加载图片
        self.dataArray=dataArray;
        [self loadImageWithArray:dataArray];
        self.count = dataArray.count;
        self.start = [[UIImageView alloc] initWithImage:startImage];
        self.start.userInteractionEnabled = YES;
        self.tapOnStart = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(startTapped:)];
        [self.start addGestureRecognizer:self.tapOnStart];
        [self addSubview:self.start];
    }
    return self;
}


-(void)loadImageWithArray:(NSMutableArray*)array
{
    DataModel* model;
    NSMutableArray* modelArray=[[NSMutableArray alloc]init];
    for (int i = 0; i<array.count; i++) {
        model=(DataModel*)array[i];
        [modelArray addObject:[UIImage imageNamed:model.desc2]];
    }
    self.images=modelArray;
}

- (void)commonSetup
{
    self.items = [NSMutableArray array];
    self.positions = [NSMutableArray array];
    self.snaps = [NSMutableArray array];

    // setup the items
    DataModel* model;
    SphereMenuItemView *item;
    for (int i = 0; i < self.count; i++) {
        model=(DataModel*)self.dataArray[i];
        item= [[SphereMenuItemView alloc] initWithFrame:CGRectMake(0, 0, 50, 100)];
        [item setModel:model];
        item.tag=1000+i;
        item.alpha=0;
        item.userInteractionEnabled = YES;
        [self.superview addSubview:item];

        
        CGPoint position = [self centerForSphereAtIndex:i];
        item.center = self.center;
        [self.positions addObject:[NSValue valueWithCGPoint:position]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [item addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [item addGestureRecognizer:pan];
        
        [self.items addObject:item];
    }
    
    [self.superview bringSubviewToFront:self];
    
    // setup animator and behavior
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    
    self.collision = [[UICollisionBehavior alloc] initWithItems:self.items];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    self.collision.collisionDelegate = self;
    
    for (int i = 0; i < self.count; i++) {
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[i] snapToPoint:self.center];
        snap.damping = kSphereDamping;
        [self.snaps addObject:snap];
    }
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.items];
    self.itemBehavior.allowsRotation = NO;
    self.itemBehavior.elasticity = 1.2;
    self.itemBehavior.density = 0.5;
    self.itemBehavior.angularResistance = 5;
    self.itemBehavior.resistance = 10;
    self.itemBehavior.elasticity = 0.8;
    self.itemBehavior.friction = 0.5;
}

- (void)didMoveToSuperview
{
    [self commonSetup];
}

- (void)removeFromSuperview
{
    for (int i = 0; i < self.count; i++) {
        [self.items[i] removeFromSuperview];
    }
    
    [super removeFromSuperview];
}


- (CGPoint)centerForSphereAtIndex:(int)index
{
        CGFloat angle=M_PI/(self.count+1);
        CGFloat firstAngle = M_PI + (index+1) * angle;
        CGPoint startPoint = self.center;
        CGFloat x = startPoint.x + cos(firstAngle) * kSphereLength;
        CGFloat y = startPoint.y + sin(firstAngle) * kSphereLength;
        CGPoint position = CGPointMake(x, y);
        return position;
}

- (void)tapped:(UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(sphereDidSelected:)]) {
        NSUInteger tag=gesture.view.tag;
        self.expanded=NO;
        [self.delegate sphereDidSelected:(int)tag];
    }
    
    [self shrinkSubmenu];
}

- (void)startTapped:(UITapGestureRecognizer *)gesture
{
    [self.animator removeBehavior:self.collision];
    [self.animator removeBehavior:self.itemBehavior];
    [self removeSnapBehaviors];
    
    if (self.expanded) {
        [self shrinkSubmenu];
    } else {
        [self expandSubmenu];
    }
    
    self.expanded = !self.expanded;
}

- (void)expandSubmenu
{
    for (int i = 0; i < self.count; i++) {
        [self.items[i] setAlpha:1];
        [self snapToPostionsWithIndex:i];
    }
    
    if ([self.delegate respondsToSelector:@selector(sphereIsDidSelected:)]) {
        [self.delegate sphereIsDidSelected:YES];
    }
}

- (void)shrinkSubmenu
{
    for (int i = 0; i < self.count; i++) {
        [self snapToStartWithIndex:i];
    }
    
    if ([self.delegate respondsToSelector:@selector(sphereIsDidSelected:)]) {
        [self.delegate sphereIsDidSelected:NO];
    }
}

- (void)panned:(UIPanGestureRecognizer *)gesture
{
    UIView *touchedView = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.animator removeBehavior:self.itemBehavior];
        [self.animator removeBehavior:self.collision];
        [self removeSnapBehaviors];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        touchedView.center = [gesture locationInView:self.superview];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.bumper = touchedView;
        [self.animator addBehavior:self.collision];
        NSUInteger index = [self.items indexOfObject:touchedView];
        
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{
    [self.animator addBehavior:self.itemBehavior];
    
    if (item1 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item1];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
    
    if (item2 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item2];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}

- (void)snapToStartWithIndex:(NSUInteger)index
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:self.center];
    snap.damping = kSphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
    
    [UIView animateWithDuration:0.2  animations:^(void){
        [self.items[index] setAlpha:0];
    }];
    
   
}

- (void)snapToPostionsWithIndex:(NSUInteger)index
{
    id positionValue = self.positions[index];
    CGPoint position = [positionValue CGPointValue];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:position];
    snap.damping = kSphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

- (void)removeSnapBehaviors
{
    [self.snaps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.animator removeBehavior:obj];
    }];
}

-(void)setSelected:(BOOL)selected
{
    if (selected) {
        SphereMenuItemView* item;
        for (int i = 0; i < self.count; i++) {
            item=(SphereMenuItemView*)self.items[i];
            [self.superview bringSubviewToFront:item];
        }
    }
}


-(void)setExpanded:(BOOL)expanded
{
    self->_expanded = expanded;
}
@end
