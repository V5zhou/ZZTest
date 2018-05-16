//
//  OpenScreenViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/16.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "OpenScreenViewController.h"
#import "AnimateView.h"

@interface OpenScreenViewController ()

@end

@implementation OpenScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    AnimateView *animateView = [[AnimateView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:animateView];
}

@end
