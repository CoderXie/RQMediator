//
//  Calculator.h
//  RQMediator
//
//  Created by 谢仁强 on 2020/7/9.
//  Copyright © 2020 谢仁强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Calculator : NSObject

- (void)calculatorLog;

- (int)plusA:(int)a b:(int)b;

- (NSString *)stringForCalculator;

@end

NS_ASSUME_NONNULL_END