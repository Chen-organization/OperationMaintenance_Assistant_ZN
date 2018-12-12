//
//  UIView+FP.m
//  PogoShow
//
//  Created by 付付 on 15/9/7.
//  Copyright (c) 2015年 PogoShow. All rights reserved.
//

#import "UIView+FP.h"

@implementation UIView (FP)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}


 //获取当前屏幕显示的viewcontroller
 + (UIViewController *)getCurrentVC {
     UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
         // modal展现方式的底层视图不同
         // 取到第一层时，取到的是UITransitionView，通过这个view拿不到控制器
         UIView *firstView = [keyWindow.subviews firstObject];
         UIView *secondView = [firstView.subviews firstObject];
         UIViewController *vc = secondView.parentController;
         if ([vc isKindOfClass:[UITabBarController class]]) {
             UITabBarController *tab = (UITabBarController *)vc;
             if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
                 UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
                 return [nav.viewControllers lastObject];
             } else {
                 return tab.selectedViewController;
             }
         } else if ([vc isKindOfClass:[UINavigationController class]]) {
             UINavigationController *nav = (UINavigationController *)vc;
             return [nav.viewControllers lastObject];
         } else {
             return vc;
         }
         return nil;
     }

- (UIViewController *)parentController
{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end
