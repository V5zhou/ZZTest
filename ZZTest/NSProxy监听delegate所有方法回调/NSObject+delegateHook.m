//
//  NSObject+delegateHook.m
//  Test
//
//  Created by 多米智投 on 2017/12/27.
//  Copyright © 2017年 多米智投. All rights reserved.
//

#import "NSObject+delegateHook.h"
#import <objc/runtime.h>

@interface delegateProxy: NSProxy

@property (nonatomic, weak) id delegate_old;

@end

@implementation delegateProxy

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (self.delegate_old) {
        //拦截方法的执行者为复制的对象
        [invocation setTarget:self.delegate_old];
        
        NSString *selName = @"";
        if ([NSStringFromSelector(invocation.selector) isEqualToString:@"respondsToSelector:"]) {
            SEL sel;
            [invocation getArgument:&sel atIndex:2];
            selName = [NSString stringWithFormat:@" @selector(%@)", NSStringFromSelector(sel)];
        }
        NSLog(@"Hook-->[%@ %@%@]", [self.delegate_old class], NSStringFromSelector(invocation.selector), selName);
        
        //开始调用方法
        [invocation invoke];
    }
}

//1.查询该方法的方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *signature = nil;
    if ([self.delegate_old methodSignatureForSelector:sel]) {
        signature = [self.delegate_old methodSignatureForSelector:sel];
    }
    else {
        //理论上self.delegate_old存在的情况下，永远不会走这里
        signature = [super methodSignatureForSelector:sel];
    }
    return signature;
}

- (void)dealloc {
    NSLog(@"---------------");
}

@end

#define HookDelegate(className) \
@class delegateProxy;\
@interface className (delegateHook)\
\
@property (nonatomic, strong) delegateProxy *proxy;\
\
@end\
\
@implementation className (delegateHook)\
@dynamic proxy;\
\
- (void)zz_setDelegate:(id)delegate {\
if (delegate) {\
delegateProxy *proxy = [delegateProxy alloc];\
proxy.delegate_old = delegate;\
[self zz_setDelegate:proxy];\
self.proxy = proxy;\
}\
}\
\
+ (void)load {\
Method method_delegate_old = class_getInstanceMethod(self, @selector(setDelegate:));\
Method method_delegate_new = class_getInstanceMethod(self, @selector(zz_setDelegate:));\
method_exchangeImplementations(method_delegate_new, method_delegate_old);\
}\
\
static char proxy_bind;\
- (void)setProxy:(delegateProxy *)proxy {\
objc_setAssociatedObject(self, &proxy_bind, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);\
}\
\
- (delegateProxy *)proxy {\
return objc_getAssociatedObject(self, &proxy_bind);\
}\
\
@end

//HookDelegate(UITableView)
//HookDelegate(UIApplication)

