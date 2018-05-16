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

@implementation BlockTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = NSStringFromClass(self.class);
    
    //测试block的存储位置
    [self testBlockType];
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

/**
 *  测试结果：
 *  1.未引用外部变量即为NSGlobalBlock。
 *  2.引用了外部变量, 为NSStackBlock;
 *  3.NSStackBlock, 如果被copy, 为NSMallocBlock;
 *  4.NSStackBlock, 如果被指针持有, ARC下为NSMallocBlock, MRC下为NSStackBlock。（arc中会默认将实例化的block拷贝到堆上）
 *
 */

@end
