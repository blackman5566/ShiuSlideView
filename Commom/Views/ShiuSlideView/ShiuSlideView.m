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
    [self setupParameters];
    [self setupColor];
    [self setupTopView];
    [self setupScrollView];
}

- (void)setupParameters {
    self.middenIndex = 1;
    self.nextIndex = 1;
}

- (void)setupTopView {
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
    self.colorArrays = @[@{ @"red":@238, @"green":@221, @"blue":@130 }, @{ @"red":@162, @"green":@205, @"blue":@90 }, @{ @"red":@64, @"green":@224, @"blue":@208 }];
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

    self.scrollView.userInteractionEnabled = YES;
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

- (void)changeDisplayLabel:(CGFloat)offsetX {
    CGFloat transitionPoints = ScreenWidth / 2;
    offsetX -= ScreenWidth;
    CGFloat temp = fabs(offsetX) / transitionPoints;
    self.displayLable.alpha = fabs(1 - temp);

    if ([self isOffsetXInRange:offsetX]) {
        [self changeDisplayLable:offsetX transitionPoints:transitionPoints];
        [self changeBackgroundColor:offsetX];
    }
}

- (CGFloat)creatColorWithMiddenColor:(CGFloat)middenColor andChangeColor:(CGFloat)changeColor inOffsetX:(int)offsetX {
    CGFloat colorGap = changeColor - middenColor;
    changeColor = middenColor + (colorGap * (abs(offsetX) / ScreenWidth));
    return changeColor;
}

- (void)changeBackgroundColor:(CGFloat)offsetX {
    NSInteger colorIndex;
    if (offsetX < 0) {
        colorIndex = [self correctionIndex:self.middenIndex - 1];
    }
    else if (offsetX > 0) {
        colorIndex = [self correctionIndex:self.middenIndex + 1];
    }

    NSNumber *red = self.colorArrays[self.middenIndex][@"red"];
    NSNumber *green = self.colorArrays[self.middenIndex][@"green"];
    NSNumber *blue = self.colorArrays[self.middenIndex][@"blue"];

    NSNumber *nextRed = self.colorArrays[colorIndex][@"red"];
    NSNumber *nextGreen = self.colorArrays[colorIndex][@"green"];
    NSNumber *nextBlue = self.colorArrays[colorIndex][@"blue"];

    CGFloat newRed = [self creatColorWithMiddenColor:[red doubleValue] andChangeColor:[nextRed doubleValue] inOffsetX:offsetX];
    CGFloat newGreen = [self creatColorWithMiddenColor:[green doubleValue] andChangeColor:[nextGreen doubleValue] inOffsetX:offsetX];
    CGFloat newBlue = [self creatColorWithMiddenColor:[blue doubleValue] andChangeColor:[nextBlue doubleValue] inOffsetX:offsetX];
    self.topView.backgroundColor = UIColorRGBA(newRed, newGreen, newBlue, 1);
}

- (void)changeDisplayLable:(CGFloat)offsetX transitionPoints:(CGFloat)transitionPoints {
    if ([self isOffsetXInRange:offsetX]) {
        if (offsetX > transitionPoints) {
            self.nextIndex = [self correctionIndex:self.middenIndex + 1];
        }
        else if (offsetX < -transitionPoints) {
            self.nextIndex = [self correctionIndex:self.middenIndex - 1];

        }
        self.displayLable.text = self.viewControllers[self.nextIndex][@"title"];
    }
}

- (BOOL)isOffsetXInRange:(CGFloat)offsetX {
    if (offsetX > 0 || offsetX < 0) {
        return YES;
    }
    return NO;
}

@end
