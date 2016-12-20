//
//  MMBasePopupView.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMItem.h"

@class MMSingleFitlerView;
@class MMMultiFitlerView;
@class MMCombinationFitlerView;

@protocol MMPopupViewDelegate;
@interface MMBasePopupView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) MMItem *item;
@property (nonatomic, assign) CGRect sourceFrame;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UITableView *subTableView;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSArray *temporaryArray;


@property (nonatomic, weak) id<MMPopupViewDelegate> delegate;

+ (MMBasePopupView *)getSubPopupView:(MMItem *)item;
- (id)initWithItem:(MMItem *)item;

- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion;
- (void)dismiss;
@end

@protocol MMPopupViewDelegate <NSObject>
@optional
- (void)popupView:(MMBasePopupView *)popupView didSelectedItemsPackagingInDictionary:(NSDictionary*)dictionary atIndex:(NSUInteger)index;
- (void)popupView:(MMBasePopupView *)popupView didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index;
@required
- (void)popupViewWillDismiss:(MMBasePopupView *)popupView;
@end
