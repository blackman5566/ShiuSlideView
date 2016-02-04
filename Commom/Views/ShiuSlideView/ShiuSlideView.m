//
//  ShiuSlideView.m
//  ShiuSlideView
//
//  Created by 許佳豪 on 2016/2/2.
//  Copyright © 2016年 許佳豪. All rights reserved.
//

#import "ShiuSlideView.h"
#import "FirstViewController.h"
#define TopViewWidth 50
#define TopViewHeight 50

@interface ShiuSlideView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *displayLable;
@property (nonatomic, assign) NSInteger middenIndex;
@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, assign) CGFloat endOffsetX;
@property (nonatomic, assign) CGFloat willEndOffsetX;
@property (nonatomic, assign) BOOL isEndOfScroll;

@end

@implementation ShiuSlideView
@synthesize viewControllers = _viewControllers;

- (instancetype)initWithFrame:(CGRect)frame WithViewControllers:(NSArray *)viewControllers {
    if (self = [super initWithFrame:frame]) {
        self.viewControllers = viewControllers;
    }
    return self;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    [self setupTopView];
    [self setupScrollView];
}

- (void)setupTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TopViewHeight)];
    topView.backgroundColor = [UIColor redColor];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TopViewWidth, TopViewHeight)];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchDown];
    [leftButton setTitle:@"<" forState:UIControlStateNormal];

    CGFloat x = ScreenWidth - TopViewWidth;
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, TopViewWidth, TopViewHeight)];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchDown];
    [rightButton setTitle:@">" forState:UIControlStateNormal];

    CGFloat centerX = (CGRectGetWidth(topView.frame) - 100) / 2;
    CGFloat centerY = (CGRectGetHeight(topView.frame) - 50) / 2;
    self.displayLable = [[UILabel alloc] initWithFrame:CGRectMake(centerX, centerY, 100, 50)];
    self.displayLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.displayLable.text = self.viewControllers[1][@"title"];
    self.displayLable.textColor = [UIColor whiteColor];
    self.displayLable.textAlignment = NSTextAlignmentCenter;

    [topView addSubview:self.displayLable];
    [topView addSubview:leftButton];
    [topView addSubview:rightButton];
    [self addSubview:topView];
}

- (void)setupScrollView {
    CGFloat height = ScreenHeight - TopViewHeight;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopViewHeight, ScreenWidth, height)];
    self.scrollView.contentSize = CGSizeMake(3 * ScreenWidth, height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    for (int i = 0; i < 3; i++) {
        CGRect viewControllerFrame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, height);
        UIViewController *viewController = self.viewControllers[i][@"view"];
        viewController.view.frame = viewControllerFrame;
        [self.scrollView addSubview:viewController.view];
    }
    [self addSubview:self.scrollView];
    self.middenIndex = 1;
    self.isEndOfScroll = YES;
    UIView *middenView = (UIView *)self.scrollView.subviews[1];
    [self.scrollView scrollRectToVisible:middenView.frame animated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.willEndOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.endOffsetX = scrollView.contentOffset.x;
    if (self.startOffsetX < self.willEndOffsetX && self.willEndOffsetX < self.endOffsetX) {
        // 右
        self.middenIndex++;
        [self reloadScrollView];
        NSLog(@"right");
    }
    else if (self.willEndOffsetX > self.endOffsetX && self.willEndOffsetX < self.startOffsetX) {
        // 左
        self.middenIndex--;
        [self reloadScrollView];
        NSLog(@"left");
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= 480 || scrollView.contentOffset.x <= 160) {
        self.scrollView.userInteractionEnabled = NO;
    }
}

#pragma mark - Button Action

- (void)leftButtonAction:(id)sender {
    [self leftAction];
    [UIView animateWithDuration:.25 animations: ^{
         self.scrollView.contentOffset = CGPointMake(0, 0);
     }];
    [self reloadScrollView];
}

- (void)rightButtonAction:(id)sender {
    [self rightAction];
    [UIView animateWithDuration:.25 animations: ^{
         self.scrollView.contentOffset = CGPointMake(2 * ScreenWidth, 0);
     }];
    [self reloadScrollView];
}
#pragma mark - private method

- (void)leftAction {
    self.middenIndex--;
    self.middenIndex = [self correctionIndex:self.middenIndex];
}

- (void)rightAction {
    self.middenIndex++;
    self.middenIndex = [self correctionIndex:self.middenIndex];
}

- (void)reloadScrollView {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger startIndex = self.middenIndex - 2;
    CGFloat height = ScreenHeight - TopViewHeight;
    for (int i = 0; i < 3; i++) {
        CGRect viewControllerFrame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, height);
        startIndex += 1;
        UIViewController *viewController = self.viewControllers[[self correctionIndex:startIndex]][@"view"];
        viewController.view.frame = viewControllerFrame;
        [self.scrollView addSubview:viewController.view];
    }
    UIView *middenView = (UIView *)self.scrollView.subviews[1];
    [self.scrollView scrollRectToVisible:middenView.frame animated:NO];
    self.scrollView.userInteractionEnabled = YES;
}

- (NSInteger)correctionIndex:(NSInteger)index {
    index += self.viewControllers.count;
    index %= self.viewControllers.count;
    return index;
}

@end
