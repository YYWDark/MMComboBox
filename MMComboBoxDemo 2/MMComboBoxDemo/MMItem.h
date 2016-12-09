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
@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, strong) NSMutableArray *alternativeArray;

@end
