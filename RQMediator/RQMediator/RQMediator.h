//
//  RQMediator.h
//  RQMediator
//
//  Created by 谢仁强 on 2020/7/8.
//  Copyright © 2020 谢仁强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface RQMediator : NSObject

+ (instancetype)sharedMediator;

// 外部组件调用入口
- (id)openURL:(NSURL *)url;

- (id)openURL:(NSURL *)url completionHandler:(nullable void (^)(id _Nullable info))completion;

// 内部组件调用入口
- (id)sendAction:(nonnull NSString *)actionString to:(nonnull NSString *)targetString;

- (id)sendAction:(nonnull NSString *)actionString
              to:(nonnull NSString *)targetString
          params:(nullable NSArray *)params;

- (id)sendAction:(nonnull NSString *)actionString
              to:(nonnull NSString *)targetString
          params:(nullable NSArray *)params
           cache:(BOOL)isCacheTarget;

- (void)setNoTarget:(nonnull NSString *)target action:(nonnull NSString *)action;

- (void)removeTargetCacheWith:(nullable NSString *)targetName;

@end

NS_ASSUME_NONNULL_END
