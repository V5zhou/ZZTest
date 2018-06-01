//
//  BlockTestViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/9.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "BlockTestViewController.h"

@interface BlockTestViewController ()

@end

typedef void(^CapBlock)(NSObject *);
CapBlock capBlock;
@implementation BlockTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = NSStringFromClass(self.class);
    
    //测试block的存储位置
    [self testBlockType];
    
    //测试捕获
    [self captureObject];
    capBlock([[NSObject alloc] init]);
    capBlock([[NSObject alloc] init]);
    capBlock([[NSObject alloc] init]);
    
    //测试捕获
    __block int num = 10;
    void (^capNum)(void) = ^() {
        NSLog(@"读取局部变量：%d", num);
        num = 1000;
    };
    num = 20;
    capNum();
    NSLog(@"block执行变量：%d", num);
}

/**
 测试block类型
 测试条件：1.是否问外部变量。2.是否访被指针引用。3.是否被拷贝。
 */
- (void)testBlockType {
    void(^test)(void) = ^() {
        NSLog(@"---------------");
    };
    NSLog(@"-------%@", test);          //未访问外部，Global
    NSLog(@"-------%@", [test copy]);   //Global的copy不生效，Global
    
    NSLog(@"-------%@", ^() {
        NSLog(@"---------------");
    });     //未访问外部，Global
    
    //
    NSArray *list = @[@"1", @"1", @"1", @"1", @"1", @"1", ];
    NSLog(@"-------%@",^() {
        NSLog(@"test Arr :%@", list);
    });                         //访问外部，Stack
    void(^test1)(void) = ^() {
        NSLog(@"test Arr :%@", list);
    };
    NSLog(@"-------%@", test1); //访问外部+又被指针指+又ARC，Malloc
}

- (void)captureObject {
    NSMutableArray *muArray = [NSMutableArray array];
    NSLog(@"%p", muArray);
    capBlock = ^(NSObject *object) {
        [muArray addObject:object];
        NSLog(@"元素个数：%ld", muArray.count);
        NSLog(@"%p", muArray);
    };
    [muArray addObject:@"1"];
    NSLog(@"%p", [muArray copy]);
}

/**
 *  测试结果：
 *  1.未引用外部变量即为NSGlobalBlock。
 *  2.引用了外部变量, 为NSStackBlock;
 *  3.NSStackBlock, 如果被copy, 为NSMallocBlock;
 *  4.NSStackBlock, 如果被指针持有, ARC下为NSMallocBlock, MRC下为NSStackBlock。（arc中会默认将实例化的block拷贝到堆上）
 *
 */

@end
