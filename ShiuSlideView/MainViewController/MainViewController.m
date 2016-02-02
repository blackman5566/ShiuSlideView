//
//  MainViewController.m
//  ShiuSlideView
//
//  Created by 許佳豪 on 2016/2/2.
//  Copyright © 2016年 許佳豪. All rights reserved.
//

#import "MainViewController.h"
#import "ShiuSlideView.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *viewControllers = @[[FirstViewController new],[SecondViewController new]];
    
    ShiuSlideView * view = [[ShiuSlideView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) WithViewControllers:viewControllers];
    [self.view addSubview:view];
}

@end
