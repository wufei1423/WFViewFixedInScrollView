//
//  UIView+WFViewFixedInScrollView.m
//  WFViewFixedInScrollView
//
//  Created by feiwu on 16/3/2.
//  Copyright © 2016年 zzu. All rights reserved.
//

#import "UIView+WFViewFixedInScrollView.h"
#import <objc/runtime.h>

static NSString * const WFIsObserverScrollViewKey = @"WFIsObserverScrollViewKey";
static NSString * const WFOriginalTopMarginKey = @"WFOriginalTopMarginKey";
static NSString * const WFOriginalLeadingMarginKey = @"WFOriginalLeadingMarginKey";
static NSString * const WFTopMarginConstraintKey = @"WFTopMarginConstraintKey";
static NSString * const WFLeadingMarginConstraintKey = @"WFLeadingMarginConstraintKey";

static NSString * const WFContentOffset = @"contentOffset";

@interface UIView ()

@property (nonatomic, assign) BOOL isObserverScrollView;

@property (nonatomic, assign) CGFloat originalTopMargin;

@property (nonatomic, assign) CGFloat originalLeadingMargin;

@property (nonatomic, strong) NSLayoutConstraint *topMarginConstraint;

@property (nonatomic, strong) NSLayoutConstraint *leadingMarginConstraint;

@end

@implementation UIView (WFViewFixedInScrollView)

- (void)setIsObserverScrollView:(BOOL)isObserverScrollView
{
    objc_setAssociatedObject(self, &WFIsObserverScrollViewKey, @(isObserverScrollView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isObserverScrollView
{
    return [objc_getAssociatedObject(self, &WFIsObserverScrollViewKey) boolValue];
}

- (void)setOriginalTopMargin:(CGFloat)originalTopMargin
{
    objc_setAssociatedObject(self, &WFOriginalTopMarginKey, @(originalTopMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)originalTopMargin
{
    return [objc_getAssociatedObject(self, &WFOriginalTopMarginKey) floatValue];
}

- (void)setOriginalLeadingMargin:(CGFloat)originalLeadingMargin
{
    objc_setAssociatedObject(self, &WFOriginalLeadingMarginKey, @(originalLeadingMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)originalLeadingMargin
{
    return [objc_getAssociatedObject(self, &WFOriginalLeadingMarginKey) floatValue];
}

- (void)setTopMarginConstraint:(NSLayoutConstraint *)topMarginConstraint
{
    objc_setAssociatedObject(self, &WFTopMarginConstraintKey, topMarginConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)topMarginConstraint
{
    return objc_getAssociatedObject(self, &WFTopMarginConstraintKey);
}

- (void)setLeadingMarginConstraint:(NSLayoutConstraint *)leadingMarginConstraint
{
    objc_setAssociatedObject(self, &WFLeadingMarginConstraintKey, leadingMarginConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)leadingMarginConstraint
{
    return objc_getAssociatedObject(self, &WFLeadingMarginConstraintKey);
}

#pragma mark - internal call

- (void)addObserver
{
    if (!self.isObserverScrollView) {
        [self.superview addObserver:self forKeyPath:WFContentOffset options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        self.isObserverScrollView = YES;
    }
}

- (void)removeObserver
{
    if (self.isObserverScrollView) {
        [self.superview removeObserver:self forKeyPath:WFContentOffset];
        self.isObserverScrollView = NO;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:WFContentOffset]) {
        UIScrollView *scrollView = object;
        self.leadingMarginConstraint.constant = self.originalLeadingMargin + scrollView.contentOffset.x;
        self.topMarginConstraint.constant = self.originalTopMargin + scrollView.contentOffset.y;
    }
}

#pragma mark - external call

- (void)fixInScrollView:(UIScrollView *)scrollView withFrame:(CGRect)frame atIndex:(NSInteger)index
{
    [self removeObserver];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView insertSubview:self atIndex:index];
    
    self.originalLeadingMargin = frame.origin.x;
    self.originalTopMargin = frame.origin.y;
   self.leadingMarginConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeLeading multiplier:1 constant:self.originalLeadingMargin + scrollView.contentOffset.x];
    self.topMarginConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:self.originalTopMargin + scrollView.contentOffset.y];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:frame.size.width];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:frame.size.height];
    
    [scrollView addConstraints:@[self.leadingMarginConstraint, self.topMarginConstraint, width, height]];
    
    [self addObserver];
}

- (void)removeFromScrollViewInFixPosition
{
    [self removeObserver];
    [self removeFromSuperview];
}

@end
