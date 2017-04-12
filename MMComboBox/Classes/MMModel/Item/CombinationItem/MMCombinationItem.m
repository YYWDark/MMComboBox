//
//  MMCombinationItem.m
//  MMComboBoxDemo
//
//  Created by wyy on 17/4/9.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMCombinationItem.h"

@implementation MMCombinationItem
- (void)addAlternativeItem:(MMAlternativeItem *)item {
    [self.alternativeArray addObject:item];
}

- (void)addLayoutInformationWhenTypeFilters {
    if (self.displayType != MMPopupViewDisplayTypeFilters)  return;
    self.combinationLayout = [MMLayout layoutWithItem:self];
    for (int i = 0; i < self.childrenNodes.count; i++) {
        MMCombinationItem *subItem = (MMCombinationItem *)self.childrenNodes[i];
        subItem.combinationLayout = [[MMLayout alloc] init];
        [subItem.combinationLayout.cellLayoutTotalInfo addObjectsFromArray:self.combinationLayout.cellLayoutTotalInfo[i]];
    }
}

- (BOOL)isHasSwitch {
    return (self.alternativeArray.count != 0);
}

- (NSMutableArray *)alternativeArray {
    if (_alternativeArray == nil) {
        _alternativeArray = [NSMutableArray array];
    }
    return _alternativeArray;
}
@end
