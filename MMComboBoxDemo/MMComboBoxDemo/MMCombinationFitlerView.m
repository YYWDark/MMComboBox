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
    CGFloat resultHeight = MIN(maxHeight, self.item.layout.totalHeight);
    self.frame = CGRectMake(0, top, kScreenWidth, 0);
    [rootView addSubview:self];
    
    //addSubView
    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - top);
    self.shadowView.alpha = 0.0;
    [self addSubview:self.shadowView];
    
    self.mainTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MainCellID];
    [self addSubview:self.mainTableView];
    
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame = CGRectMake(0, top, kScreenWidth, resultHeight);
        self.mainTableView.frame = self.bounds;
        self.shadowView.alpha = .3;
    } completion:^(BOOL finished) {
        completion();
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

#pragma mark - UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *hearView = [[UIView alloc] init];
    hearView.backgroundColor = [UIColor redColor];
    return hearView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.item.layout.headerViewHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.item.childrenNodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellID forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
}

@end
