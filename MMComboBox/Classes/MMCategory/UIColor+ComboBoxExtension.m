//
//  UIColor+Extension.m
//  UIFiterDemo
//
//  Created by wyy on 16/10/11.
//  Copyright © 2016年 yyx. All rights reserved.
//

#import "UIColor+ComboBoxExtension.h"

@implementation UIColor (Extension)
+(UIColor *)colorWithHexString:(NSString*)hexString {
    NSString *valueString = hexString;
    valueString = [valueString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([valueString hasPrefix:@"0x"]){
        valueString = [hexString substringFromIndex:2];
    }
    if (valueString.length != 8 && valueString.length != 6){
        return nil;
    }
    
    unsigned color = 0;
    unsigned alpha = 255;
    if (valueString.length == 6){
        NSScanner *scanner = [NSScanner scannerWithString:valueString];
        [scanner scanHexInt:&color];
    }else{
        NSScanner *scanner = [NSScanner scannerWithString:[valueString substringToIndex:6]];
        [scanner scanHexInt:&color];
        scanner = [NSScanner scannerWithString:[valueString substringFromIndex:6]];
        [scanner scanHexInt:&alpha];
    }
    
    return [UIColor colorWithHex:color alpha:alpha/255.0f];
}

+(UIColor *)colorWithHex:(NSUInteger)color alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((color & 0xff0000) >> 16) / 255.0f
                           green:((color & 0xff00) >> 8) / 255.0f
                            blue:(color & 0xff) / 255.0f
                           alpha:alpha];
}

+ (UIColor *)randomColor {
    CGFloat red = random()%255/255.0;
    CGFloat green = random()%255/255.0;
    CGFloat blue = random()%255/255.0;
   return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}
@end
