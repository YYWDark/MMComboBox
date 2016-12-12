//
//  MMBaseItem.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, MMPopupViewMarkType) {  //选中的状态
    MMPopupViewDisplayTypeSelected = 0,      //可以选中
    MMPopupViewDisplayTypeUnselected = 1,    //不可以选中
//    MMPopupViewDisplayTypeFilters = 2,
};

typedef NS_ENUM(NSUInteger, MMPopupViewSelectedType) {     //是否支持单选或者多选
    MMPopupViewSingleSelection,                            //单选
    MMPopupViewMultilSeMultiSelection,                    //多选
};

typedef NS_ENUM(NSUInteger, MMPopupViewDisplayType) {  //分辨弹出来的view类型
    MMPopupViewDisplayTypeNormal = 0,                //一层
    MMPopupViewDisplayTypeMultilayer = 1,            //两层
    MMPopupViewDisplayTypeFilters = 2,               //混合
};

@interface MMBaseItem : NSObject
@property (nonatomic, assign) MMPopupViewMarkType markType;
@property (nonatomic, assign) MMPopupViewDisplayType displayType;
@property (nonatomic, assign) MMPopupViewSelectedType selectedType;
@end
