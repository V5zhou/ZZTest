//
//  zz_DynamicCollectionLayout.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/25.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "zz_DynamicCollectionLayout.h"

@interface zz_DynamicCollectionLayout ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat latestDelta;

@end

@implementation zz_DynamicCollectionLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
        NSInteger col = 8;
        CGFloat space = 10;
        self.minimumLineSpacing = space;
        self.minimumInteritemSpacing = space;
        self.sectionInset = UIEdgeInsetsMake(space, space - 0.5, space, space + 0.5);
        CGFloat W = (kScreenWidth - space * (col + 1))/col;
        W = ((NSInteger)(W/2))*2;   //日了狗，为毛单数就会左右晃动，单数不会？
        self.itemSize = CGSizeMake(W, W);
        
        self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
        self.visibleIndexPathsSet = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGRect visibleRect = CGRectInset(self.collectionView.bounds, 0, -100);
    NSArray<UICollectionViewLayoutAttributes *> *itemsVisible = [super layoutAttributesForElementsInRect:visibleRect];
    NSSet *indexPathVisible = [NSSet setWithArray:[itemsVisible valueForKey:@"indexPath"]];
    //1.移除不再显示的
    NSArray *noLongerVisibles = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behavior, NSDictionary<NSString *,id> * _Nullable bindings) {
        BOOL curruntVisible = [indexPathVisible member:[(id)[behavior.items firstObject] valueForKey:@"indexPath"]];
        return !curruntVisible;
    }]];
    [noLongerVisibles enumerateObjectsUsingBlock:^(UIAttachmentBehavior *behavior, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dynamicAnimator removeBehavior:behavior];
        [self.visibleIndexPathsSet removeObject:[(id)[behavior.items firstObject] valueForKey:@"indexPath"]];
    }];
    
    //添加新显示的
    NSArray *newVisibles = [itemsVisible filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary<NSString *,id> * _Nullable bindings) {
        BOOL curruntVisible = [self.visibleIndexPathsSet member:item.indexPath];
        return !curruntVisible;
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newVisibles enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint center = item.center;
        UIAttachmentBehavior *behavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        behavior.length = 0.0f;
        behavior.damping = 0.8f;            //吸附阻力
        behavior.frequency = 1.0f;          //吸附时震动的频率

        // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
        if (!CGPointEqualToPoint(touchLocation, CGPointZero)) {
            CGFloat yDistanceFromTouch = fabs(touchLocation.y - behavior.anchorPoint.y);
            CGFloat xDistanceFromTouch = fabs(touchLocation.x - behavior.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;

            if (self.latestDelta < 0) {
                center.y += MAX(self.latestDelta, self.latestDelta*scrollResistance);
            }
            else {
                center.y += MIN(self.latestDelta, self.latestDelta*scrollResistance);
            }
            item.center = center;
        }
        
        [self.dynamicAnimator addBehavior:behavior];
        [self.visibleIndexPathsSet addObject:item.indexPath];
    }];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    self.latestDelta = delta;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *behavior, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat yDistanceFromTouch = fabs(touchLocation.y - behavior.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabs(touchLocation.x - behavior.anchorPoint.x);
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;

        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)[behavior.items firstObject];
        CGPoint center = item.center;
        if (delta < 0) {
            center.y += MAX(delta, delta*scrollResistance);
        }
        else {
            center.y += MIN(delta, delta*scrollResistance);
        }
        item.center = center;

        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
    return NO;
}

@end
