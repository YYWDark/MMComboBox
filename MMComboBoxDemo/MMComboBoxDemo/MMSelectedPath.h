//
//  MMSelectedPath.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/13.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSelectedPath : NSObject
@property (nonatomic, assign) NSInteger firstPath;          //
@property (nonatomic, assign) NSInteger secondPath;         //default is -1.
@property (nonatomic, assign) BOOL isKindOfAlternative;     //Switch is YES ,default is NO
@property (nonatomic, assign) BOOL isOn;                    //when is Switch,it is useful;
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath secondPath:(NSInteger)firstPath;
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath;
+ (instancetype)pathWithFirstPath:(NSInteger)firstPath isKindOfAlternative:(BOOL)isKindOfAlternative isOn:(BOOL)isOn;
@end
