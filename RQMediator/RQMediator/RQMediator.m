//
//  RQMediator.m
//  RQMediator
//
//  Created by 谢仁强 on 2020/7/8.
//  Copyright © 2020 谢仁强. All rights reserved.
//

#import "RQMediator.h"
#import <objc/runtime.h>

@interface RQMediator ()

@property (nonatomic, strong) NSMutableDictionary *targetCache;
@property (nonatomic, copy) NSString *target;
@property (nonatomic, copy) NSString *action;

@end

@implementation RQMediator

#pragma mark - public methods

+ (instancetype)sharedMediator
{
    static RQMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[RQMediator alloc] init];
    });
    return mediator;
}

/*
scheme://[target]/[action]?[params]

url sample:
aaa://targetA/actionB?id=1234
*/
- (id)openURL:(NSURL *)url
{
    return [self openURL:url completionHandler:NULL];
}

- (id)openURL:(NSURL *)url completionHandler:(nullable void (^)(id _Nullable info))completion
{
    if (url == nil) return nil;
    
    NSMutableArray *params = [NSMutableArray array];
    NSArray  *paramArray = [url.query componentsSeparatedByString:@"&"];
    for (NSString *param in paramArray) {
        NSArray *keyValues = [param componentsSeparatedByString:@"="];
        if ([keyValues count] < 2) continue;
        [params addObject:keyValues.lastObject];
    }
    
    NSString *actionString = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    id result = [self sendAction:actionString to:url.host params:params cache:NO];
    
    if (completion) {
        completion(result);
    }
    return result;
}

- (id)sendAction:(nonnull NSString *)actionString to:(nonnull NSString *)targetString
{
    return [self sendAction:actionString to:targetString params:@[]];
}

- (id)sendAction:(nonnull NSString *)actionString
              to:(nonnull NSString *)targetString
          params:(nullable NSArray *)params
{
    return [self sendAction:actionString to:targetString params:params cache:NO];
}

- (id)sendAction:(nonnull NSString *)actionString
              to:(nonnull NSString *)targetString
          params:(nullable NSArray *)params
           cache:(BOOL)isCacheTarget
{
    if (actionString == nil || targetString == nil) {
        return nil;
    }
    
    // 生成objc target
    NSString *targetName = [NSString stringWithFormat:@"%@",targetString];
    
    // 生成swift target
    // 待续。。。
    
    NSObject *target = self.targetCache[targetName];
    if (target == nil) {
        Class targetClass = NSClassFromString(targetName);
        target = [[targetClass alloc] init];
    }
    
    // 生成action
    NSString *actionName = [NSString stringWithFormat:@"%@",actionString];
    SEL action = NSSelectorFromString(actionName);
    
    // 处理无响应者
    if (target == nil) {
        [self _noTargetWith:targetName selectorString:actionName params:params];
        return nil;
    }
    
    if (isCacheTarget) {
        self.targetCache[targetName] = target;
    } else {
        [self removeTargetCacheWith:targetName];
    }
    
    if ([target respondsToSelector:action]) {
        return [self _safePerformAction:action target:target params:params];
    } else {
        
        SEL action = NSSelectorFromString(@"notFound:");
        
        if ([target respondsToSelector:action]) {
            NSDictionary *dict = @{@"originParams":params};
            return [self _safePerformAction:action target:target params:@[dict]];
        } else {
            [self _noTargetWith:targetName selectorString:actionName params:params];
            [self removeTargetCacheWith:targetName];
            return nil;
        }
    }
}

- (void)setNoTarget:(nonnull NSString *)target action:(nonnull NSString *)action
{
    _target = target;
    _action = action;
}

- (void)removeTargetCacheWith:(NSString *)targetName
{
    if (targetName == nil) {
        return;
    }
    if ([self.targetCache.allKeys containsObject:targetName]) {
        [self.targetCache removeObjectForKey:targetName];
    }
}

#pragma mark - private methods

// 自定义方法
- (void)_noTargetWith:(NSString *)targetString selectorString:(NSString *)selectorString params:(NSArray *)originParams
{
    if (_target == nil || _action == nil) {
        return;
    }
    SEL action = NSSelectorFromString(_action);
    NSObject *target = [[NSClassFromString(_target) alloc] init];
    NSDictionary *dict = @{@"originParams":originParams};
    [self _safePerformAction:action target:target params:@[dict]];
}

- (id)_safePerformAction:(SEL)action target:(NSObject *)target params:(nullable NSArray *)params
{
    NSMethodSignature *methodSign = [target methodSignatureForSelector:action];
    if (methodSign == nil) return nil;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSign];
    [invocation setSelector:action];
    [invocation setTarget:target];
    NSUInteger count = MIN(methodSign.numberOfArguments - 2, params.count);
    for (int i = 0; i < count; i++) {
        id object = params[i];
        if ([object isKindOfClass:[NSNull class]]) object = nil;
        [invocation setArgument:&object atIndex:i + 2];
    }
    [invocation invoke];
    
    const char *type = methodSign.methodReturnType;
    if (strcmp(type, @encode(void)) == 0) {
        return nil;
    }
    
    if (strcmp(type, "@") == 0) {
        id result = nil;
        [invocation getReturnValue:&result];
        return result;
    }
    
    if (strcmp(type, @encode(int)) == 0) {
        int result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(type, @encode(NSInteger)) == 0) {
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(type, @encode(BOOL)) == 0) {
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(type, @encode(CGFloat)) == 0) {
        CGFloat result = 0.f;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(type, @encode(NSUInteger)) == 0) {
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    return nil;
}

#pragma mark - setter and getter

- (NSMutableDictionary *)targetCache
{
    if (!_targetCache) {
        _targetCache = [NSMutableDictionary dictionary];
    }
    return _targetCache;
}

@end
