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
@property (nonatomic, assign) NSInteger thirdPath;          //default is -1.

@property (nonatomic, assign) BOOL isKindOfAlternative;     // YES when is MMAlternativeItem,default is NO
@property (nonatomic, assign) BOOL isOn;                    //when is Switch,it is useful;
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath;
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                       secondPath:(NSInteger)secondPath;
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                       secondPath:(NSInteger)secondPath
                        thirdPath:(NSInteger)thirdPath;

//提供给有复合类型的构造方法
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                             isOn:(BOOL)isOn;
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                       secondPath:(NSInteger)secondPath
              isKindOfAlternative:(BOOL)isKindOfAlternative
                             isOn:(BOOL)isOn;

+ (instancetype)pathWithFirstPath:(NSInteger)firstPath
                       secondPath:(NSInteger)secondPath
                        thirdPath:(NSInteger)thirdPath
              isKindOfAlternative:(BOOL)isKindOfAlternative
                             isOn:(BOOL)isOn;

- (void)resetFirstPath:(NSInteger)firstPath;
@end
