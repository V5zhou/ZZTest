//
//  DMRadiaView.h
//  DMZT_V2
//
//  Created by 多米智投 on 2018/4/23.
//  Copyright © 2018年 lihuihan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMRadiaView : UIView

@property (nonatomic, strong) UIColor *strokeColor;     ///< 线条颜色
@property (nonatomic, assign) CGFloat strokeWidth;      ///< 线条粗细 小数点后允许一位
@property (nonatomic, assign) CGFloat radiaW;           ///< 圈圈半径大小 小数点后允许一位
@property (nonatomic, assign) NSUInteger dashNum;       ///< 分段数 默认2

//刷新
- (void)reloadRadiaView;

- (void)run;
- (void)stop;

@end
