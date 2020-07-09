//
//  RQMediator.h
//  RQMediator
//
//  Created by 谢仁强 on 2020/7/8.
//  Copyright © 2020 谢仁强. All rights reserved.
//

//- (void)openURL:(NSURL*)url options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const RQMediatorSwiftTargetModuleParamsKey;

@interface RQMediator : NSObject

+ (instancetype)sharedMediator;

// 外部组件调用入口
- (id _Nullable)openURL:(NSURL *)url;

- (id _Nullable)openURL:(NSURL *)url completionHandler:(void (^ _Nullable)(NSDictionary * info))completion;

// 内部组件调用入口
- (id _Nullable)sendAction:(NSString * _Nullable)actionString to:(NSString * _Nullable)targetString;

- (id _Nullable)sendAction:(NSString * _Nullable)actionString
                        to:(NSString * _Nullable)targetString
                    params:(NSDictionary * _Nullable)params;

- (id _Nullable)sendAction:(NSString * _Nullable)actionString
                        to:(NSString * _Nullable)targetString
                    params:(NSDictionary * _Nullable)params
                     cache:(BOOL)isCacheTarget;

- (void)removeTargetCacheWith:(NSString *)targetName;

@end

NS_ASSUME_NONNULL_END
