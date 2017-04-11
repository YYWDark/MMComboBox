//
//  MMMultiFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMMultiFitlerView.h"
#import "MMComboBoxHeader.h"
#import "MMLeftCell.h"
#import "MMNormalCell.h"
#import "MMSelectedPath.h"
#import "MMMultiItem.h"

@interface MMMultiFitlerView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSUInteger minRowNumber;
@property (nonatomic, strong) NSMutableArray *tableViewArrays;
@property (nonatomic, strong) MMMultiItem *item;
@property (nonatomic, strong) MMSelectedPath *lastSelectedPath;
@property (nonatomic, assign) BOOL isSuccessfulToCallBack;
@end

@implementation MMMultiFitlerView
- (id)initWithItem:(MMItem *)item{
    self = [super init];
    if (self) {
        self.item = (MMMultiItem *)item;
        [self _findSelectedItem];
        self.minRowNumber = 4;
        self.backgroundColor = [UIColor clearColor];
        self.temporaryArray= [[NSArray alloc] initWithArray:self.selectedArray copyItems:YES];
    }
    return self;
}

#pragma mark - public method
- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion {
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    self.sourceFrame = frame;
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    CGFloat maxHeight = kScreenHeigth - DistanceBeteewnPopupViewAndBottom - top - PopupViewTabBarHeight;
    CGFloat resultHeight = MIN(maxHeight, MAX(self.item.childrenNodes.count, self.minRowNumber)  * PopupViewRowHeight);
    self.frame = CGRectMake(0, top, kScreenWidth, 0);
    [rootView addSubview:self];
    
    //add tableView
    NSUInteger numberOftableViews = (self.item.numberOflayers == MMPopupViewTwolayers)?2:3;
    CGFloat firstTableViewRowHeight =(self.minRowNumber > self.item.childrenNodes.count)?(PopupViewRowHeight*self.minRowNumber/self.item.childrenNodes.count):PopupViewRowHeight;
    for (NSInteger index = 0; index < numberOftableViews; index ++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.rowHeight = (index == 0)?firstTableViewRowHeight:PopupViewRowHeight;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = index;
        tableView.tableFooterView = [UIView new];
        if (self.item.numberOflayers == MMPopupViewThreelayers) {
            [tableView registerClass:[MMLeftCell class] forCellReuseIdentifier:MainCellID];
        }else {
            if (index != numberOftableViews -1 ) {
                [tableView registerClass:[MMLeftCell class] forCellReuseIdentifier:MainCellID];
            }else {
                [tableView registerClass:[MMNormalCell class] forCellReuseIdentifier:SubCellID];
            }
        }
        
        [self addSubview:tableView];
        [self.tableViewArrays addObject:tableView];
        
    }
    
    //add ShadowView
    self.shadowView.frame = CGRectMake(0, top, kScreenWidth, kScreenHeigth - top);
    self.shadowView.alpha = 0;
    self.shadowView.userInteractionEnabled = YES;
    [rootView insertSubview:self.shadowView belowSubview:self];
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGestureRecognizer:)];
    tap.numberOfTouchesRequired = 1; //手指数
    tap.numberOfTapsRequired = 1; //tap次数
    [self.shadowView addGestureRecognizer:tap];
    
    //出现的动画
    LeftCellWidth  = (self.item.numberOflayers == MMPopupViewThreelayers)?kScreenWidth/3:100.0f;
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame = CGRectMake(0, top, kScreenWidth, resultHeight);
        for (int index = 0; index < self.tableViewArrays.count; index ++) {
             UITableView *tableView = self.tableViewArrays[index];
            if (self.item.numberOflayers == MMPopupViewThreelayers) {
                tableView.frame = CGRectMake(LeftCellWidth * index, 0, LeftCellWidth, self.height);
            }else {
                BOOL isFirstIndex = (index == 0);
                tableView.frame = CGRectMake(isFirstIndex?0:LeftCellWidth, 0, isFirstIndex?LeftCellWidth:(self.width - LeftCellWidth), self.height);
            }
           
        }
        self.shadowView.alpha = ShadowAlpha;
        
    } completion:^(BOOL finished) {
        
        completion();
    }];
    
}

