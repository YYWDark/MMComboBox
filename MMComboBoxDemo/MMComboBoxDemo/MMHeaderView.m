//
//  MMHeaderView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/19.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMHeaderView.h"
#import "MMAlternativeItem.h"
#import "MMComboBoxHeader.h"

@interface MMHeaderView ()
@end

@implementation MMHeaderView
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setItem:(MMCombinationItem *)item {
    _item = item;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < _item.alternativeArray.count; i++) {
        MMAlternativeItem *alternativeItem = _item.alternativeArray[i];
        CGFloat orginY =  (2*AlternativeTitleVerticalMargin +AlternativeTitleHeight);
        UISwitch *switchControl = [[UISwitch alloc] init];
        switchControl.frame = CGRectMake(self.width - 51 - ItemHorizontalMargin ,  AlternativeTitleVerticalMargin + orginY*i, 51, AlternativeTitleHeight);
        switchControl.tag= i;
        [switchControl setOn:alternativeItem.isSelected animated:NO];
        [switchControl addTarget:self action:@selector(respondsToSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:switchControl];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = alternativeItem.title;
        titleLabel.frame = CGRectMake(ItemHorizontalMargin, switchControl.top, 100, AlternativeTitleHeight);
        titleLabel.font = [UIFont systemFontOfSize:ButtonFontSize];
        [self addSubview:titleLabel];
        
        CALayer *bottomLine = [CALayer layer];
        bottomLine.frame = CGRectMake(0, orginY*(i+1) - 1.0/scale, self.width, 1.0/scale);
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"].CGColor;
        [self.layer addSublayer:bottomLine];
    }
}

- (void)respondsToSwitchAction:(UISwitch *)sender {
    if ([self.delegate respondsToSelector:@selector(headerView:didSelectedAtIndex:currentState:)]) {
        [self.delegate headerView:self didSelectedAtIndex:sender.tag currentState:sender.isOn];
    }
}
@end
