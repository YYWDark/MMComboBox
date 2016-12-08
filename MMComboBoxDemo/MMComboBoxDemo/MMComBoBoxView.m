//
//  MMComBoBoxView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMComBoBoxView.h"
#import "MMDropDownBox.h"
#import "MMHeader.h"
#import "MMBasePopupView.h"

@interface MMComBoBoxView () <MMDropDownBoxDelegate>
//@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *dropDownBoxArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation MMComBoBoxView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dropDownBoxArray = [NSMutableArray array];
        self.itemArray = [NSMutableArray array];
        self.backgroundColor = [UIColor greenColor];
        
    }
    return self;
}

- (void)reload {
    NSUInteger count = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsIncomBoBoxView:)]) {
      count = [self.dataSource numberOfColumnsIncomBoBoxView:self];
    }
    
    CGFloat width = self.width/4;
    if ([self.dataSource respondsToSelector:@selector(comBoBoxView:infomationForColumn:)]) {
        for (NSUInteger i = 0; i < count; i ++) {
            MMItem *item = [self.dataSource comBoBoxView:self infomationForColumn:i];
            
            MMDropDownBox *dropBox = [[MMDropDownBox alloc] initWithFrame:CGRectMake(i*width, 0, width, self.height) titleName:item.title];
            dropBox.tag = i;
            dropBox.delegate = self;
            [self addSubview:dropBox];
            [self.dropDownBoxArray addObject:dropBox];
            [self.itemArray addObject:item];
        }
    }
}

#pragma mark - MMDropDownBoxDelegate
- (void)didTapDropDownBox:(MMDropDownBox *)dropDownBox atIndex:(NSUInteger)index{
    MMItem *item = self.itemArray[index];
    MMBasePopupView *popupView = [MMBasePopupView getSubPopupView:item];
    
//    [popupView popupViewWithItem:item sourceFrame:self.frame];
    [popupView popupViewFromSourceFrame:self.frame];
}
@end
