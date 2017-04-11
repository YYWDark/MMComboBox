//
//  MMItem.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMItem.h"
@implementation MMItem
#pragma mark - init method
- (instancetype)init{
    self = [super init];
    if (self) {
        self.displayType = MMPopupViewDisplayTypeNormal;
        self.childrenNodes = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type
                       titleName:(NSString *)title
                     subTileName:(NSString *)subTile{
    return [self itemWithItemType:type
                         isSelected:NO
                          titleName:title
                       subtitleName:subTile
                               code:nil];
}

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type
                       titleName:(NSString *)title {
    return [self itemWithItemType:type
                         isSelected:NO
                          titleName:title
                       subtitleName:nil
                               code:nil];
}

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type
                      isSelected:(BOOL)isSelected
                       titleName:(NSString *)title
                     subtitleName:(NSString *)subTile {
    return [self itemWithItemType:type
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

- (instancetype)initWithType:(MMPopupViewMarkType)type
                  isSelected:(BOOL)isSelected
                   titleName:(NSString *)title
                subtitleName:(NSString *)subtitle
                        code:(NSString *)code {
    self = [self init];
    if (self) {
        self.markType = type;
        self.isSelected = isSelected;
        self.title = title;
        self.subTitle = subtitle;
        self.code = code;
    }
    return self;
}

#pragma mark - public method
- (void)addNode:(MMItem *)node {
    NSParameterAssert(node);
    [self.childrenNodes addObject:node];
}

- (NSString *)findTitleBySelectedPath:(MMSelectedPath *)selectedPath {
    if (selectedPath.thirdPath != -1) {
        return self.childrenNodes[selectedPath.firstPath].childrenNodes[selectedPath.secondPath].childrenNodes[selectedPath.thirdPath].title;
    }
    if (selectedPath.secondPath != -1) {
        return [self.childrenNodes[selectedPath.firstPath].childrenNodes[selectedPath.secondPath] title];
    }
    return [self.childrenNodes[selectedPath.firstPath] title];
}

@end
