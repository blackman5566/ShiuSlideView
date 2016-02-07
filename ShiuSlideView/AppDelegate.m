//
//  AppDelegate.m
//  ShiuSlideView
//
//  Created by 許佳豪 on 2016/2/2.
//  Copyright © 2016年 許佳豪. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [MainViewController new];
    [self.window makeKeyAndVisible];
    CGRect windowRect = [[UIScreen mainScreen]bounds];
    
    NSLog(@"%@", NSStringFromCGRect(windowRect));
   // - See more at: http://furnacedigital.blogspot.tw/2011/10/blog-post_13.html#sthash.y9S0lmZf.dpuf
    return YES;
}

@end
