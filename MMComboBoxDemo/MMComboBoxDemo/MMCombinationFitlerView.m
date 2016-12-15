//
//  MMCombinationFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMCombinationFitlerView.h"

@implementation MMCombinationFitlerView

- (id)initWithItem:(MMItem *)item{
    self = [super init];
    if (self) {
        self.item = item;
        self.selectedArray = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
