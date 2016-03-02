//
//  UIView+WFViewFixedInScrollView.h
//  WFViewFixedInScrollView
//
//  Created by feiwu on 16/3/2.
//  Copyright © 2016年 zzu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WFViewFixedInScrollView)

/** add view to scrollView in fixed position, frame will be translated to auto layout */
- (void)fixInScrollView:(UIScrollView *)scrollView withFrame:(CGRect)frame atIndex:(NSInteger)index;

/** must use this func to remove from superview */
- (void)removeFromScrollViewInFixedPosition;

@end
