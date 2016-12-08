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

@interface MMComBoBoxView : UIView
@property (nonatomic, weak) id<MMComBoBoxViewDataSource> dataSource;

//- (id)initWithFrame:(CGRect)frame sourceData:(NSArray *)data;
- (void)reload;
@end

@protocol MMComBoBoxViewDataSource <NSObject>
@required;
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView;
- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column;
@end
