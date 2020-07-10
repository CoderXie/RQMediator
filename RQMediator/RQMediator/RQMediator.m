//
//  RQMediator.m
//  RQMediator
//
//  Created by 谢仁强 on 2020/7/8.
//  Copyright © 2020 谢仁强. All rights reserved.
//

#import "RQMediator.h"
#import <objc/runtime.h>

NSString * const RQMediatorSwiftTargetModuleParamsKey = @"kRQMediatorSwiftTargetModuleParamsKey";
@interface RQMediator ()

@property (nonatomic, strong) NSMutableDictionary *targetCache;

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
- (id _Nullable)openURL:(NSURL *)url
{
    return [self openURL:url completionHandler:NULL];
}

- (id _Nullable)openURL:(NSURL *)url completionHandler:(void (^ _Nullable)(NSDictionary * info))completion
{
    if (url == nil) return nil;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray  *paramArray = [url.query componentsSeparatedByString:@"&"];
    for (NSString *param in paramArray) {
        NSArray *keyValues = [param componentsSeparatedByString:@"="];
        if ([keyValues count] < 2) continue;
        [params setObject:keyValues.lastObject forKey:keyValues.firstObject];
    }
    
    // 出于安全考虑，防止黑客通过远程方式调用本地模块。
    NSString *action = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([action hasPrefix:@"native"]) {
        return @(NO);
    }
    
    id result = [self sendAction:action to:url.host params:params cache:NO];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    
    return result;
}

- (id _Nullable)sendAction:(NSString * _Nullable)actionString to:(NSString * _Nullable)targetString
{
    return [self sendAction:actionString to:targetString params:nil];
}

- (id _Nullable)sendAction:(NSString * _Nullable)actionString
                        to:(NSString * _Nullable)targetString
                    params:(NSDictionary * _Nullable)params
{
    return [self sendAction:actionString to:targetString params:params cache:NO];
}

- (id _Nullable)sendAction:(NSString * _Nullable)actionString
                        to:(NSString * _Nullable)targetString
                    params:(NSDictionary * _Nullable)params
                     cache:(BOOL)isCacheTarget
{
    if (actionString == nil || targetString == nil) {
        return nil;
    }
    
    // 生成target
    NSString *swiftModuleName = params[RQMediatorSwiftTargetModuleParamsKey];
    NSString *targetName = nil;
    if (swiftModuleName.length > 0) {
        targetName = [NSString stringWithFormat:@"%@.%@",swiftModuleName,targetString];
    } else {
        targetName = [NSString stringWithFormat:@"%@",targetString];
    }
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
            return [self _safePerformAction:action target:target params:params];
        } else {
            [self _noTargetWith:targetName selectorString:actionName params:params];
            [self removeTargetCacheWith:targetName];
            return nil;
        }
    }
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

- (void)_noTargetWith:(NSString *)targetString selectorString:(NSString *)selectorString params:(NSDictionary *)originParams
{
    SEL action = NSSelectorFromString(@"Action_response:");
    NSObject *target = [[NSClassFromString(@"Target_NoTargetAction") alloc] init];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"originParams"] = originParams;
    params[@"targetString"] = targetString;
    params[@"selectorString"] = selectorString;
    
    [self _safePerformAction:action target:target params:params];
}

- (id)_safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
{
    NSMethodSignature *methodSign = [target methodSignatureForSelector:action];
    if (methodSign == nil) return nil;
    
    const char *returnType = [methodSign methodReturnType];
    
    if (strcmp(returnType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSign];
        if (params) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(returnType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSign];
        if (params) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = NO;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(returnType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSign];
        if (params) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(returnType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSign];
        if (params) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(returnType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSign];
        if (params) {
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
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
