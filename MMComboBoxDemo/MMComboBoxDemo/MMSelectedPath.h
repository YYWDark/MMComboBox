//
//  MMSelectedPath.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/13.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSelectedPath : NSObject
@property (nonatomic, assign) NSInteger firstPath;
@property (nonatomic, assign) NSInteger secondPath;         //default is -1.

+ (instancetype)pathWithFirstPath:(NSInteger)firstPath secondPath:(NSInteger)firstPath;
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath;
@end
