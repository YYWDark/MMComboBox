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
#import "MMHeader.h"
@interface MMBasePopupView ()

@end
@implementation MMBasePopupView
- (instancetype)init{
    self = [super init];
    if (self) {
        self.shadowView = [[UIView alloc] init];
        self.shadowView.backgroundColor = [UIColor colorWithHexString:@"484848"];
    }
    return self;
}


+ (MMBasePopupView *)getSubPopupView:(MMItem *)item{
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

- (void)dismiss{
    
}


@end
