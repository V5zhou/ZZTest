//
//  DataStructureViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/8.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "DataStructureViewController.h"

@interface DataStructureViewController ()

@end

@implementation DataStructureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = NSStringFromClass(self.class);
    [self testEndian];
}


/**
 测试字节存储顺序
 */
- (void)testEndian {
    union {
        short s;
        char c[sizeof(short)];
    } un;
    un.s = 0x0102;
    if(sizeof(short)==2) {
        if(un.c[0]==1 && un.c[1] == 2)
            printf("大端序（高位低地址）\n");
        else if (un.c[0] == 2 && un.c[1] == 1)
            printf("小端序（高位高地址）\n");
        else
            printf("未知\n");
    } else
        printf("sizeof(short)= %ld\n",sizeof(short));
}

/**
 *  假设从地址0x00000001处开始存储十六进制数0x12345678
 *  大端：
 *  0x00000001           -- 12
 *  0x00000002           -- 34
 *  0x00000003           -- 56
 *  0x00000004           -- 78
 *
 *  -------------> 一个很好的记忆方法是，大端序是按照数字的书写顺序进行存储的，而小端序是颠倒书写顺序进行存储的。
 *  ------> (字节存储，顺序为大端，逆序为小端)
 *  ------> Intel系列的CPU都是按照小端序
 */

@end
