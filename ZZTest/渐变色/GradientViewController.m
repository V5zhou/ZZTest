//
//  GradientViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/23.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "GradientViewController.h"

@interface GradientViewController ()

@end

@implementation GradientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UIView *view in self.view.subviews) {
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

@end
