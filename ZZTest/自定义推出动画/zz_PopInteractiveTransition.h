//
//  zz_PopInteractiveTransition.h
//  ZZTest
//
//  Created by 多米智投 on 2018/5/23.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zz_PopInteractiveTransition : UIPercentDrivenInteractiveTransition

- (void)addPopGesture:(UIViewController *)ctl;

@property(nonatomic,assign) BOOL interacting;

@end
