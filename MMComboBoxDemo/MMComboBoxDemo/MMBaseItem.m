//
//  MMBaseItem.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMBaseItem.h"

@implementation MMBaseItem
- (instancetype)init {
    self = [super init];
    if (self) {
        self.displayType = MMPopupViewDisplayTypeNormal;
    }
    return self;
}
@end
