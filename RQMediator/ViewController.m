//
//  ViewController.m
//  RQMediator
//
//  Created by 谢仁强 on 2020/7/8.
//  Copyright © 2020 谢仁强. All rights reserved.
//

#import "ViewController.h"
#import "RQMediator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)logAction:(id)sender
{
    [[RQMediator sharedMediator] sendAction:@"calculatorLog" to:@"Calculator"];
}

- (IBAction)plus:(id)sender
{
    NSArray *params = @[@(2),@(3)];
    id result = [[RQMediator sharedMediator] sendAction:@"plusA:b:" to:@"Calculator" params:params];
    NSLog(@"%@",result);
}

- (IBAction)nsstring:(id)sender
{
    id result = [[RQMediator sharedMediator] sendAction:@"stringForCalculator" to:@"Calculator"];
    NSLog(@"%@",result);
}

@end
