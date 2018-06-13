//
//  ZZWebTextReplace.h
//  ZZTest
//
//  Created by 多米智投 on 2018/5/4.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *LisenURL;         ///< 监听URL
typedef NSString *SourceText;       ///< 替换前文字
typedef NSString *ReplaceText;      ///< 替换后文字
@interface ZZWebTextReplace : NSURLProtocol

/**
 开始监听URL请求
 > 传入URLS为一个字典，字典结构为
 > {
 >    LisenURL: {
 >        SourceText: ReplaceText
 >    }
 > }
 > 注意：LisenURL不一定为你发起请求的源URL，因为一个请求包含有css，js，html，公共js文件，每个文件都是一个URL。监听的为对应文件的URL。
 */
+ (void)startWithLisenURLS:(NSDictionary<LisenURL, NSDictionary<SourceText, ReplaceText> *> *)URLS;

/**
 停止监听
 */
+ (void)end;

@end
