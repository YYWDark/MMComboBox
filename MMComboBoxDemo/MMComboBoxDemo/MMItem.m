//
//  MMItem.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMItem.h"
#import "MMLayout.h"

#import "MMSelectedPath.h"
@implementation MMItem
#pragma mark - init method
- (instancetype)init{
    self = [super init];
    if (self) {
        self.alternativeArray = [NSMutableArray array];
        self.childrenNodes = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title subTileName:(NSString *)subTile{
    MMItem *item = [MMItem itemWithItemType:type titleName:title];
    if (subTile != nil) {
        item.subTitle = subTile;
    }
    
    return item;
}

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title {
    MMItem *item = [[[self class] alloc] init];
    item.markType = type;
    item.title = title;
    
    return item;
}

#pragma mark - public method
- (void)addNode:(MMItem *)node {
    NSParameterAssert(node);
    node.isSelected = (self.childrenNodes.count == 0) ? YES : NO;
    [self.childrenNodes addObject:node];
}

- (void)addNodeWithoutMark:(MMItem *)node {
    NSParameterAssert(node);
    node.isSelected = NO;
    [self.childrenNodes addObject:node];
}



- (void)findTheTypeOfPopUpView {
    if (self.alternativeArray.count) {
        self.displayType = MMPopupViewDisplayTypeFilters;
        self.layout = [MMLayout layoutWithItem:self];
        for (int i = 0; i < self.childrenNodes.count; i++) {
            MMItem *subItem = self.childrenNodes[i];
            subItem.layout = [[MMLayout alloc] init];
            [subItem.layout.cellLayoutTotalInfo addObjectsFromArray:self.layout.cellLayoutTotalInfo[i]];
        }
        return;
    }
    for (MMItem *item in self.childrenNodes) { //目前只支持两层 所以不需要去做递归
        if (item.childrenNodes.count != 0) {
            self.displayType = MMPopupViewDisplayTypeMultilayer;
            return;
        }
    }
}


- (NSString *)findTitleBySelectedPath:(MMSelectedPath *)selectedPath {
    if (selectedPath.secondPath != -1) {
        return [self.childrenNodes[selectedPath.firstPath].childrenNodes[selectedPath.secondPath] title];
    }
    return [self.childrenNodes[selectedPath.firstPath] title];
}
@end
