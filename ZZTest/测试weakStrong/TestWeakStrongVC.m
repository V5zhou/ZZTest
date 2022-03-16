//
//  TestWeakStrongVC.m
//  ZZTest
//
//  Created by 心檠 on 2022/3/16.
//  Copyright © 2022 多米智投. All rights reserved.
//

#import "TestWeakStrongVC.h"

@interface TestWeakStrongVC ()

@property (nonatomic, copy) void(^event1)(void);
@property (nonatomic, copy) void(^event2)(void);

@end

@implementation TestWeakStrongVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weak_self = self;
    self.event1 = ^{
        __strong typeof(weak_self) self = weak_self;
        self.event2 = ^{
            __strong typeof(weak_self) self = weak_self;
            NSLog(@"%@", self.class);
        };
        NSLog(@"%@", self.class);
    };
    self.event1();
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self.class);
}

/*
    测试点：
    当有多次嵌套block调用self时，只在最外层用StrongSelf，与在每一层都执行StrongSelf，有没有区别？
    
    测试结果：
    - 内层不写时，当构成循环引用，会内存泄露。
    - 每层都写时，不会内存泄露。
 
*/

@end
