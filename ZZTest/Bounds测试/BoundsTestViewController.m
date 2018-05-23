//
//  BoundsTestViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/2.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "BoundsTestViewController.h"

@interface BoundsTestViewController ()

@property (nonatomic, strong) ZZTableDataSource *dataSource;

@end

@implementation BoundsTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = NSStringFromClass(self.class);
    self.tableView.dataSource = self.dataSource;
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSInteger i = 0; i < 1000; i++) {
        [items addObject:@(i).stringValue];
    }
    self.dataSource.dataArray = @[
                                  items
                                  ];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (ZZTableDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[ZZTableDataSource alloc] initWithIdentify:@"UITableViewCell" config:^(UITableViewCell *cell, id model, NSIndexPath *indexPath) {
            cell.textLabel.text = model;
        }];
    }
    return _dataSource;
}

@end
