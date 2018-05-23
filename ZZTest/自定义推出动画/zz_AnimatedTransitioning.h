//
//  zz_AnimatedTransitioning.h
//  ZZTest
//
//  Created by 多米智投 on 2018/5/22.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zz_AnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPush;           ///< 是push还是pop

@end
