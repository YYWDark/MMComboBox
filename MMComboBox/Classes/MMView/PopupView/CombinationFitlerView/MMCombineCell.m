//
//  MMCombineCell.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/19.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMCombineCell.h"

@interface MMCombineCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *btnArray;
@end

@implementation MMCombineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setItem:(MMItem *)item {
    _item = item;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.titleLabel.text = item.title;
    if (self.titleLabel.superview == nil) {
        [self addSubview:self.titleLabel];
    }
    for (int i = 0; i < item.childrenNodes.count; i ++) {
        MMItem *subItem = item.childrenNodes[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat orginX = [item.combinationLayout.cellLayoutTotalInfo[i][0] floatValue];
        CGFloat orginy = [item.combinationLayout.cellLayoutTotalInfo[i][1] floatValue];
        button.frame = CGRectMake(orginX, orginy, ItemWidth, ItemHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:ButtonFontSize];
        button.layer.borderWidth = 1.0/scale;
        button.tag = i;
        button.layer.borderColor = [UIColor colorWithHexString:@"e8e8e8"].CGColor;
        [button setTitle:subItem.title forState:UIControlStateNormal];
        [button setTitleColor:subItem.isSelected?[UIColor whiteColor]:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = subItem.isSelected?[UIColor colorWithHexString:titleSelectedColor]:[UIColor whiteColor];
        [button addTarget:self action:@selector(respondsToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    //layout
    self.titleLabel.frame = CGRectMake(ItemHorizontalMargin, TitleVerticalMargin, self.width - ItemHorizontalMargin , TitleHeight);
}
#pragma mark - action
- (void)respondsToButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(combineCell:didSelectedAtIndex:)]) {
        [self.delegate combineCell:self didSelectedAtIndex:sender.tag];
    }
}
#pragma mark - get
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:ButtonFontSize];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
@end
