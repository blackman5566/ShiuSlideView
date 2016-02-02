//
//  ShiuSlideView.h
//  ShiuSlideView
//
//  Created by 許佳豪 on 2016/2/2.
//  Copyright © 2016年 許佳豪. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height)

@interface ShiuSlideView : UIView

- (instancetype)initWithFrame:(CGRect)frame WithViewControllers:(NSArray *)viewControllers;

@end
