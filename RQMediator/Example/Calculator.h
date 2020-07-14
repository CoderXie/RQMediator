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

- (int)plusA:(NSNumber *)a b:(NSNumber *)b;

- (int)testArray:(NSArray *)a b:(NSArray *)b;

- (NSString *)stringForCalculator;

@end

NS_ASSUME_NONNULL_END
