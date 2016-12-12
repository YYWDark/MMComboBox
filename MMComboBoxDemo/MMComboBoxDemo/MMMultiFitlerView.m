//
//  MMMultiFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMMultiFitlerView.h"

@implementation MMMultiFitlerView
- (id)initWithItem:(MMItem *)item{
    self = [super init];
    if (self) {
        self.item = item;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)popupViewFromSourceFrame:(CGRect)frame {
    
}

- (void)dismiss{
    
}
@end
