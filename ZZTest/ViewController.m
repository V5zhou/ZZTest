//
//  ViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/2.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "ViewController.h"
#import "ZZTableDataSource.h"

@interface ViewController ()

@property (nonatomic, strong) ZZTableDataSource *dataSource;
@property (nonatomic, strong) NSDictionary *pushClass;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.tableView.dataSource = self.dataSource;
    self.dataSource.dataArray = @[
                                  @[
                                      @"bounds测试",
                                      @"H5文本批量替换",
                                      @"FPS检测",
                                      @"字节存储顺序测试",
                                      @"args取值",
                                      @"Block测试",
                                      @"自定义HUB",
                                      @"一个开屏动画",
                                      ]
                                  ];
}

- (ZZTableDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[ZZTableDataSource alloc] initWithIdentify:@"UITableViewCell" config:^(UITableViewCell *cell, id model, NSIndexPath *indexPath) {
            cell.textLabel.text = model;
        }];
    }
    return _dataSource;
}

- (NSDictionary *)pushClass {
    if (!_pushClass) {
        _pushClass = @{
                       @"bounds测试" : @"BoundsTestViewController",
                       @"H5文本批量替换" : @"URLProtocolViewController",
                       @"FPS检测" : @"FPSViewController",
                       @"字节存储顺序测试" : @"DataStructureViewController",
                       @"args取值" : @"ArgsViewController",
                       @"Block测试" : @"BlockTestViewController",
                       @"自定义HUB" : @"HUBViewController",
                       @"一个开屏动画" : @"OpenScreenViewController",
                       };
    }
    return _pushClass;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identy = [self.dataSource modelAtIndexPath:indexPath];
    NSString *className = self.pushClass[identy];
    NSAssert([className isKindOfClass:[NSString class]], @"请配置pushClass！");
    Class cls = NSClassFromString(className);
    NSAssert1(cls, @"配置的%@类不存在，请检查！", className);
    UIViewController *ctl = [[cls alloc] init];
    ctl.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
