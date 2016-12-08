//
//  MMSingleFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMSingleFitlerView.h"
#import "MMHeader.h"
@implementation MMSingleFitlerView
- (id)initWithItem:(MMItem *)item{
    if (self) {
        self.item = item;
    }
    return self;
}
- (void)popupViewFromSourceFrame:(CGRect)frame{
    NSLog(@"%@",self.item);
//    self.sourceFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
}

@end
