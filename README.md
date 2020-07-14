# RQMediator

#### 介绍
iOS 组件化方案

#### 如何安装

```bash

pod 'RQMediator'
or
pod 'RQMediator', :git => 'https://gitee.com/yin_gu/RQMediator.git'

pod install
```

#### 使用说明

```objc
// 外部组件调用入口
// scheme://[target]/[action]?[params]
// url sample:
// aaa://targetA/actionB?id=1234

- (id)openURL:(NSURL *)url;

- (id)openURL:(NSURL *)url completionHandler:(void (^ _Nullable)(id info))completion;
```

```objc
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
```
