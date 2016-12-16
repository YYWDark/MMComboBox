//
//  MMCombinationFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMCombinationFitlerView.h"
#import "MMHeader.h"

@interface MMCombinationFitlerView ()
@end

@implementation MMCombinationFitlerView

- (id)initWithItem:(MMItem *)item{
    self = [super init];
    if (self) {
        self.item = item;
        self.selectedArray = [NSMutableArray array];
        self.backgroundColor = [UIColor randomColor];
    }
    return self;
}

- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion {
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    self.sourceFrame = frame;
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    CGFloat maxHeight = kScreenHeigth - DistanceBeteewnPopupViewAndBottom - top - PopupViewTabBarHeight;
    CGFloat resultHeight = MIN(maxHeight, self.item.childrenNodes.count * PopupViewRowHeight);
    self.frame = CGRectMake(0, top, kScreenWidth, 0);
    [rootView addSubview:self];
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame = CGRectMake(0, top, kScreenWidth, resultHeight);
        self.mainTableView.frame = self.bounds;
        self.shadowView.alpha = .3;
    } completion:^(BOOL finished) {
        completion();
//        self.height += PopupViewTabBarHeight;
//        self.bottomView = [[UIView alloc] init];
//        self.bottomView.backgroundColor = [UIColor whiteColor];
//        self.bottomView.frame = CGRectMake(0, self.mainTableView.bottom, self.width, PopupViewTabBarHeight);
//        [self addSubview:self.bottomView];
//        NSArray *titleArray = @[@"取消",@"确定"];
//        for (int i = 0; i < 2 ; i++) {
//            CGFloat left = ((i == 0)?ButtonHorizontalMargin:self.width - ButtonHorizontalMargin - 100);
//            UIColor *titleColor = ((i == 0)?[UIColor blackColor]:[UIColor colorWithHexString:titleSelectedColor]);
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(left, 0, 100, PopupViewTabBarHeight);
//            button.tag = i;
//            [button setTitle:titleArray[i] forState:UIControlStateNormal];
//            [button setTitleColor:titleColor forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont systemFontOfSize:ButtonFontSize];
//            [button addTarget:self action:@selector(respondsToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//            [self.bottomView addSubview:button];
//        }
    }];

}

- (void)dismiss{
    if ([self.delegate respondsToSelector:@selector(popupViewWillDismiss:)]) {
        [self.delegate popupViewWillDismiss:self];
    }
    
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    //消失的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame = CGRectMake(0, top, kScreenWidth, 0);
        self.mainTableView.frame = self.bounds;
        self.shadowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}
@end
