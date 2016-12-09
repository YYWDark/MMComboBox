//
//  MMNormalCell.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMNormalCell.h"
#import "MMHeader.h"
static const CGFloat horizontalMargin = 10.0f;

@interface MMNormalCell ()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UIImageView *selectedImageview;
@end

@implementation MMNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



- (void)layoutSubviews{
    [super layoutSubviews];
    self.selectedImageview.frame = CGRectMake(horizontalMargin, (self.height -16)/2, 16, 16);
    self.title.frame = CGRectMake(self.selectedImageview.right + 5, 0, 100, self.height);
    if (_item.subTitle != nil) {
        self.subTitle.frame = CGRectMake(self.width - horizontalMargin - 100 , 0, 100, self.height);
    }
}

- (void)setItem:(MMItem *)item{
    _item = item;
    self.title.text = item.title;
    if (item.subTitle != nil) {
    self.subTitle.text  = item.subTitle;
    }
    self.selectedImageview.hidden = !item.isSelected;
}
#pragma mark - get
- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont systemFontOfSize:14];
        [self addSubview:_title];
    }
    return _title;
}

- (UILabel *)subTitle{
    if (!_subTitle) {
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor blackColor];
        _subTitle.textAlignment = NSTextAlignmentRight;
        _subTitle.font = [UIFont systemFontOfSize:12];
        [self addSubview:_subTitle];
    }
    return _subTitle;
}

- (UIImageView *)selectedImageview{
    if (!_selectedImageview) {
        _selectedImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_selected"]];
        [self addSubview:_selectedImageview];
    }
    return _selectedImageview;
}
@end
