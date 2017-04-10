//
//  MMCombinationItem.h
//  MMComboBoxDemo
//
//  Created by wyy on 17/4/9.
//  Copyright © 2017年 wyy. All rights reserved.
//

#import "MMItem.h"
#import "MMAlternativeItem.h"
@interface MMCombinationItem : MMItem

@property (nonatomic, assign) BOOL isHasSwitch;                         //是否有Switch类型
@property (nonatomic, strong) NSMutableArray <MMAlternativeItem *>*alternativeArray;         //当有这种的类型则一定为MMPopupViewDisplayTypeFilters类型

- (void)addLayoutInformationWhenTypeFilters;
- (void)addAlternativeItem:(MMAlternativeItem *)item;


@end
