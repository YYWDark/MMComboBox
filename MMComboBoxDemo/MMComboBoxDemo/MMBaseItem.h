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

typedef NS_ENUM(NSUInteger, MMPopupViewDisplayType) {  //分辨弹出来的view类型
    MMPopupViewDisplayTypeNormal = 0,
    MMPopupViewDisplayTypeMultilayer = 1,
    MMPopupViewDisplayTypeFilters = 2,
};

@interface MMBaseItem : NSObject
@property (nonatomic, assign) MMPopupViewMarkType markType;
@property (nonatomic, assign) MMPopupViewDisplayType displayType;
@end
