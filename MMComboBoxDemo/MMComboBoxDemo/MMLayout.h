//
//  MMLayout.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/15.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMItem.h"
#import "MMHeader.h"

@interface MMLayout : NSObject
@property (nonatomic, assign) NSInteger headerHeight;
@property (nonatomic, assign) NSInteger alternativeTitleHeight;
@property (nonatomic, assign) NSInteger titleHeight;

@property (nonatomic, strong) NSMutableArray *cellLayoutInfo;

+ (instancetype)layoutWithItem:(MMItem *)item;
@end
