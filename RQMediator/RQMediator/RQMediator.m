//
//  RQMediator.m
//  RQMediator
//
//  Created by 谢仁强 on 2020/7/8.
//  Copyright © 2020 谢仁强. All rights reserved.
//

#import "RQMediator.h"

@interface RQMediator ()

@property (nonatomic, strong) NSMutableArray * targetCache;

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

- (void)openURL:(NSURL *)url
{
    [self openURL:url completionHandler:NULL];
}

- (void)openURL:(NSURL *)url completionHandler:(void (^ _Nullable)(NSDictionary * info))completion
{
    
}

- (void)sendAction:(NSString * _Nullable)action to:(NSString * _Nullable)target
{
    [self sendAction:action to:target params:nil];
}

- (void)sendAction:(NSString * _Nullable)action
                to:(NSString * _Nullable)target
            params:(NSDictionary * _Nullable)params
{
    [self sendAction:action to:target params:params cache:NO];
}

- (void)sendAction:(NSString * _Nullable)action
                to:(NSString * _Nullable)target
            params:(NSDictionary * _Nullable)params
             cache:(BOOL)isCacheTarget
{
    
}

- (void)removeTargetCacheWith:(NSString *)target
{
    
}

#pragma mark - setter and getter

- (NSMutableArray *)targetCache
{
    if (!_targetCache) {
        _targetCache = [[NSMutableArray alloc] init];
    }
    return _targetCache;
}

@end
