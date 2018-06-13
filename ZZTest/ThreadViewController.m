//
//  ThreadViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/6/5.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "ThreadViewController.h"

@interface ThreadViewController ()

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    //1. GCD取消任务 ios8
    [self GCD_testCancelTask];
    //2. 设立标识取消任务
    [self GCD_testCancelTask_mark];
}

- (void)GCD_testCancelTask {
    dispatch_queue_t queue = dispatch_queue_create("com.testCancelTask.gcd", DISPATCH_QUEUE_CONCURRENT);
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        NSLog(@"block1 %@",[NSThread currentThread]);
    });
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        NSLog(@"block2 %@",[NSThread currentThread]);
    });
    dispatch_block_t block3 = dispatch_block_create(0, ^{
        NSLog(@"block3 %@",[NSThread currentThread]);
    });
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    dispatch_async(queue, block3);
    
    //取消任务
    dispatch_block_cancel(block3);
}

//设立标记取消
- (void)GCD_testCancelTask_mark {
    dispatch_queue_t queue = dispatch_queue_create("com.testCancelTask.gcd", DISPATCH_QUEUE_CONCURRENT);
    __block BOOL isCancel = NO;
    dispatch_async(queue, ^{
        if (isCancel) {
            NSLog(@"任务001被取消 %@",[NSThread currentThread]);
        } else {
            NSLog(@"任务001 %@",[NSThread currentThread]);
        }
        isCancel = YES;
    });
    dispatch_async(queue, ^{
        if (isCancel) {
            NSLog(@"任务002被取消 %@",[NSThread currentThread]);
        } else {
            NSLog(@"任务002 %@",[NSThread currentThread]);
        }
        isCancel = YES;
    });
    dispatch_async(queue, ^{
        if (isCancel) {
            NSLog(@"任务003被取消 %@",[NSThread currentThread]);
        } else {
            NSLog(@"任务003 %@",[NSThread currentThread]);
        }
        isCancel = YES;
    });
    dispatch_async(queue, ^{
        sleep(0.1);
        if (isCancel) {
            NSLog(@"任务004被取消 %@",[NSThread currentThread]);
        } else {
            NSLog(@"任务004 %@",[NSThread currentThread]);
        }
        isCancel = YES;
    });
}

/**
 *  1. 取消任务：只能取消未执行的任务。
 *  2. ios8,dispatch_block_cancel。或者标记位取消，在执行block体时，先进行isCanceled判断。
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 *
 */

@end
