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
#define ScrollViewHeight (ScreenHeight - TopViewHeight)
#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha: (a)]

@interface ShiuSlideView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *displayLable;
@property (nonatomic, assign) NSInteger middenIndex;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) NSArray *colorArrays;
@property (nonatomic, assign) NSInteger nextIndex;

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
    [self setupColor];
    [self setupTopView];
    [self setupScrollView];
}

- (void)setupTopView {
    self.middenIndex = 1;
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TopViewHeight)];
    NSNumber *red = self.colorArrays[self.middenIndex][@"red"];
    NSNumber *green = self.colorArrays[self.middenIndex][@"green"];
    NSNumber *blue = self.colorArrays[self.middenIndex][@"blue"];
    self.topView.backgroundColor = UIColorRGBA([red doubleValue], [green doubleValue], [blue doubleValue], 1);
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, TopViewWidth, TopViewHeight)];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchDown];
    [leftButton setTitle:@"<" forState:UIControlStateNormal];

    CGFloat x = ScreenWidth - TopViewWidth;
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, TopViewWidth, TopViewHeight)];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchDown];
    [rightButton setTitle:@">" forState:UIControlStateNormal];

    CGFloat centerX = (CGRectGetWidth(self.topView.frame) - 100) / 2;
    CGFloat centerY = (CGRectGetHeight(self.topView.frame) - 50) / 2;
    self.displayLable = [[UILabel alloc] initWithFrame:CGRectMake(centerX, centerY, 100, 50)];
    self.displayLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.displayLable.text = self.viewControllers[self.middenIndex][@"title"];
    self.displayLable.textColor = [UIColor whiteColor];
    self.displayLable.textAlignment = NSTextAlignmentCenter;

    [self.topView addSubview:self.displayLable];
    [self.topView addSubview:leftButton];
    [self.topView addSubview:rightButton];
    [self addSubview:self.topView];
}

- (void)setupScrollView {
    CGFloat scrollViewHeight = ScreenHeight - TopViewHeight;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TopViewHeight, ScreenWidth, scrollViewHeight)];
    self.scrollView.contentSize = CGSizeMake(3 * ScreenWidth, ScrollViewHeight);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    [self reloadScrollView];
    [self addSubview:self.scrollView];
}

- (void)setupColor {
    self.colorArrays = @[@{ @"red":@100, @"green":@149, @"blue":@237 }, @{ @"red":@238, @"green":@59, @"blue":@59 }, @{ @"red":@255, @"green":@255, @"blue":@0 }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeViewWithOffset:scrollView.contentOffset.x];
    [self changeDisplayLabel:scrollView.contentOffset.x];
}

#pragma mark - Button Action

- (void)leftButtonAction:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)rightButtonAction:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(2 * ScreenWidth, 0) animated:YES];
}

#pragma mark - private method

- (void)reloadScrollView {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger startIndex = self.middenIndex - 2;
    for (int i = 0; i < 3; i++) {
        CGRect viewControllerFrame = CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScrollViewHeight);
        startIndex += 1;
        UIViewController *viewController = self.viewControllers[[self correctionIndex:startIndex]][@"view"];
        viewController.view.frame = viewControllerFrame;
        [self.scrollView addSubview:viewController.view];
    }
    [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
    self.scrollView.userInteractionEnabled = YES;
}

- (NSInteger)correctionIndex:(NSInteger)index {
    index += self.viewControllers.count;
    index %= self.viewControllers.count;
    return index;
}

- (void)changeViewWithOffset:(CGFloat)offsetX {
    CGFloat leftBorder = (float)ScreenWidth / 2;
    CGFloat rightBorder = ScreenWidth + leftBorder;
    if (offsetX >= rightBorder || offsetX <= leftBorder) {
        self.scrollView.userInteractionEnabled = NO;
    }

    if (offsetX >= ScreenWidth * 2) {
        self.middenIndex = [self correctionIndex:self.middenIndex + 1];
        [self reloadScrollView];
    }
    else if (offsetX <= 0) {
        self.middenIndex = [self correctionIndex:self.middenIndex - 1];
        [self reloadScrollView];
    }
}

- (void)changeDisplayLabel:(int)offsetX {
    int transitionPoints = ScreenWidth / 2;

    offsetX -= ScreenWidth;
    int conventX = abs(offsetX % (int)ScreenWidth);

    float temp = (float)conventX / transitionPoints;
    self.displayLable.alpha = fabs(1 - temp);

    if ([self isOffsetXInRange:offsetX]) {
        if (offsetX > transitionPoints) {
            self.nextIndex = [self correctionIndex:self.middenIndex + 1];
        }
        else if (offsetX < -transitionPoints) {
            self.nextIndex = [self correctionIndex:self.middenIndex - 1];
            
        }
        self.displayLable.text = self.viewControllers[self.nextIndex][@"title"];

        
        
        
        NSNumber *red = self.colorArrays[self.middenIndex][@"red"];
        NSNumber *green = self.colorArrays[self.middenIndex][@"green"];
        NSNumber *blue = self.colorArrays[self.middenIndex][@"blue"];
        self.topView.backgroundColor = UIColorRGBA(255, 228, 181, 1);
    }
}

- (BOOL)isOffsetXInRange:(int)offsetX {
    if (offsetX > 0 || offsetX < 0) {
        return YES;
    }
    return NO;
}

@end
