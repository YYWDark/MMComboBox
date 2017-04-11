//
//  MMCombinationFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMCombinationFitlerView.h"
#import "MMComboBoxHeader.h"
#import "MMCombineCell.h"
#import "MMHeaderView.h"
#import "MMSelectedPath.h"
#import "MMAlternativeItem.h"

@interface MMCombinationFitlerView () <MMHeaderViewDelegate,MMCombineCellDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) MMHeaderView *headView;
@property (nonatomic, assign) BOOL isSuccessfulToCallBack;
@end

@implementation MMCombinationFitlerView

- (id)initWithItem:(MMCombinationItem *)item{
    self = [super init];
    if (self) {
        self.item = (MMCombinationItem *)item;
        
        //遍历Switch
        NSMutableArray *alternativeArray = [NSMutableArray array];
        for (int i = 0; i < self.item.alternativeArray.count; i++) {
            MMAlternativeItem *alternativeItem = self.item.alternativeArray[i];
            [alternativeArray addObject:[MMSelectedPath pathWithFirstPath:i isOn:alternativeItem.isSelected]];
        }
        if (alternativeArray.count) {
         [self.selectedArray addObject:alternativeArray];
        }
        
        //遍历MMItems
        for (int i = 0; i < self.item.childrenNodes.count; i++) {
            MMItem *subItem = item.childrenNodes[i];
            NSMutableArray *itemsArray = [NSMutableArray array];
            for (int j = 0; j <subItem.childrenNodes.count; j++) {
                MMItem *secondItem = subItem.childrenNodes[j];
                if (secondItem.isSelected == YES){
                    [itemsArray addObject:[MMSelectedPath pathWithFirstPath:i secondPath:j]];
                }
            }
            [self.selectedArray addObject:itemsArray];
        }
        self.temporaryArray= [[NSArray alloc] initWithArray:self.selectedArray copyItems:YES];
        
    }
    return self;
}

#pragma mark - Private Method
- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion {
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    self.sourceFrame = frame;
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    CGFloat maxHeight = kScreenHeigth - DistanceBeteewnPopupViewAndBottom - top - PopupViewTabBarHeight;
    CGFloat resultHeight = MIN(maxHeight, self.item.combinationLayout.totalHeight);
    self.frame = CGRectMake(0, top, kScreenWidth, 0);
    [rootView addSubview:self];
    
    //addTableView
    self.mainTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerClass:[MMCombineCell class] forCellReuseIdentifier:MainCellID];
    [self addSubview:self.mainTableView];
    
    
    //add shadowView
    self.shadowView.frame = CGRectMake(0, top, kScreenWidth, kScreenHeigth - top);
    self.shadowView.alpha = 0;
    self.shadowView.userInteractionEnabled = YES;
    [rootView insertSubview:self.shadowView belowSubview:self];
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGestureRecognizer:)];
    tap.numberOfTouchesRequired = 1; //手指数
    tap.numberOfTapsRequired = 1; //tap次数
    [self.shadowView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame = CGRectMake(0, top, kScreenWidth, resultHeight);
        self.mainTableView.frame = self.bounds;
        self.shadowView.alpha = ShadowAlpha;
    } completion:^(BOOL finished) {
        completion();
        self.height += PopupViewTabBarHeight;
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = [UIColor colorWithHexString:@"FCFAFD"];
        self.bottomView.frame = CGRectMake(0, self.mainTableView.bottom, self.width, PopupViewTabBarHeight);
        [self addSubview:self.bottomView];
        NSArray *titleArray = @[@"重置",@"确定"];
        for (int i = 0; i < 2 ; i++) {
            CGFloat left = ((i == 0)?ButtonHorizontalMargin:self.width - ButtonHorizontalMargin - 100);
            UIColor *titleColor = ((i == 0)?[UIColor blackColor]:[UIColor colorWithHexString:titleSelectedColor]);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(left, 0, 100, PopupViewTabBarHeight);
            button.tag = i;
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:titleColor forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:ButtonFontSize];
            [button addTarget:self action:@selector(respondsToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomView addSubview:button];
        }
    }];

}


- (void)dismiss{
    [super dismiss];
    if ([self.delegate respondsToSelector:@selector(popupViewWillDismiss:)]) {
        [self.delegate popupViewWillDismiss:self];
    }
    
    //根据isSuccessfulToCallBack字段判断是否要将数据回归到temporaryArray状态
    [self _recoverToTheOriginalState];
   
    self.bottomView.hidden = YES;
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

#pragma mark - Private Method
//当有Switch类型的时候selectedArray index对应(path.firstPath + 1)
- (NSInteger)_indexOfSelectedArrayByPath:(MMSelectedPath *)path {
    return self.item.isHasSwitch?(path.firstPath + 1):path.firstPath;;
}

- (BOOL)_iscontainsSelectedPath:(MMSelectedPath *)path sourceArray:(NSMutableArray *)array {
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath && selectedpath.secondPath == path.secondPath) return YES;
    }
    return NO;
}

- (MMSelectedPath *)_removePath:(MMSelectedPath *)path sourceArray:(NSMutableArray *)array {
    
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath && selectedpath.secondPath == path.secondPath &&selectedpath.isKindOfAlternative == NO ) {
            MMSelectedPath *returnPath = selectedpath;
            [array removeObject:selectedpath];
            return returnPath;
        }
    }
    return nil;
}

