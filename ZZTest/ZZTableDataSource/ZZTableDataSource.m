//
//  ZZTableDataSource.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/2.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "ZZTableDataSource.h"

@interface ZZTableDataSource ()

@property (nonatomic, copy) NSString *identify;
@property (nonatomic, copy) ZZCellConfig config;

//
@property (nonatomic, assign) BOOL testRegistedCell;      //是否已尝试注册

@end

@implementation ZZTableDataSource

- (instancetype)initWithIdentify:(NSString *)identify config:(ZZCellConfig)config {
    self = [super init];
    if (self) {
        self.identify = identify;
        self.config = config;
    }
    return self;
}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *group = _dataArray.count > indexPath.section ? _dataArray[indexPath.section] : nil;
    if (!group) return nil;
    id model = group.count > indexPath.row ? group[indexPath.row] : nil;
    return model;
}

#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identify];
    //尝试通过注册解决
    if (!cell &&
        !_testRegistedCell) {
        cell = [self tableView:tableView testCellForRowAtIndexPath:indexPath];
        _testRegistedCell = YES;
    }
    //最终未找到
    if (!cell) {
        NSAssert(cell, @"未找到此类型cell,建立空cell防止崩溃");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"no-cell-identy"];
        return cell;
    }
    id model = [self modelAtIndexPath:indexPath];
    if (_config) {
        _config(cell, model, indexPath);
    }
    return cell;
}

//尝试通过注册解决
- (UITableViewCell *)tableView:(UITableView *)tableView testCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = self.identify;
    UITableViewCell *cell = nil;
    if (!cell) {
        //试着注册xib型cell
        if ([[NSBundle mainBundle] pathForResource:identify ofType:@"xib"]) {
            [tableView registerNib:[UINib nibWithNibName:identify bundle:nil] forCellReuseIdentifier:identify];
            cell = [tableView dequeueReusableCellWithIdentifier:identify];
        }
    }
    if (!cell) {
        //试着注册class型cell
        if (NSClassFromString(identify) &&
            [NSClassFromString(identify) isSubclassOfClass:[UITableViewCell class]]) {
            [tableView registerClass:NSClassFromString(identify) forCellReuseIdentifier:identify];
            cell = [tableView dequeueReusableCellWithIdentifier:identify];
        }
    }
    return cell;
}

@end
