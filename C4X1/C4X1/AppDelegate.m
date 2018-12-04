//
//  AppDelegate.m
//  C4X1
//
//  Created by 冯宇 on 2018/9/17.
//  Copyright © 2018年 冯宇. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomNavigationController.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NetworkStatusObserver shareObserver] startObserve];
    RootViewController * root = [[RootViewController alloc] init];
    CustomNavigationController * nav = [[CustomNavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = nav;
    NSLog(@"%@",NSHomeDirectory());
    return YES;
}

@end
