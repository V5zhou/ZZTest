//
//  ArgsViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/8.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "ArgsViewController.h"

@interface ArgsViewController ()

@end

@implementation ArgsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = NSStringFromClass(self.class);
    
    NSInteger total = [self sumNums:1,2,23,44,90,nil];
    NSLog(@"%ld", total);
}

//计算和
- (NSInteger)sumNums:(NSInteger)num, ... {
    NSInteger total = num;
    va_list arg_list;           // C语言的字符指针, 指针根据offset来指向需要的参数,从而读取参数
    va_start(arg_list, num);    // 设置指针的起始地址为方法的...参数的第一个参数
    while ((num = va_arg(arg_list, NSInteger))) {   // 获取当前va_list指针指向的参数, 并以NSInteger内存大小的偏移量移向下一个参数
        total += num;
    }
    va_end(arg_list);           // 针对va_start进行的安全处理,将va_list指向Null.
    return total;
}

/**
 *  注意事项:
 *  使用的时候，可变参后最后面加一个nil值，这样是代表结束的意思。
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
