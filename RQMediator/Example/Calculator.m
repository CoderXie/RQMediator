//
//  Calculator.m
//  RQMediator
//
//  Created by 谢仁强 on 2020/7/9.
//  Copyright © 2020 谢仁强. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

- (void)calculatorLog
{
    NSLog(@"calculatorLog");
}

- (int)plusA:(NSNumber *)a b:(NSNumber *)b
{
    return a.intValue + b.intValue;
}

- (NSString *)stringForCalculator
{
    return @"return NSString type";
}

@end
