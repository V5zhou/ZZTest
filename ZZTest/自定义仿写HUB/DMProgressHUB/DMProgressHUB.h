//
//  DMProgressHUB.h
//  DMZT_V2
//
//  Created by 多米智投 on 2018/4/23.
//  Copyright © 2018年 lihuihan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DMProgressHUBStyle) {
    DMProgressHUBStyle_Native = 0,
    DMProgressHUBStyle_Flat,
};

@interface DMProgressHUB : UIView

/**
 显示与隐藏
 */
+ (void)showActivity;                        //转圈圈
+ (void)showActivity:(NSString *)message;    //转圈圈及文本提示
+ (void)popActivity;                         //count--
+ (void)dismiss;                             //消失
+ (void)dismissWithDelay:(NSTimeInterval)delay;    //延迟消失

/**
 提示信息
 */
+ (void)showMessage:(NSString *)message;
+ (void)showAutoHideMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message image:(UIImage *)image;
+ (void)showAutoHideMessage:(NSString *)message image:(UIImage *)image;

/**
 成功/失败/警告
 */
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)showTips:(NSString *)tips;

#pragma mark - 样式定制
//背景
+ (void)setBackgroundColor:(UIColor *)backColor;
+ (void)setBackInsets:(UIEdgeInsets)backInsets;

//info
+ (void)setInfoFont:(UIFont *)infoFont;
+ (void)setInfoColor:(UIColor *)infoColor;
+ (void)setInfoTop:(CGFloat)infoTop;

//activity
+ (void)setActivityStyle:(DMProgressHUBStyle)activityStyle;
+ (void)setActivityColor:(UIColor *)activityColor;
+ (void)setActivityWidth:(CGFloat)activityWidth;
+ (void)setActivityStrokeWidth:(NSInteger)activityStrokeWidth;
+ (void)setActivityDashNum:(NSUInteger)activityDashNum;

//image
+ (void)setImageWidth:(CGFloat)imageWidth;

//delay
+ (void)setDelay:(NSTimeInterval)delay;

@end
