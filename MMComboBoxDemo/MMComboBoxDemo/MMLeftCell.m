//
//  MMLeftCell.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/12.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMLeftCell.h"
#import "MMComboBoxHeader.h"
@interface MMLeftCell ()
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) CALayer *bottomLine;
@end

@implementation MMLeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.infoLabel];
        [self.layer addSublayer:self.bottomLine];
    }
    return self;
}

- (void)setItem:(MMItem *)item {
    _item = item;
    self.infoLabel.text = item.title;
    self.backgroundColor = item.isSelected?[UIColor colorWithHexString:SelectedBGColor]:[UIColor colorWithHexString:UnselectedBGColor];
    self.infoLabel.textColor = item.isSelected?[UIColor colorWithHexString:titleSelectedColor]:[UIColor blackColor];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.infoLabel.frame = CGRectMake(LeftCellHorizontalMargin, 0, self.width - 2 *LeftCellHorizontalMargin, self.height);
    self.bottomLine.frame = CGRectMake(0, self.height - 1.0/scale , self.width, 1.0/scale);
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.font = [UIFont systemFontOfSize:MainTitleFontSize];
    }
    return _infoLabel;
}

- (CALayer *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3].CGColor;
    }
    return _bottomLine;
}
@end
