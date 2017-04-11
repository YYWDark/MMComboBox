//
//  MMItem.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSelectedPath.h"
#import "MMLayout.h"

//这个字段我们暂时留着以后扩展，覆盖可能要有些选项不能选择，显示灰色的情况
typedef NS_ENUM(NSUInteger, MMPopupViewMarkType) {  //选中的状态
    MMPopupViewDisplayTypeSelected = 0,      //可以选中
    MMPopupViewDisplayTypeUnselected = 1,    //不可以选中
};

typedef NS_ENUM(NSUInteger, MMPopupViewSelectedType) {     //是否支持单选或者多选
    MMPopupViewSingleSelection,                            //单选
    MMPopupViewMultilSeMultiSelection,                    //多选
};

typedef NS_ENUM(NSUInteger, MMPopupViewDisplayType) {  //分辨弹出来的view类型
    MMPopupViewDisplayTypeNormal = 0,                //一层
    MMPopupViewDisplayTypeMultilayer = 1,            //多层
    MMPopupViewDisplayTypeFilters = 2,               //混合
};

@interface MMItem : NSObject
@property (nonatomic, assign) MMPopupViewMarkType markType;
@property (nonatomic, assign) MMPopupViewDisplayType displayType;
@property (nonatomic, assign) MMPopupViewSelectedType selectedType;

@property (nonatomic, assign) BOOL isSelected;                          //默认0 只有根这个属性没有意义
@property (nonatomic, copy) NSString *code;                             //支持有的需要上传code而不是title
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray <MMItem *>*childrenNodes;
@property (nonatomic, strong) NSString *subTitle;                       //第一层默认没有

@property (nonatomic, strong) MMLayout *combinationLayout;       

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type
                       titleName:(NSString *)title;

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type
                       titleName:(NSString *)title
                     subTileName:(NSString *)subTile;

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type
                      isSelected:(BOOL)isSelected
                       titleName:(NSString *)title
                     subtitleName:(NSString *)subTile;

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type
                      isSelected:(BOOL)isSelected
                       titleName:(NSString *)title
                    subtitleName:(NSString *)subtitle
                            code:(NSString *)code;

- (void)addNode:(MMItem *)node;
- (NSString *)findTitleBySelectedPath:(MMSelectedPath *)selectedPath;

@end