- (void)dismiss{
    [super dismiss];
    if (self.isSuccessfulToCallBack == NO) {
        [self resetValue];
    }
    if ([self.delegate respondsToSelector:@selector(popupViewWillDismiss:)]) {
        [self.delegate popupViewWillDismiss:self];
    }
    
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    //消失的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        //        self.imageView.hidden = YES;
        self.frame = CGRectMake(0, top, kScreenWidth, 0);
        for (UITableView *tableView in self.tableViewArrays) {
            tableView.height = self.height;
        }
        self.shadowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - private method
- (NSInteger)_getFirstLayerIndex {
    MMSelectedPath *path = [self.selectedArray lastObject];
    return path.firstPath;
}

- (NSInteger)_getSecondLayerIndex {
    MMSelectedPath *path = [self.selectedArray lastObject];
    return path.secondPath;
}
- (void)_findSelectedItem {
    NSArray *firstLayers = self.item.childrenNodes;
    for (int i = 0; i < firstLayers.count ; i ++) {
        MMItem *firstItem = firstLayers[i];
        
        if (firstItem.isSelected == YES) {
            NSArray *secondtLayers = firstItem.childrenNodes;//
            for (int j = 0; j < secondtLayers.count ; j++) {
                MMItem *secondItem = secondtLayers[j];
                
                if (secondItem.isSelected == YES) {
                    //两层的位置
                    if (self.item.numberOflayers == MMPopupViewTwolayers) {
                        [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:i secondPath:j]];
                    }
                    NSArray *thirdLayers = secondItem.childrenNodes;
                    for (int k = 0; k < thirdLayers.count; k++) {
                        
                        MMItem *thirdItem = thirdLayers[k];
                        if (thirdItem.isSelected == YES) {
                            if (self.item.numberOflayers == MMPopupViewThreelayers) {
                                [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:i secondPath:j thirdPath:k]];
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void)_callBackDelegate {
    self.isSuccessfulToCallBack = YES;
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.selectedArray  atIndex:self.tag];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }
}

- (void)_resetSelectePath:(MMSelectedPath *)selectdPath isSelected:(BOOL)isSelected {
    self.item.childrenNodes[selectdPath.firstPath].isSelected = isSelected;
    if (selectdPath.secondPath == -1) return;
    self.item.childrenNodes[selectdPath.firstPath].childrenNodes[selectdPath.secondPath].isSelected = isSelected;
    if (selectdPath.thirdPath == -1) return;
    self.item.childrenNodes[selectdPath.firstPath].childrenNodes[selectdPath.secondPath].childrenNodes[selectdPath.thirdPath].isSelected = isSelected;
}

- (void)_resetFromSecondPath:(MMSelectedPath *)selectdPath isSelected:(BOOL)isSelected {
    if (selectdPath.secondPath == -1) return;
    self.item.childrenNodes[selectdPath.firstPath].childrenNodes[selectdPath.secondPath].isSelected = isSelected;
    if (selectdPath.thirdPath == -1) return;
    self.item.childrenNodes[selectdPath.firstPath].childrenNodes[selectdPath.secondPath].childrenNodes[selectdPath.thirdPath].isSelected = isSelected;
}

- (void)_resetFromThirdPath:(MMSelectedPath *)selectdPath isSelected:(BOOL)isSelected {
    if (selectdPath.thirdPath == -1) return;
    self.item.childrenNodes[selectdPath.firstPath].childrenNodes[selectdPath.secondPath].childrenNodes[selectdPath.thirdPath].isSelected = isSelected;
}

- (void)resetValue {
    [self _resetSelectePath:self.selectedArray.lastObject isSelected:NO];
    [self _resetSelectePath:self.temporaryArray.lastObject isSelected:YES];
}
#pragma mark - Action
- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dismiss];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag) {
        case 0:
            return self.item.childrenNodes.count;
            break;
        case 1:
            return self.item.childrenNodes[[self _getFirstLayerIndex]].childrenNodes.count;
            break;
        case 2:
            if ([self _getSecondLayerIndex] == -1) return 0;
            return self.item.childrenNodes[[self _getFirstLayerIndex]].childrenNodes[[self _getSecondLayerIndex]].childrenNodes.count;
            break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.item.numberOflayers == MMPopupViewTwolayers) {
        if (tableView.tag != self.tableViewArrays.count - 1 ) { //mainTableView
            MMLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellID forIndexPath:indexPath];
            cell.item = self.item.childrenNodes[indexPath.row];
            return cell;
        }
        MMNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:SubCellID forIndexPath:indexPath];
        cell.item = self.item.childrenNodes[[self _getFirstLayerIndex]].childrenNodes[indexPath.row];
        cell.backgroundColor = [UIColor colorWithHexString:@"F5F3F6"];
        return cell;
    }
    
    MMLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellID forIndexPath:indexPath];
    switch (tableView.tag) {
        case 0:
            cell.item = self.item.childrenNodes[indexPath.row];
            break;
        case 1:
            cell.item = self.item.childrenNodes[[self _getFirstLayerIndex]].childrenNodes[indexPath.row];
            break;
        case 2:
            cell.item = self.item.childrenNodes[[self _getFirstLayerIndex]].childrenNodes[[self _getSecondLayerIndex]].childrenNodes[indexPath.row];
            break;
        default:
            break;
    }
    return cell;
    
}


