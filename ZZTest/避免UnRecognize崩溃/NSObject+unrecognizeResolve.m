//
//  NSObject+unrecognizeResolve.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/17.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "NSObject+unrecognizeResolve.h"
#import <objc/runtime.h>

@implementation NSObject (unrecognizeResolve)

+ (void)load {
    Method m1 = class_getInstanceMethod(self, @selector(forwardInvocation:));
    Method m11 = class_getInstanceMethod(self, @selector(hook_forwardInvocation:));
    method_exchangeImplementations(m1, m11);
    
    Method m2 = class_getInstanceMethod(self, @selector(methodSignatureForSelector:));
    Method m22 = class_getInstanceMethod(self, @selector(hook_methodSignatureForSelector:));
    method_exchangeImplementations(m2, m22);
}

- (void)hook_forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%@崩溃-->方法不存在：%@，请检查！", NSStringFromClass([anInvocation.target class]), NSStringFromSelector(anInvocation.selector));
    anInvocation.target = nil;
}

- (NSMethodSignature *)hook_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [self hook_methodSignatureForSelector:aSelector];
    if (!sig) {
        sig = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return sig;
}

@end
