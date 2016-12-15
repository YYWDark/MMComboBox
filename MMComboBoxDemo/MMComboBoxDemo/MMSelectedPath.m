//
//  MMSelectedPath.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/13.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMSelectedPath.h"
@interface MMSelectedPath () <NSCopying>
@end

@implementation MMSelectedPath 
- (instancetype)init{
    self = [super init];
    if (self) {
        self.secondPath = -1;
    }
    return self;
}

+ (instancetype)pathWithFirstPath:(NSInteger)firstPath secondPath:(NSInteger)secondPath{
    MMSelectedPath *path = [MMSelectedPath pathWithFirstPath:firstPath];
    path.secondPath = secondPath;
    return path;
}

+ (instancetype)pathWithFirstPath:(NSInteger)firstPath {
    MMSelectedPath *path = [[[self class] alloc] init];
    path.firstPath = firstPath;
    return path;
}

- (id)copyWithZone:(nullable NSZone *)zone{
    return [MMSelectedPath pathWithFirstPath:self.firstPath secondPath:self.secondPath];
}
@end
