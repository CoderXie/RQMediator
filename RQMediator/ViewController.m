//
//  ViewController.m
//  RQMediator
//
//  Created by 谢仁强 on 2020/7/8.
//  Copyright © 2020 谢仁强. All rights reserved.
//

#import "ViewController.h"
#import "RQMediator.h"
#import "Calculator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[RQMediator sharedMediator] setNoTarget:@"NotFundTarget" action:@"notFound:"];
}

- (IBAction)logAction:(id)sender
{
    [[RQMediator sharedMediator] sendAction:@"calculatorLog" to:@"Calculator"];
}

- (IBAction)plus:(id)sender
{
//    Calculator * cal = [Calculator new];
//    int res = [cal plusA:3 b:5];
//    NSLog(@"%d",res);
//    NSLog(@"%@",[NSThread callStackSymbols]);
//    return;
    NSArray *params = @[@[@(1),@(2)],@[@(3),@(4)]];
    id result = [[RQMediator sharedMediator] sendAction:@"testArray:b:" to:@"Calculator" params:params];
    NSLog(@"%d",[result intValue]);
    
//    NSURL *url = [NSURL URLWithString:@"mediator://Calculator/plusA:b:?a=2&b=3"];
//    id result = [[RQMediator sharedMediator] openURL:url];
//    NSLog(@"%@",result);
}

- (IBAction)nsstring:(id)sender
{
    [[RQMediator sharedMediator] sendAction:@"stringForCalculator" to:@"Calculator1" params:@[@(2),@(3)]];
}

@end
