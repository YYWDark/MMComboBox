//
//  MMAlternativeItem.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMAlternativeItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelected;

+ (instancetype)itemWithTitle:(NSString *)title isSelected:(BOOL)isSelected;
@end
