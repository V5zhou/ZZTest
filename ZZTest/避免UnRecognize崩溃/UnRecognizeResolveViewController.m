//
//  UnRecognizeResolveViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/17.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "UnRecognizeResolveViewController.h"

@interface UnRecognizeResolveViewController ()

@end

@implementation UnRecognizeResolveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SEL sel1 = NSSelectorFromString(@"aaaaa");
    [self performSelector:sel1 withObject:nil afterDelay:0];
    SEL sel2 = NSSelectorFromString(@"bbbbb:");
    [self performSelector:sel2 withObject:nil afterDelay:0];
}

@end
