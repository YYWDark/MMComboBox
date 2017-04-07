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
- (instancetype)init {
    self = [super init];
    if (self) {
        self.secondPath = -1;
        self.isKindOfAlternative = NO;
    }
    return self;
}

+ (instancetype)pathWithFirstPath:(NSInteger)firstPath secondPath:(NSInteger)secondPath {
    return [MMSelectedPath pathWithFirstPath:firstPath
                                  secondPath:secondPath
                         isKindOfAlternative:NO
                                        isOn:NO];
}

+ (instancetype)pathWithFirstPath:(NSInteger)firstPath {
    return [MMSelectedPath pathWithFirstPath:firstPath
                                  secondPath:-1
                         isKindOfAlternative:NO
                                        isOn:NO];
}

+ (instancetype)pathWithFirstPath:(NSInteger)firstPath isOn:(BOOL)isOn {
    return [MMSelectedPath pathWithFirstPath:firstPath
                                  secondPath:-1
                         isKindOfAlternative:YES
                                        isOn:isOn];
}

+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                       secondPath:(NSInteger)secondPath
              isKindOfAlternative:(BOOL)isKindOfAlternative
                             isOn:(BOOL)isOn {
    MMSelectedPath *path = [[[self class] alloc] init];
    path.firstPath = firstPath;
    path.secondPath = secondPath;
    path.isKindOfAlternative = isKindOfAlternative;
    path.isOn = isOn;
    return path;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    MMSelectedPath *path = [MMSelectedPath pathWithFirstPath:self.firstPath
                                                  secondPath:self.secondPath
                                         isKindOfAlternative:self.isKindOfAlternative
                                                        isOn:self.isOn];
    return path;
}
@end
