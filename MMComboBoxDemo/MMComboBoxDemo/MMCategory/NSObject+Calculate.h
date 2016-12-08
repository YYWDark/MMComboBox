//
//  NSObject+Calculate.h
//  DMSPopupView
//
//  Created by wyy on 16/8/15.
//  Copyright © 2016年 yyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (Calculate)
+ (CGFloat)heightFromString:(NSString*)text withFont:(UIFont*)font constraintToWidth:(CGFloat)width;
+ (CGFloat)widthFromString:(NSString*)text  withFont:(UIFont*)font constraintToHeight:(CGFloat)height;
@end
