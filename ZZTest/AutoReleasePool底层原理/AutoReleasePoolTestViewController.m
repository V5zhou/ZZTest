//
//  AutoReleasePoolTestViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/17.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "AutoReleasePoolTestViewController.h"

@interface AutoReleasePoolTestViewController ()

@end

@implementation AutoReleasePoolTestViewController

__weak NSString *string_weak_ = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // 场景 1
//    NSString *string = [NSString stringWithFormat:@"leichunfeng"];
//    string_weak_ = string;
    
    // 场景 2
//        @autoreleasepool {
//            NSString *string = [NSString stringWithFormat:@"leichunfeng"];
//            string_weak_ = string;
//        }
    
    // 场景 3
    NSString *string = nil;
    @autoreleasepool {
        string = [NSString stringWithFormat:@"leichunfeng"];
        string_weak_ = string;
    }
    NSLog(@"string: %@", string_weak_);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"string: %@", string_weak_);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"string: %@", string_weak_);
}

@end

/**
     1. 自动释放池是由 AutoreleasePoolPage 以双向链表的方式实现的
     2. 创建自动释放池：AutoreleasePoolPage::push, 会加入哨兵对象
     2. 当对象调用 autorelease 方法时，会将对象加入 AutoreleasePoolPage 的栈中
     3. 调用 AutoreleasePoolPage::pop 方法会向哨兵对象后面的对象发送 release 消息
 *
 *  AutoreleasePoolPage结构：
     magic 用来校验 AutoreleasePoolPage 的结构是否完整；
     next 指向最新添加的 autoreleased 对象的下一个位置，初始化时指向 begin() ；Push时加入哨兵对象
     thread 指向当前线程；
     parent 指向父结点，第一个结点的 parent 值为 nil ；
     child 指向子结点，最后一个结点的 child 值为 nil ；
     depth 代表深度，从 0 开始，往后递增 1；
     hiwat 代表 high water mark 。
 *
 *  附clang命令：
 *  clang -x objective-c -rewrite-objc -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk main.m
 *
 *
 *
 *
 *
 *
 */
