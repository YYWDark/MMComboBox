//
//  MMMultiFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMMultiFitlerView.h"
#import "MMHeader.h"
#import "MMLeftCell.h"
#import "MMNormalCell.h"
@interface MMMultiFitlerView ()
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) NSUInteger minRowNumber;
@property (nonatomic, strong) NSIndexPath *lastIndexPath; //记录上一个点击右边的路劲
@property (nonatomic, strong) NSMutableArray *selectedArray;
@end
@implementation MMMultiFitlerView
- (id)initWithItem:(MMItem *)item{
    self = [super init];
    if (self) {
        self.selectedArray = [NSMutableArray array];
        self.item = item;
        self.selectedIndex = [self _findLeftSelectedIndex];
        if ([self _findRightSelectedIndex:self.selectedIndex] != -1) {
            self.lastIndexPath = [NSIndexPath indexPathForRow:[self _findRightSelectedIndex:self.selectedIndex] inSection:self.selectedIndex];
        }
        self.minRowNumber = 4;
       
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - private method
- (NSUInteger)_findLeftSelectedIndex {
    for (MMItem *item in self.item.childrenNodes) {
        if (item.isSelected) return [self.item.childrenNodes indexOfObject:item];
    }
    return MAXFLOAT;
}

- (NSInteger)_findRightSelectedIndex:(NSInteger)leftIndex {
    MMItem *item = self.item.childrenNodes[leftIndex];
    for (MMItem *subItem in item.childrenNodes) {
        if (subItem.isSelected) return [item.childrenNodes indexOfObject:subItem];
    }
    return -1;
}

- (void)callBackDelegate {
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInDictionary: atIndex:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInDictionary:@{self.item.childrenNodes[self.lastIndexPath.section].title : self.selectedArray} atIndex:self.tag];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }
}
#pragma mark - public method

- (void)popupViewFromSourceFrame:(CGRect)frame {
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    self.sourceFrame = frame;
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    CGFloat maxHeight = kScreenHeigth - DistanceBeteewnPopupViewAndBottom - top - PopupViewTabBarHeight;
    CGFloat resultHeight = MIN(maxHeight, MAX(self.item.childrenNodes.count, self.minRowNumber)  * PopupViewRowHeight);
    self.frame = CGRectMake(0, top, kScreenWidth, 0);
    [rootView addSubview:self];
    
    //addSubView
    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - top);
    self.shadowView.alpha = 0.0;
    [self addSubview:self.shadowView];
    
    //add tableView
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (self.minRowNumber > self.item.childrenNodes.count) {
        self.mainTableView.rowHeight = PopupViewRowHeight*self.minRowNumber/self.item.childrenNodes.count;
    }else{
        self.mainTableView.rowHeight = PopupViewRowHeight;
    }
    
    self.mainTableView.tag = 0;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = YES;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mainTableView registerClass:[MMLeftCell class] forCellReuseIdentifier:MainCellID];
    [self addSubview:self.mainTableView];
    
    self.subTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.subTableView.rowHeight = PopupViewRowHeight;
    self.subTableView.tag = 1;
    self.subTableView.delegate = self;
    self.subTableView.dataSource = self;
    self.subTableView.backgroundColor = [UIColor colorWithHexString:@"F5F3F6"];
    self.subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.subTableView registerClass:[MMNormalCell class] forCellReuseIdentifier:SubCellID];
    [self addSubview:self.subTableView];
    
    //出现的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame = CGRectMake(0, top, kScreenWidth, resultHeight);
        self.shadowView.alpha = .3;
        self.mainTableView.frame = CGRectMake(0, 0, LeftCellWidth, self.height);
        self.subTableView.frame = CGRectMake(LeftCellWidth, 0,  self.width - LeftCellWidth, self.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismiss{
    //设置最后选中的赋给left cell
    if ([self _findLeftSelectedIndex] != self.lastIndexPath.section) {
        self.item.childrenNodes[[self _findLeftSelectedIndex]].isSelected = NO;
        self.item.childrenNodes[self.lastIndexPath.section].isSelected = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(popupViewWillDismiss:)]) {
        [self.delegate popupViewWillDismiss:self];
    }
    
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    //消失的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        //        self.imageView.hidden = YES;
        self.frame = CGRectMake(0, top, kScreenWidth, 0);
        self.mainTableView.height = self.height;
        self.subTableView.height = self.height;
        self.shadowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) { //mainTableView
       return self.item.childrenNodes.count;
    }
    return self.item.childrenNodes[self.selectedIndex].childrenNodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) { //mainTableView
        MMLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellID forIndexPath:indexPath];
        cell.item = self.item.childrenNodes[indexPath.row];
        return cell;
    }
    MMNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:SubCellID forIndexPath:indexPath];
    cell.item = self.item.childrenNodes[self.selectedIndex].childrenNodes[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"F5F3F6"];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) { //mainTableView
        if (self.selectedIndex == indexPath.row) return;
        self.item.childrenNodes[indexPath.row].isSelected = YES;
        self.item.childrenNodes[self.selectedIndex].isSelected = NO;
        self.selectedIndex = indexPath.row;
        [self.mainTableView reloadData];
        [self.subTableView reloadData];
    }else{ //subTableView
        //单选所以直接清空
        [self.selectedArray removeAllObjects];
        if(self.lastIndexPath != nil){
        MMItem *lastItem =self.item.childrenNodes[self.lastIndexPath.section].childrenNodes[self.lastIndexPath.row];
        lastItem.isSelected = NO;
        }
        MMItem *currentIndex =self.item.childrenNodes[self.selectedIndex].childrenNodes[indexPath.row];
        currentIndex.isSelected = YES;
        self.lastIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:self.selectedIndex];

        [self.subTableView reloadData];
//        [self callBackDelegate];

    }
    
}
@end
