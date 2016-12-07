//
//  MMBaseItem.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, MMPopupViewDisplayType) {
    MMPopupViewDisplayTypeNormal = 0,      
    MMPopupViewDisplayTypeMultilayer = 1,
    MMPopupViewDisplayTypeFilters = 2,
};

@interface MMBaseItem : NSObject
@property (nonatomic, assign) MMPopupViewDisplayType *displayType;
@end
