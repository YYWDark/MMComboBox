//
//  MMComBoBoxView.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMItem.h"

@protocol MMComBoBoxViewDataSource;
@protocol MMComBoBoxViewDelegate;
@interface MMComBoBoxView : UIView
@property (nonatomic, weak) id<MMComBoBoxViewDataSource> dataSource;
@property (nonatomic, weak) id<MMComBoBoxViewDelegate> delegate;
- (void)reload;
- (void)dimissPopView;
@end

@protocol MMComBoBoxViewDataSource <NSObject>
@required;
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView;
- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column;
@end

@protocol MMComBoBoxViewDelegate <NSObject>
@optional
- (void)comBoBoxView:(MMComBoBoxView *)comBoBoxViewd didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index;
@end
