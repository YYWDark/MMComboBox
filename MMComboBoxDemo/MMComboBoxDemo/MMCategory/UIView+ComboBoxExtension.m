//
//  UIView+Extension.m
//  UIFiterDemo
//
//  Created by wyy on 16/10/12.
//  Copyright © 2016年 yyx. All rights reserved.
//

#import "UIView+ComboBoxExtension.h"

@implementation UIView (Extension)
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setOffsetX:(CGFloat)offsetX {
    self.frame = CGRectOffset(self.frame, offsetX, 0);
}

- (CGFloat)offsetX {
    return 0;
}

- (void)setOffsetY:(CGFloat)offsetY {
    self.frame = CGRectOffset(self.frame, 0, offsetY);
}

- (CGFloat)offsetY {
    return 0;
}

- (void)setSize:(CGSize)size {
    self.frame = CGRectMake(self.left, self.top, size.width, size.height);
}

- (CGSize)size {
    return self.frame.size;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

-(CGFloat) centerX {
    return self.center.x;
}

-(void)setCenterX:(CGFloat)centerX {
    self.center=CGPointMake(centerX, self.centerY);
}

-(CGFloat) centerY {
    return self.center.y;
}

-(void)setCenterY:(CGFloat)centerY {
    self.center=CGPointMake(self.centerX,centerY);
}

@end
