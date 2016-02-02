//
//  ShiuSlideView.m
//  ShiuSlideView
//
//  Created by 許佳豪 on 2016/2/2.
//  Copyright © 2016年 許佳豪. All rights reserved.
//

#import "ShiuSlideView.h"

#define TopViewWidth 50
#define TopViewHeight 50

@interface ShiuSlideView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *arrayViews;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ShiuSlideView
@synthesize arrayViews = _arrayViews;

- (instancetype)initWithFrame:(CGRect)frame WithViewControllers:(NSArray *)viewControllers {
    if (self = [super initWithFrame:frame]) {
        self.arrayViews = viewControllers;
    }
    return self;
}

- (void)setArrayViews:(NSArray *)arrayViews {
    _arrayViews = arrayViews;
    [self setupTopView];
    [self setupScrollView];
}

- (void)setupTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TopViewHeight)];
    topView.backgroundColor = [UIColor redColor];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TopViewWidth, TopViewHeight)];
    [leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    [leftButton setTitle:@"<" forState:UIControlStateNormal];

    CGFloat x = ScreenWidth - TopViewWidth;
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, TopViewWidth, TopViewHeight)];
    [rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    [rightButton setTitle:@">" forState:UIControlStateNormal];

    CGFloat centerX = (CGRectGetWidth(topView.frame) - 100) / 2;
    CGFloat centerY = (CGRectGetHeight(topView.frame) - 50) / 2;
    UILabel *displayLable = [[UILabel alloc] initWithFrame:CGRectMake(centerX, centerY, 100, 50)];
    displayLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    displayLable.text = @"哈嚕";
    displayLable.textColor = [UIColor whiteColor];
    displayLable.textAlignment = NSTextAlignmentCenter;

    [topView addSubview:displayLable];
    [topView addSubview:leftButton];
    [topView addSubview:rightButton];
    [self addSubview:topView];

}

- (void)setupScrollView {
    CGFloat height = ScreenHeight - TopViewHeight;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopViewHeight, ScreenWidth, height)];
    for (int i = 0; i < self.arrayViews.count; i++) {
        CGRect viewControllerFrame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, height);
        UIViewController *viewController = self.arrayViews[i];
        viewController.view.frame = viewControllerFrame;
        [self.scrollView addSubview:viewController.view];
    }
    [self addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.arrayViews.count * ScreenWidth, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentIndex = ((scrollView.contentOffset.x - ScreenWidth / 2) / ScreenWidth) + 1;
}

#pragma mark - Button Action

- (void)buttonAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger currentIndex = ((self.scrollView.contentOffset.x - ScreenWidth / 2) / ScreenWidth);
    NSLog(@"%d", currentIndex);
    if ([button.titleLabel.text isEqualToString:@">"]) {
        [self.scrollView setContentOffset:CGPointMake((currentIndex + 1) * ScreenWidth, 0) animated:YES];
    }
    else {
        [self.scrollView setContentOffset:CGPointMake((currentIndex - 1) * ScreenWidth, 0) animated:YES];

    }
}

@end