- (void)_animatonWhenSelectRowWithTargetTableViewTag:(NSInteger)tag {
    if (self.item.numberOflayers == MMPopupViewTwolayers) return;
    UITableView *firstTableView = self.tableViewArrays[0];
    UITableView *secondTableView = self.tableViewArrays[1];
    UITableView *thirdTableView= self.tableViewArrays[2];
    CGFloat animationDuration  = .4;
    switch (tag) {
        case 0:{
            [UIView animateWithDuration:animationDuration animations:^{
               firstTableView.frame = CGRectMake(0, 0, kScreenWidth/2, self.height);
               secondTableView.frame = CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, self.height);
               thirdTableView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth/2, self.height);
                [firstTableView reloadData];
                [secondTableView reloadData];
            } completion:^(BOOL finished) {
                
            }];
            break;}
        case 1:{
             thirdTableView.hidden = NO;
            [UIView animateWithDuration:animationDuration animations:^{
                firstTableView.frame = CGRectMake(0, 0, kScreenWidth/3, self.height);
                secondTableView.frame = CGRectMake(kScreenWidth/3, 0, kScreenWidth/3, self.height);
                thirdTableView.frame = CGRectMake(kScreenWidth*2/3, 0, kScreenWidth/3, self.height);
                [thirdTableView reloadData];
            } completion:^(BOOL finished) {
               
               
            }];
            break;}
        case 2:{
            
            break;}
        default:
            break;
    }
}

- (void)_animationChangedWidth:(CGFloat)width {
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMSelectedPath *selectdPath = [self.selectedArray lastObject];
    switch (tableView.tag) {
        case 0:{
            if ([self _getFirstLayerIndex] == indexPath.row) return;
            //清除之前的选中状态
            [self _resetSelectePath:selectdPath isSelected:NO];
            
            //设置现在的选中状态
            self.item.childrenNodes[indexPath.row].isSelected = YES;
            
            //移除
            [self.selectedArray removeAllObjects];
            
            //添加
            [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:-1 thirdPath:-1]];
            
            //刷新
            if (self.item.numberOflayers == MMPopupViewTwolayers) {
                [self.tableViewArrays[0] reloadData];
                [self.tableViewArrays[1] reloadData];
            }else {
                [self _animatonWhenSelectRowWithTargetTableViewTag:tableView.tag];
            }
            
            break;}
        case 1:{
            
            if (selectdPath.secondPath == indexPath.row) return;
            //清除
            [self _resetFromSecondPath:selectdPath isSelected:NO];
            //设置现在的选中状态
            MMItem *currentIndex =self.item.childrenNodes[selectdPath.firstPath].childrenNodes[indexPath.row];
            currentIndex.isSelected = YES;
            //移除
            [self.selectedArray removeAllObjects];
            //添加
            [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:selectdPath.firstPath secondPath:indexPath.row thirdPath:-1]];
            
            UITableView *secondTableView = self.tableViewArrays[1];
            [secondTableView reloadData];
           
            if (self.item.numberOflayers == MMPopupViewTwolayers) {
                [self _callBackDelegate];
            }else {
                [self _animatonWhenSelectRowWithTargetTableViewTag:tableView.tag];
            }
           
            break;}
        case 2:{
            if (selectdPath.thirdPath == indexPath.row) return;
            //清除
            [self _resetFromThirdPath:selectdPath isSelected:NO];
            MMItem *currentIndex = self.item.childrenNodes[selectdPath.firstPath].childrenNodes[selectdPath.secondPath].childrenNodes[indexPath.row];;
            currentIndex.isSelected = YES;
            //移除
            [self.selectedArray removeAllObjects];
            //添加
            [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:selectdPath.firstPath secondPath:selectdPath.secondPath thirdPath:indexPath.row]];
            
            UITableView *thirdTableView = self.tableViewArrays[2];
            [thirdTableView reloadData];
            [self _callBackDelegate];
            break;}
        default:
            break;
    }
    
   
    
}

- (NSMutableArray *)tableViewArrays {
    if (_tableViewArrays == nil) {
        _tableViewArrays = [NSMutableArray array];
    }
    return _tableViewArrays;
}

- (MMSelectedPath *)lastSelectedPath {
    if (_lastSelectedPath == nil) {
        _lastSelectedPath = [MMSelectedPath pathWithFirstPath:-1 secondPath:-1 thirdPath:-1];
    }
    return _lastSelectedPath;
}
@end
