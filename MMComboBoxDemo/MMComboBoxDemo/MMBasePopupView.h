//
//  MMBasePopupView.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMSingleFitlerView;
@class MMMultiFitlerView;
@class MMCombinationFitlerView;
#import "MMItem.h"
@interface MMBasePopupView : UIView
@property (nonatomic, strong) MMItem *item;
@property (nonatomic, assign) CGRect *sourceFrame;

- (void)popupViewWithItem:(MMItem *)item;
+ (MMBasePopupView *)getSubPopupView:(MMItem *)item;
- (void)popupViewFromSourceFrame:(CGRect)frame;
@end
