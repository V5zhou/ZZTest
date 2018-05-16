//
//  FPSViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/7.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "FPSViewController.h"
#import "Moniter.h"

@interface FPSViewController ()

@property (nonatomic, strong) ZZTableDataSource *dataSource;

@end

@implementation FPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = NSStringFromClass(self.class);
    self.tableView.dataSource = self.dataSource;
    
    //开启检测
    [[Moniter shareInstance] run];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0; i < 1000; i++) {
        [items addObject:@(i).stringValue];
    }
    self.dataSource.dataArray = @[
                                  items
                                  ];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[Moniter shareInstance] stop];
}

- (ZZTableDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[ZZTableDataSource alloc] initWithIdentify:@"UITableViewCell" config:^(UITableViewCell *cell, id model, NSIndexPath *indexPath) {
            cell.textLabel.text = model;
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/pic/item/cb8065380cd7912333d46579af345982b2b78083.jpg"]];
            cell.imageView.image = [[UIImage alloc] initWithData:data];
        }];
    }
    return _dataSource;
}

@end
