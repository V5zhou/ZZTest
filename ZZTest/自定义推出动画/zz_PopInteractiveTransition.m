//
//  zz_PopInteractiveTransition.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/23.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "zz_PopInteractiveTransition.h"

@implementation zz_PopInteractiveTransition {
    UIViewController *secondCtl;
}

- (void)addPopGesture:(UIViewController *)ctl {
    secondCtl = ctl;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [secondCtl.view addGestureRecognizer:pan];
}

-(void)panGesture:(UIPanGestureRecognizer *)pan {
    static CGFloat startX = 0;
    CGFloat transX = [pan translationInView:pan.view].x;
    CGFloat progress = (transX - startX)/CGRectGetWidth(pan.view.frame);
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            startX = [pan translationInView:pan.view].x;
            self.interacting = YES;
            [secondCtl.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:progress];
        }
            break;
            
        case UIGestureRecognizerStateEnded:{
            self.interacting = NO;
            if (progress > 0.2) {
                [self finishInteractiveTransition];
            }
            else {
                [self cancelInteractiveTransition];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
