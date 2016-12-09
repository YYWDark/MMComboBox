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
        
        self.childrenNodes = [NSMutableArray array];
    }
    return self;
}

- (void)addNode:(MMItem *)node {
    NSParameterAssert(node);
    node.isSelected = (self.childrenNodes.count == 0) ? YES : NO;
    [self.childrenNodes addObject:node];
}

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title{
    MMItem *item = [[[self class] alloc] init];
    item.markType = type;
    item.title = title;
    return item;
}

- (void)findTheTypeOfPopUpView{

    for (MMItem *item in self.childrenNodes) { //目前只支持两层 所以不需要去做递归
        if (item.childrenNodes.count != 0) {
            if (self.AlternativeArray.count == 0) {
              self.displayType = MMPopupViewDisplayTypeMultilayer;
            }else{
              self.displayType = MMPopupViewDisplayTypeFilters;
            }
            return;
        }
    }
}
@end
