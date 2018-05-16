//
//  Moniter.h
//  Test
//
//  Created by 多米智投 on 2018/4/12.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Moniter : NSObject

+ (instancetype)shareInstance;

- (void)run;

- (void)stop;

@end