- (MMSelectedPath *)_findAlternativeItemAtIndex:(NSInteger)index sourceArray:(NSMutableArray *)array {
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == index && selectedpath.isKindOfAlternative == YES) {
            return selectedpath;
        }
    }
    return nil;
}
//重置
- (void)_resetValue {
    [self _clearItemsStateOfSelectedArray];
    [self.temporaryArray enumerateObjectsUsingBlock:^(NSMutableArray*  _Nonnull subArray, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.item.isHasSwitch && idx == 0 ) {
            for (MMSelectedPath *selectedPath in subArray) {
                MMAlternativeItem *item = self.item.alternativeArray[selectedPath.firstPath];
                item.isSelected = NO;
            }
            return;
        }
//        if (subArray.count == 0) return;
//        MMSelectedPath *selectedPath = subArray[0];
        MMSelectedPath *resetPath = [MMSelectedPath pathWithFirstPath:self.item.isHasSwitch?idx-1:idx secondPath:0];
        MMItem *lastItem = self.item.childrenNodes[resetPath.firstPath].childrenNodes[resetPath.secondPath];
        lastItem.isSelected = YES;
        [self.selectedArray[idx] addObject:resetPath];
    }];
    [self.mainTableView reloadData];
}

- (void)_clearItemsStateOfSelectedArray {
    [self.selectedArray enumerateObjectsUsingBlock:^(NSMutableArray*  _Nonnull subArray, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.item.isHasSwitch && idx == 0) return;
        
        for (MMSelectedPath *selectedPath in subArray) {
            MMItem *lastItem = self.item.childrenNodes[selectedPath.firstPath].childrenNodes[selectedPath.secondPath];
            lastItem.isSelected = NO;
        }
        [subArray removeAllObjects];
    }];
}
//恢复到最初状态
- (void)_recoverToTheOriginalState {
    if (self.isSuccessfulToCallBack == NO) {
        [self _clearItemsStateOfSelectedArray];
        
        [self.temporaryArray enumerateObjectsUsingBlock:^(NSMutableArray*  _Nonnull subArray, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.item.isHasSwitch && idx == 0 ) {
                for (MMSelectedPath *selectedPath in subArray) {
                    MMAlternativeItem *item = self.item.alternativeArray[selectedPath.firstPath];
                    item.isSelected = selectedPath.isOn;
                }
            return;
            }
            for (MMSelectedPath *selectedPath in subArray) {
                MMItem *lastItem = self.item.childrenNodes[selectedPath.firstPath].childrenNodes[selectedPath.secondPath];
                lastItem.isSelected = YES;
             }
        }];
    }
}

- (void)callBackDelegate {
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        self.isSuccessfulToCallBack = YES;
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.selectedArray  atIndex:self.tag];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
            self.isSuccessfulToCallBack = NO;
        });
    }
}
#pragma mark - Action
- (void)respondsToButtonAction:(UIButton *)sender {
    if (sender.tag == 0) {
        [self _resetValue];
    } else if (sender.tag == 1) {//确定
        [self callBackDelegate];
    }
}

- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dismiss];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.childrenNodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMCombineCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellID forIndexPath:indexPath];
    cell.item = self.item.childrenNodes[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.headView == nil) {
     self.headView = [[MMHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width,self.item.combinationLayout.headerViewHeight)];
     self.headView.delegate = self;
     self.headView.backgroundColor = [UIColor whiteColor];
    }
    self.headView.item = self.item;
    return self.headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.item.combinationLayout.cellLayoutTotalHeight[indexPath.row] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.item.combinationLayout.headerViewHeight;
}

#pragma mark - MMHeaderViewDelegate
- (void)headerView:(MMHeaderView *)headerView didSelectedAtIndex:(NSInteger)index currentState:(BOOL)isSelected {
    //switch会在index为0的数组里面
   NSMutableArray *itemArray = self.selectedArray[0];
   MMSelectedPath *selectedPath = [self _findAlternativeItemAtIndex:index sourceArray:itemArray];
   selectedPath.isOn = isSelected;
   MMAlternativeItem *item = self.item.alternativeArray[index];
   item.isSelected = isSelected;
}

#pragma mark - MMCombineCellDelegate

- (void)combineCell:(MMCombineCell *)combineCell didSelectedAtIndex:(NSInteger)index{
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:combineCell];
    NSInteger indexOfSelectedArray = [self _indexOfSelectedArrayByPath:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:index]];
    NSMutableArray *itemArray = self.selectedArray[indexOfSelectedArray];
   
    switch (self.item.selectedType) {
        case MMPopupViewSingleSelection:{ //单选
            if ([self _iscontainsSelectedPath:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:index] sourceArray:itemArray] && itemArray.count == 1) return; //包含
                MMSelectedPath *removeIndexPath = [itemArray lastObject];
                [itemArray removeAllObjects];
                self.item.childrenNodes[removeIndexPath.firstPath].childrenNodes[removeIndexPath.secondPath].isSelected = NO;
                [itemArray addObject:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:index]];
                self.item.childrenNodes[indexPath.row].childrenNodes[index].isSelected = YES;
            
            break;}
            
        case MMPopupViewMultilSeMultiSelection:{//多选
            if ([self _iscontainsSelectedPath:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:index] sourceArray:itemArray]) {
                if (itemArray.count == 1) return;
                MMSelectedPath *removeIndexPath = [self _removePath:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:index] sourceArray:itemArray];
                 self.item.childrenNodes[removeIndexPath.firstPath].childrenNodes[removeIndexPath.secondPath].isSelected = NO;
            }else {
                self.item.childrenNodes[indexPath.row].childrenNodes[index].isSelected = YES;
                [itemArray addObject:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:index]];
            }
            
            break;}
        default:
            break;
    }
    [self.mainTableView reloadData];
}

@end
