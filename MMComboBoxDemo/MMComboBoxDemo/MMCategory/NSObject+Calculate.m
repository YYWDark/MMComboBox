//
//  NSObject+Calculate.m
//  DMSPopupView
//
//  Created by wyy on 16/8/15.
//  Copyright © 2016年 yyx. All rights reserved.
//

#import "NSObject+Calculate.h"


@implementation NSObject (Calculate)
+ (CGFloat)heightFromString:(NSString*)text withFont:(UIFont*)font constraintToWidth:(CGFloat)width
{
    CGRect rect;
    
    float iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (iosVersion >= 7.0) {
        rect = [text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    }else {
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        rect = CGRectMake(0, 0, size.width, size.height);
    }
    return rect.size.height;
}

+ (CGFloat)widthFromString:(NSString*)text withFont:(UIFont*)font constraintToHeight:(CGFloat)height
{
    CGRect rect;
    
    float iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (iosVersion >= 7.0) {
        rect = [text boundingRectWithSize:CGSizeMake(1000, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    }else {
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(1000, height) lineBreakMode:NSLineBreakByWordWrapping];
        rect = CGRectMake(0, 0, size.width, size.height);
    }
    return rect.size.width ;
}
@end
