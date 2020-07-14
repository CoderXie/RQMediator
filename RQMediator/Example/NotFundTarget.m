//
//  NotFundTarget.m
//  RQMediator
//
//  Created by 谢仁强 on 2020/7/14.
//  Copyright © 2020 谢仁强. All rights reserved.
//

#import "NotFundTarget.h"
#import <UIKit/UIKit.h>

@implementation NotFundTarget

- (UIViewController *)topViewController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentingViewController) {
        topController = topController.presentingViewController;
    }
    return topController;
}

- (void)notFound:(id)sender;
{
    NSLog(@"%@",sender);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"NotFund" message:@"没有找到这个target" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL]];
    [[self topViewController] presentViewController:alert animated:YES completion:NULL];
}

@end
