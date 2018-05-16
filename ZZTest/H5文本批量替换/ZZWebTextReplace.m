//
//  ZZWebTextReplace.m
//  ZZTest
//
//  Created by 多米智投 on 2018/5/4.
//  Copyright © 2018年 多米智投. All rights reserved.
//

#import "ZZWebTextReplace.h"

//记录监听替换规则
static NSDictionary<LisenURL, NSDictionary<SourceText, ReplaceText> *> *lisenURLS = nil;

@interface ZZWebTextReplace() <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableData *data;

@end

@implementation ZZWebTextReplace

+ (void)startWithLisenURLS:(NSDictionary<LisenURL, NSDictionary<SourceText, ReplaceText> *> *)URLS {
    [NSURLProtocol registerClass:self];
    lisenURLS = URLS;
}

+ (void)end {
    [NSURLProtocol unregisterClass:self];
    lisenURLS = nil;
}

#pragma mark - NSURLProtocol需要覆盖四大方法
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSMutableURLRequest *request = [self.request mutableCopy];
    NSURLSessionDataTask *sessionTask = [self.session dataTaskWithRequest:request];
    [sessionTask resume];
}

- (void)stopLoading {
    [self.session invalidateAndCancel];
    self.session = nil;
}

#pragma mark - gettter
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 10;
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:queue];
    }
    return _session;
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (!_data) {
        _data = [data mutableCopy];
    }
    else {
        [_data appendData:data];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSLog(@"--->Complete:%@", self.request.URL.absoluteString);
    if (error) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        NSData *data = [self replaceTextForURL:self.request.URL.absoluteString];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
        self.data = nil;
    }
}

- (NSData *)replaceTextForURL:(NSString *)URL {
    //检查url
    NSData *data = self.data;
    if (!URL || ![URL isKindOfClass:[NSString class]] || URL.length < 1) {
        return data;
    }
    //url符合规范，查看是否要替换
    NSDictionary *shouldReplace = [lisenURLS objectForKey:URL];
    if (![shouldReplace isKindOfClass:[NSDictionary class]]) {
        return data;
    }
    //data转换为字符串
    NSString *dataString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    if (!dataString) {
        return data;
    }
    //开始遍历字典替换字符串
    for (NSString *key in [shouldReplace allKeys]) {
        NSString *value = shouldReplace[key];
        dataString = [dataString stringByReplacingOccurrencesOfString:key withString:value];
    }
    NSData *replacedData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    return replacedData;
}

@end
