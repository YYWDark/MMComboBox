//
//  MMLayout.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/15.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMLayout.h"


@implementation MMLayout
- (instancetype)init{
    self = [super init];
    if (self) {
        self.cellLayoutInfo = [NSMutableArray array];
        [self _initUI];
    }
    return self;
}

- (void)_initUI {
    
}

+ (instancetype)layoutWithItem:(MMItem *)item{
    MMLayout *layout = [[MMLayout alloc] init];
    layout.headerHeight = item.alternativeArray.count * (2*AlternativeTitleVerticalMargin + AlternativeTitleHeight);
    for (MMItem *subItem in item.childrenNodes) {
        CGFloat totalCellHeight = 2*TitleVerticalMargin + ItemHeight;
        NSInteger rowNumber =  (kScreenWidth - 2*ItemHorizontalMargin)/(ItemWidth + ItemHorizontalDistance);
        NSInteger columnNumber = MAX(1,subItem.childrenNodes.count / rowNumber + ((subItem.childrenNodes.count % rowNumber)?0:1));
        totalCellHeight += columnNumber*(ItemHeight + TitleVerticalMargin);
        [layout.cellLayoutInfo addObject:@(totalCellHeight)];
    }
    return  layout;
}

@end
