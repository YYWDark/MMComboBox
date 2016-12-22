//
//  MMItem.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMBaseItem.h"
@class MMSelectedPath;
@class MMLayout;
#import "MMLayout.h"
@interface MMItem : MMBaseItem
@property (nonatomic, copy) NSString *code;                             //支持有的需要上传code而不是title
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray <MMItem *> *childrenNodes;     
@property (nonatomic, strong) NSMutableArray *alternativeArray;         //当有这种的类型则一定为MMPopupViewDisplayTypeFilters类型
@property (nonatomic, assign) BOOL isSelected;                          //默认0
@property (nonatomic, strong) NSString *subTitle;                       //第一层默认没有
@property (nonatomic, strong) MMLayout *layout;

- (void)addNode:(MMItem *)node;
- (void)addNodeWithoutMark:(MMItem *)node;
- (void)findTheTypeOfPopUpView;
- (NSString *)findTitleBySelectedPath:(MMSelectedPath *)selectedPath;
+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title;
+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title subTileName:(NSString *)subTile;
@end
