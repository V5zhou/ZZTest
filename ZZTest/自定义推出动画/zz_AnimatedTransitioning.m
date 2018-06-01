//
//  zz_AnimatedTransitioning.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/22.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "zz_AnimatedTransitioning.h"

@implementation zz_AnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containView = [transitionContext containerView];
    
    //获取当前点击的Cell
    UIViewController *page1 = _isPush ? from : to;
    UIViewController *page2 = _isPush ? to : from;
    UICollectionView *collection = [page1 valueForKey:@"collectionView"];
    if (!collection) {
        return;
    }
    NSIndexPath *indexPath = [page2 valueForKey:@"indexPath"];
    UICollectionViewCell *cell = [collection cellForItemAtIndexPath:indexPath];
    UIImageView *page2Image = [page2 valueForKey:@"detailImageView"];
    //制作截图
    UIView *animateFrom = _isPush ? cell : page2Image;
    UIView *animateTo = _isPush ? page2Image : cell;
    UIView *snapShotView = [animateFrom snapshotViewAfterScreenUpdates:false];
    
    //注意添加的先后顺序，否则会被遮挡。
    to.view.frame = [transitionContext finalFrameForViewController:to];
    to.view.alpha = 0;
    [containView addSubview:to.view];
    
    snapShotView.frame = [animateFrom convertRect:animateFrom.bounds toView:containView];
    [containView addSubview:snapShotView];
    
    animateFrom.hidden = YES;
    animateTo.hidden = YES;
    [to.view layoutIfNeeded];
    //动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        to.view.alpha = 1;
        //假装把Cell的ImageView移动到第二个VC中的ImageView的位置。
        snapShotView.frame = [animateTo convertRect:animateTo.bounds toView:containView];
    } completion:^(BOOL finished) {
        animateFrom.hidden = NO;
        animateTo.hidden = NO;
        [snapShotView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
