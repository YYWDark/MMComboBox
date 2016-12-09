//
//  MMSingleFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMSingleFitlerView.h"
#import "MMHeader.h"
#import "MMNormalCell.h"

@interface MMSingleFitlerView ()
@property (nonatomic, strong) NSMutableArray *selectedArray;
@end
@implementation MMSingleFitlerView
- (id)initWithItem:(MMItem *)item{
    self = [super init];
    if (self) {
        self.item = item;
        self.selectedArray = [NSMutableArray array];
        //默认第一个数被选中
//      [self.selectedArray addObject:@(0)];
        for (int i = 0; i < self.item.childrenNodes.count; i++) {
            MMItem *subItem = item.childrenNodes[i];
            if (subItem.isSelected == YES)
                [self.selectedArray addObject:@(i)];
        }
        self.backgroundColor = [UIColor randomColor];
        
        
    }
    return self;
}

- (void)popupViewFromSourceFrame:(CGRect)frame {
    
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    self.sourceFrame = frame;
    
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    CGFloat maxHeight = kScreenHeigth - DistanceBeteewnPopupViewAndBottom - top;
    CGFloat resultHeight = MIN(maxHeight, self.item.childrenNodes.count * PopupViewRowHeight + PopupViewtabBarHeight);
    self.frame = CGRectMake(0, top, kScreenWidth, 0);
     [rootView addSubview:self];
   
    //addSubView
    self.shadowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeigth - top);
    self.shadowView.alpha = 0.0;
    [self addSubview:self.shadowView];
    
    self.mainTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.mainTableView.rowHeight = PopupViewRowHeight;
    self.backgroundColor = [UIColor blueColor];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerClass:[MMNormalCell class] forCellReuseIdentifier:cellID];
    [self addSubview:self.mainTableView];
    
//    NSArray *titleArray = @[@"虫子",@""];
//    for (int i = 0; i < 2 ; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button set
//    }
    
    
    
    //出现的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame = CGRectMake(0, top, kScreenWidth, resultHeight);
        self.mainTableView.frame = self.bounds;
        self.shadowView.alpha = .3;
    } completion:^(BOOL finished) {
       
    }];
}


- (void)dismiss{
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.item.childrenNodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    MMItem *item = self.item.childrenNodes[indexPath.row];
    cell.item = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.item.selectedType == MMPopupViewMultilSeMultiSelection) { //多选
        if ([self.selectedArray containsObject:@(indexPath.row)]) {
            [self.selectedArray removeObject:@(indexPath.row)];
            self.item.childrenNodes[indexPath.row].isSelected = NO;
        }else {
            [self.selectedArray addObject:@(indexPath.row)];
            self.item.childrenNodes[indexPath.row].isSelected = YES;
        }
      [self.mainTableView reloadData];
    }else if (self.item.selectedType == MMPopupViewSingleSelection) {
        //如果点击的已经选中的直接返回
        if ([self.selectedArray containsObject:@(indexPath.row)]) return;

           //remove
            NSUInteger lastItem = [self.selectedArray[0] integerValue];
            self.item.childrenNodes[lastItem].isSelected = NO;
            [self.selectedArray removeLastObject];
           //add
            self.item.childrenNodes[indexPath.row].isSelected = YES;
            [self.selectedArray addObject:@(indexPath.row)];
            
            if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInDictionary:)]) {
                [self.delegate popupView:self didSelectedItemsPackagingInDictionary:@{self.item.title : self.selectedArray}];
                [self.mainTableView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [self dismiss];
                });
                
                
            }
        
    }
    
   
}


@end
