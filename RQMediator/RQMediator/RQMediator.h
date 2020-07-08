//
//  RQMediator.h
//  RQMediator
//
//  Created by 谢仁强 on 2020/7/8.
//  Copyright © 2020 谢仁强. All rights reserved.
//

//- (void)openURL:(NSURL*)url options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RQMediator : NSObject

+ (instancetype)sharedMediator;

// 外部组件调用入口
- (void)openURL:(NSURL *)url;

- (void)openURL:(NSURL *)url completionHandler:(void (^ _Nullable)(NSDictionary * info))completion;

// 内部组件调用入口
- (void)sendAction:(NSString * _Nullable)action to:(NSString * _Nullable)target;

- (void)sendAction:(NSString * _Nullable)action
                to:(NSString * _Nullable)target
            params:(NSDictionary * _Nullable)params;

- (void)sendAction:(NSString * _Nullable)action
                to:(NSString * _Nullable)target
            params:(NSDictionary * _Nullable)params
             cache:(BOOL)isCacheTarget;

- (void)removeTargetCacheWith:(NSString *)target;

@end

NS_ASSUME_NONNULL_END
