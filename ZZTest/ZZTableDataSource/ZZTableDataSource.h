//
//  ZZTableDataSource.h
//  ZZTest
//
//  Created by 多米智投 on 2018/5/2.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZZCellConfig)(id cell, id model, NSIndexPath *indexPath);

@interface ZZTableDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithIdentify:(NSString *)identify
                          config:(ZZCellConfig)config;

- (id)modelAtIndexPath:(NSIndexPath *)indexPath;

//
@property (nonatomic, strong) NSArray *dataArray;

@end
