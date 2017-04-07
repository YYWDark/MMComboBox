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

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type
                       titleName:(NSString *)title
                     subTileName:(NSString *)subTile{
    return [MMItem itemWithItemType:type
                         isSelected:NO
                          titleName:title
                       subtitleName:subTile
                               code:nil];
}

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type
                       titleName:(NSString *)title {
    return [MMItem itemWithItemType:type
                         isSelected:NO
                          titleName:title
                       subtitleName:nil
                               code:nil];
}

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type
                      isSelected:(BOOL)isSelected
                       titleName:(NSString *)title
                     subTileName:(NSString *)subTile {
    return [MMItem itemWithItemType:type
                         isSelected:isSelected
                          titleName:title
                       subtitleName:subTile
                               code:nil];
}

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type
                      isSelected:(BOOL)isSelected
                       titleName:(NSString *)title
                    subtitleName:(NSString *)subtitle
                            code:(NSString *)code {
    MMItem *item = [[[self class] alloc] init];
    item.markType = type;
    item.isSelected = isSelected;
    item.title = title;
    item.subTitle = subtitle;
    item.code = code;
    return item;
}

#pragma mark - public method
- (void)addNode:(MMItem *)node {
    NSParameterAssert(node);
    [self.childrenNodes addObject:node];
}



- (void)addLayoutInformationWhenTypeFilters {
   if (self.displayType != MMPopupViewDisplayTypeFilters)  return;
    
   self.layout = [MMLayout layoutWithItem:self];
   for (int i = 0; i < self.childrenNodes.count; i++) {
            MMItem *subItem = self.childrenNodes[i];
            subItem.layout = [[MMLayout alloc] init];
            [subItem.layout.cellLayoutTotalInfo addObjectsFromArray:self.layout.cellLayoutTotalInfo[i]];
    }
    
}


- (NSString *)findTitleBySelectedPath:(MMSelectedPath *)selectedPath {
    if (selectedPath.secondPath != -1) {
        return [self.childrenNodes[selectedPath.firstPath].childrenNodes[selectedPath.secondPath] title];
    }
    return [self.childrenNodes[selectedPath.firstPath] title];
}


- (BOOL)isHasSwitch {
    return (self.alternativeArray.count != 0);
}
@end
