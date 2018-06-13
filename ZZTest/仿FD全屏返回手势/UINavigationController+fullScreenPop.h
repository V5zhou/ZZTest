//
//  UINavigationController+fullScreenPop.h
//  ZZTest
//
//  Created by 多米智投 on 2018/5/21.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *kNotificationPanProgress;
@interface UINavigationController (fullScreenPop)

@property (nonatomic, assign) BOOL preferFullPop;   ///< 是否开启全屏手势

@end

@interface UIViewController (zz_navigation)

@property (nonatomic, assign) BOOL preferNavigationHidden;

@end
