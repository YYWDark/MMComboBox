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
@interface MMBasePopupView ()

@end
@implementation MMBasePopupView

+ (MMBasePopupView *)getSubPopupView:(MMItem *)item{
    MMBasePopupView *view;
    switch (item.displayType) {
        case MMPopupViewDisplayTypeNormal:
            view =  [[MMSingleFitlerView alloc] init];
            break;
        case MMPopupViewDisplayTypeMultilayer:
             view =  [[MMMultiFitlerView alloc] init];
            break;
        case MMPopupViewDisplayTypeFilters:
            view =  [[MMCombinationFitlerView alloc] init];
            break;
        default:
            break;
    }
    view.item = item;
    return view;
}

- (void)dismiss{
    
}
@end
