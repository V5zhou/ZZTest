//
//  URLProtocolViewController.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/3.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "URLProtocolViewController.h"
#import "ZZWebTextReplace.h"

@implementation URLProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    //输入你所要替换文本所在的URL。注意：此处不一定为你发起请求的源URL，因为一个请求包含有css，js，html，公共js文件，每个文件都是一个URL。
    NSDictionary *lisenURLS = @{
                                @"https://www.jianshu.com/p/bff75ce137fc" :
                                    @{
                                        @"我": @"❌",
                                        @"你": @"💢",
                                        @"的": @"💤",
                                        },
                                @"https://m.haiwainet.cn/ttc/3541093/2018/0504/content_31310307_1.html?tt_from=mobile_qq&tt_group_id=6551639411321209358": @{
                                        @"台湾": @"《中国台湾省》",
                                        }
                                };
    [ZZWebTextReplace startWithLisenURLS:lisenURLS];
    
    //源URL发起请求
//    NSString *urlString = @"https://www.jianshu.com/p/bff75ce137fc";
    NSString *urlString = @"https://m.haiwainet.cn/ttc/3541093/2018/0504/content_31310307_1.html?tt_from=mobile_qq&tt_group_id=6551639411321209358";
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)dealloc {
    [ZZWebTextReplace end];
}

@end
