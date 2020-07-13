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
- (id)openURL:(NSURL *)url;

- (id)openURL:(NSURL *)url completionHandler:(void (^ _Nullable)(id info))completion;

// 内部组件调用入口
- (id)sendAction:(NSString * _Nullable)actionString to:(NSString * _Nullable)targetString;

- (id)sendAction:(NSString * _Nullable)actionString
              to:(NSString * _Nullable)targetString
          params:(NSArray * _Nullable)params;

- (id)sendAction:(NSString * _Nullable)actionString
              to:(NSString * _Nullable)targetString
          params:(NSArray * _Nullable)params
           cache:(BOOL)isCacheTarget;

- (void)removeTargetCacheWith:(NSString *)targetName;

@end

NS_ASSUME_NONNULL_END
