//
//  DMProgressAnimateImage.h
//  Test
//
//  Created by 多米智投 on 2018/5/14.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMProgressAnimateImage : UIView

@property (nonatomic, strong) UIColor *strokeColor;     ///< 线条颜色
@property (nonatomic, assign) CGFloat strokeWidth;      ///< 线条粗细 小数点后允许一位
@property (nonatomic, assign) CGFloat radiaW;           ///< 圈圈半径大小 小数点后允许一位

- (void)showTips;
- (void)showError;
- (void)showSuccess;

@end
