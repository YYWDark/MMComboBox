//
//  MMAlternativeItem.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMAlternativeItem.h"

@implementation MMAlternativeItem
+ (instancetype)itemWithTitle:(NSString *)title isSelected:(BOOL)isSelected {
    MMAlternativeItem *item = [[[self class] alloc] init];
    item.title = title;
    item.isSelected = isSelected;
    return item;
}
@end
