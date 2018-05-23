//
//  HookCViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/18.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "HookCViewController.h"
#import "fishhook.h"

@interface HookCViewController ()

@end

static void (*orgin_async)(dispatch_queue_t queue, dispatch_block_t block);
@implementation HookCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rebind_symbols((struct rebinding[1]){{"dispatch_async", myAsynic, (void **)&orgin_async}}, 1);
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"kkkkkkk");
    });
}

void myAsynic(dispatch_queue_t queue, dispatch_block_t block) {
    NSLog(@"你调用了asyn方法");
    orgin_async(queue, block);
}

@end
