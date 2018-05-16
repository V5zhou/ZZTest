//
//  Moniter.m
//  Test
//
//  Created by 多米智投 on 2018/4/12.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "Moniter.h"

@interface Moniter ()

@property (nonatomic, strong) dispatch_semaphore_t semphore;
@property (nonatomic, assign) CFRunLoopActivity activity;
@property (nonatomic, assign) NSInteger timeoutCount;

//观察者
@property (nonatomic, assign) CFRunLoopObserverRef observer;
@property (nonatomic, assign) BOOL isStop;

@end

@implementation Moniter

+ (instancetype)shareInstance {
    static Moniter *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[Moniter alloc] init];
    });
    return manager;
}

- (dispatch_semaphore_t)semphore {
    if (!_semphore) {
        _semphore = dispatch_semaphore_create(0);
    }
    return _semphore;
}

static void callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopEntry:
            NSLog(@"run loop entry");
            break;
        case kCFRunLoopBeforeTimers:
            NSLog(@"run loop before timers");
            break;
        case kCFRunLoopBeforeSources:
            NSLog(@"run loop before sources");
            break;
        case kCFRunLoopBeforeWaiting:
            NSLog(@"run loop before waiting");
            break;
        case kCFRunLoopAfterWaiting:
            NSLog(@"run loop after waiting");
            break;
        case kCFRunLoopExit:
            NSLog(@"run loop exit");
            break;
        default:
            break;
    }
    //do something
    Moniter *moniter = (__bridge Moniter *)(info);
    moniter.activity = activity;
    dispatch_semaphore_signal(moniter.semphore);
}

- (void)run {
    self.isStop = NO;
    //1.添加主线程观察者
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                                            kCFRunLoopAllActivities,
                                                            YES,
                                                            0,
                                                            &callback,
                                                            &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    self.observer = observer;
    //2.子线程计算中间耗时
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (!_isStop) {
            //dispatch_semaphore_wait后线程阻塞，不会再向下执行。
            //当有以下情况时继续执行：
            //1.超时，此时signalNum返回为非0;
            //2.手动signal，此时signalNum返回为0.
            long signalNum = dispatch_semaphore_wait(self.semphore, dispatch_time(DISPATCH_TIME_NOW, 60*NSEC_PER_MSEC));    //50毫秒,1秒为1000毫秒
            //如果为非0，说明主线程超时时间内都未调signal，主线程在忙，或者已经睡了。
            if (signalNum != 0) {
                //如果是在忙
                if (_activity == kCFRunLoopBeforeSources/*source事件开始处理*/ ||
                    _activity == kCFRunLoopAfterWaiting /*被唤醒工作*/) {
                    if (++_timeoutCount < 5) {
                        continue;
                    }
                    NSLog(@"好像有点儿卡哦");
                }
                _timeoutCount = 0;
            }
        }
    });
}

- (void)stop {
    //移除观察者
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observer, kCFRunLoopCommonModes);
    CFRelease(self.observer);
    self.observer = NULL;
    self.isStop = YES;
    self.semphore = nil;
}

@end
