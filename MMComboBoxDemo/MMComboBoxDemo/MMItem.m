//
//  MMItem.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMItem.h"

@implementation MMItem
- (instancetype)init{
    self = [super init];
    if (self) {
        self.alternativeArray = [NSMutableArray array];
    }
    return self;
}
@end
