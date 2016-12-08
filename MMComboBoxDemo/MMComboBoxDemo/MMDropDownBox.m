//
//  MMDropDownBox.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMDropDownBox.h"
#import "MMHeader.h"
@interface MMDropDownBox ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrow;
@end

@implementation MMDropDownBox
- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.userInteractionEnabled = YES;
        //add recognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapAction:)];
        [self addGestureRecognizer:tap];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:DropDownBoxFontSize];
        self.titleLabel.text = self.title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.frame = self.bounds;
        [self addSubview:self.titleLabel];
        
        self.arrow = [[UIImageView alloc] init];
        [self addSubview:self.arrow];
        
    }
    return self;

}

- (void)respondToTapAction:(UITapGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(didTapDropDownBox:atIndex:)]) {
        [self.delegate didTapDropDownBox:self atIndex:self.tag];
    }
}
@end
