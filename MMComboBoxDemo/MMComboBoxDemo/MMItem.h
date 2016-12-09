//
//  MMItem.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMBaseItem.h"

@interface MMItem : MMBaseItem
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, strong) NSMutableArray <MMItem *> *childrenNodes;     //储存 MMItem
@property (nonatomic, strong) NSMutableArray *AlternativeArray;      //当有这种的类型则一定为MMPopupViewDisplayTypeFilters类型

@property (nonatomic, assign) Boolean isSelected; //默认0
@property (nonatomic, strong) NSString * subTitle;               //第一层默认没有

- (void)addNode:(MMItem *)node ;
- (void)findTheTypeOfPopUpView;
+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title;
@end
