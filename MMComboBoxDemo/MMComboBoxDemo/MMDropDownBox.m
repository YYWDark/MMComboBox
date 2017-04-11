//
//  MMDropDownBox.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMDropDownBox.h"
#import "MMComboBoxHeader.h"
@interface MMDropDownBox ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) CAGradientLayer *line;
@end

@implementation MMDropDownBox
- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.isSelected = NO;
        self.userInteractionEnabled = YES;
        
        //add recognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapAction:)];
        [self addGestureRecognizer:tap];
        
        //add subView
        self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pulldown.png"]];
        self.arrow.frame = CGRectMake(self.width - ArrowSide - ArrowToRight,(self.height - ArrowSide)/2  , ArrowSide , ArrowSide);
        [self addSubview:self.arrow];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:DropDownBoxFontSize];
        self.titleLabel.text = self.title;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.frame = CGRectMake(DropDownBoxTitleHorizontalToLeft, 0 ,self.arrow.left - DropDownBoxTitleHorizontalToArrow - DropDownBoxTitleHorizontalToLeft  , self.height);
        [self addSubview:self.titleLabel];
        
        UIColor *dark = [UIColor colorWithWhite:0 alpha:0.2];
        UIColor *clear = [UIColor colorWithWhite:0 alpha:0];
        NSArray *colors = @[(id)clear.CGColor,(id)dark.CGColor, (id)clear.CGColor];
        NSArray *locations = @[@0.2, @0.5, @0.8];
        self.line = [CAGradientLayer layer];
        self.line.colors = colors;
        self.line.locations = locations;
        self.line.startPoint = CGPointMake(0, 0);
        self.line.endPoint = CGPointMake(0, 1);
        self.line.frame = CGRectMake(self.arrow.right + ArrowToRight - 1.0/scale , 0, 1.0/scale, self.height);
        [self.layer addSublayer:self.line];
    }
    return self;

}

- (void)updateTitleState:(BOOL)isSelected {
    if (isSelected) {
        self.titleLabel.textColor = [UIColor colorWithHexString:titleSelectedColor];
        self.arrow.image = [UIImage imageNamed:@"pullup"];
    } else{
        self.titleLabel.textColor = [UIColor blackColor];
        self.arrow.image = [UIImage imageNamed:@"pulldown"];
    }
}

- (void)updateTitleContent:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)respondToTapAction:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(didTapDropDownBox:atIndex:)]) {
        [self.delegate didTapDropDownBox:self atIndex:self.tag];
    }
}
@end
