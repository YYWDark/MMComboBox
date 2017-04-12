//
//  MMBasePopupView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMBasePopupView.h"
#import "MMSingleFitlerView.h"
#import "MMMultiFitlerView.h"
#import "MMCombinationFitlerView.h"
#import "MMComboBoxHeader.h"
#import "MMItem.h"
@interface MMBasePopupView ()

@end
@implementation MMBasePopupView
- (id)initWithItem:(MMItem *)item {
    self = [self init];
    if (self) {
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shadowView = [[UIView alloc] init];
        self.shadowView.backgroundColor = [UIColor colorWithHexString:@"484848"];
        self.selectedArray = [NSMutableArray array];
        self.temporaryArray = [NSMutableArray array];
    }
    return self;
}

+ (MMBasePopupView *)getSubPopupView:(MMItem *)item {
    MMBasePopupView *view;
    switch (item.displayType) {
        case MMPopupViewDisplayTypeNormal:
            view =  [[MMSingleFitlerView alloc] initWithItem:item];
            break;
        case MMPopupViewDisplayTypeMultilayer:
             view =  [[MMMultiFitlerView alloc] initWithItem:item];
            break;
        case MMPopupViewDisplayTypeFilters:
            view =  [[MMCombinationFitlerView alloc] initWithItem:item];
            break;
        default:
            break;
    }
    return view;
}

- (void)dismiss {
    if (self.superview) {
        [self.shadowView removeFromSuperview];
    }
}

- (void)dismissWithOutAnimation {
    if (self.superview) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }
}

- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^)(void))completion {
  //写这些方法是为了消除警告；
}


@end
