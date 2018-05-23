//
//  CollectionDetailViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/22.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "CollectionDetailViewController.h"

@interface CollectionDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *detailText;

@end

@implementation CollectionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    _detailText.text = [NSString stringWithFormat:@"这是第%ld张", _indexPath.item];
    [self.view layoutIfNeeded];
}

@end
