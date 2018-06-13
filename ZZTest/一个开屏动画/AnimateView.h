//
//  AnimateView.h
//  OpenScreenAnimate
//
//  Created by 多米智投 on 2018/3/15.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 第一行是类的简介
 
 在简介的下面,就是类的详细介绍了。
 没有间隔换行会被消除，就像Html那样。
 
 下面是常用的markdown语法
 
 分割线：
 
 - - -
 
 无序列表: (每行以 '*'、'-'、'+' 开头):
 
 * this is the first line
 * this is the second line
 * this is the third line
 
 有序列表: (每行以 1.2.3、a.b.c 开头):
 
 a. this is the first line
 b. this is the secode line
 
 多级列表:
 
 * this is the first line
 a. this is line a
 b. this is line b
 * this is the second line
 1. this in line 1
 2. this is line 2
 
 标题:
 
 # This is an H1
 ## This is an H2
 ### This is an H3
 #### This is an h4
 ##### This is an h5
 ###### This is an H6
 
 链接:
 
 普通URL直接写上，appledoc会自动翻译成链接: http://blog.ibireme.com
 [这个](http://example.net/) 链接会隐藏实际URL.
 
 表格:
 
 | header1 | header2 | header3 |
 |---------|:-------:|--------:|
 | normal  |  center |  right  |
 | cell    | cell    | cell    |
 
 */
@interface AnimateView : UIView

@end
