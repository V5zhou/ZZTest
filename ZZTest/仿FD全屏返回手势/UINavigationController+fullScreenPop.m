//
//  UINavigationController+fullScreenPop.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/21.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "UINavigationController+fullScreenPop.h"
#import <objc/message.h>

NSString *kNotificationPanProgress = @"kNotificationPanProgress";
typedef void(^ViewWillApperInject)(UIViewController *ctl, BOOL animate);
@interface UIViewController ()

@property (nonatomic, copy) ViewWillApperInject willApperInject;     //在navigation的push那里，处理回调

@end

@interface UINavigationController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *fullScreenPan;

@end

@implementation UINavigationController (fullScreenPop)
@dynamic preferFullPop;

+ (void)load {
    Method m1 = class_getInstanceMethod(self, @selector(pushViewController:animated:));
    Method m11 = class_getInstanceMethod(self, @selector(hook_pushViewController:animated:));
    method_exchangeImplementations(m1, m11);
}

- (void)hook_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.preferFullPop &&
        ![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.fullScreenPan]) {
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.fullScreenPan];
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.fullScreenPan.delegate = self;
        [self.fullScreenPan addTarget:internalTarget action:internalAction];
    }
    [self addWillApperInject:viewController];
    [self hook_pushViewController:viewController animated:animated];
}

- (void)addWillApperInject:(UIViewController *)pushCtl {
    __weak typeof(self) weakSelf = self;
    ViewWillApperInject inject = ^(UIViewController *ctl, BOOL animate) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:ctl.preferNavigationHidden animated:animate];
        }
    };
    UIViewController *lastCtl = [self.viewControllers lastObject];
    if (lastCtl && !lastCtl.willApperInject) {
        lastCtl.willApperInject = inject;
    }
    if (pushCtl && !pushCtl.willApperInject) {
        pushCtl.willApperInject = inject;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (!self.preferFullPop) {
        return NO;
    }
    if ([self.viewControllers count] <= 1) {
        return NO;
    }
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    return YES;
}

- (UIPanGestureRecognizer *)fullScreenPan {
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

static char preferFullPop_bind;
- (BOOL)preferFullPop {
    NSNumber *prefer = objc_getAssociatedObject(self, &preferFullPop_bind);
    if (!prefer) {
        prefer = @(1);
        objc_setAssociatedObject(self, &preferFullPop_bind, prefer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return prefer.boolValue;
}
- (void)setPreferFullPop:(BOOL)preferFullPop {
    objc_setAssociatedObject(self, &preferFullPop_bind, @(preferFullPop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (zz_navigation)
@dynamic preferNavigationHidden;

+ (void)load {
    Method m1 = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method m11 = class_getInstanceMethod(self, @selector(hook_viewWillAppear:));
    method_exchangeImplementations(m1, m11);
}

- (void)hook_viewWillAppear:(BOOL)animated {
    [self hook_viewWillAppear:animated];
    if (self.willApperInject) {
        self.willApperInject(self, animated);
    }
}

static char preferNavigationHidden_bind;
- (void)setPreferNavigationHidden:(BOOL)preferNavigationHidden {
    objc_setAssociatedObject(self, &preferNavigationHidden_bind, @(preferNavigationHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)preferNavigationHidden {
    return [objc_getAssociatedObject(self, &preferNavigationHidden_bind) boolValue];
}

static char willApperInject_bind;
- (void)setWillApperInject:(ViewWillApperInject)willApperInject {
    objc_setAssociatedObject(self, &willApperInject_bind, willApperInject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (ViewWillApperInject)willApperInject {
    return objc_getAssociatedObject(self, &willApperInject_bind);
}

@end
