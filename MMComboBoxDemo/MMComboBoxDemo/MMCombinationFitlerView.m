//
//  MMCombinationFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMCombinationFitlerView.h"
#import "MMHeader.h"
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

- (id)initWithItem:(MMItem *)item{
    self = [super init];
    if (self) {
        self.item = item;
        self.selectedArray = [NSMutableArray array];
        
        //单选
        for (int i = 0; i < self.item.alternativeArray.count; i++) {
            MMAlternativeItem *alternativeItem = self.item.alternativeArray[i];
            [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:i isKindOfAlternative:YES isOn:alternativeItem.isSelected]];
        }
        //多层
        for (int i = 0; i < self.item.childrenNodes.count; i++) {
            MMItem *subItem = item.childrenNodes[i];
            for (int j = 0; j <subItem.childrenNodes.count; j++) {
                MMItem *secondItem = subItem.childrenNodes[j];
                if (secondItem.isSelected == YES){
                    [self.selectedArray addObject: [MMSelectedPath pathWithFirstPath:i secondPath:j]];
                    break;
                }
            }
        }
        self.temporaryArray= [[NSArray alloc] initWithArray:self.selectedArray copyItems:YES] ;
        
    }
    return self;
}

#pragma mark - Private Method
- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion {
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    self.sourceFrame = frame;
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    CGFloat maxHeight = kScreenHeigth - DistanceBeteewnPopupViewAndBottom - top - PopupViewTabBarHeight;
    CGFloat resultHeight = MIN(maxHeight, self.item.layout.totalHeight);
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
    if ([self.delegate respondsToSelector:@selector(popupViewWillDismiss:)]) {
        [self.delegate popupViewWillDismiss:self];
    }
    
    //根据isSuccessfulToCallBack字段判断是否要将数据回归到temporaryArray
    if (self.isSuccessfulToCallBack == NO) {
        [self.selectedArray enumerateObjectsUsingBlock:^(MMSelectedPath *path, NSUInteger idx, BOOL * _Nonnull stop) {
            if (path.isKindOfAlternative == YES) {
                MMAlternativeItem *item = self.item.alternativeArray[path.firstPath];
                item.isSelected = NO;
            }else {
                MMItem *lastItem = self.item.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
                lastItem.isSelected = NO;
            }
        }];
        [self.temporaryArray enumerateObjectsUsingBlock:^(MMSelectedPath *path, NSUInteger idx, BOOL * _Nonnull stop) {
            if (path.isKindOfAlternative == YES) {
                MMAlternativeItem *item = self.item.alternativeArray[path.firstPath];
                item.isSelected = path.isOn;
            }else {
                MMItem *lastItem = self.item.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
                lastItem.isSelected = YES;
            }
        }];   
    }
   
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
- (BOOL)_iscontainsSelectedPath:(MMSelectedPath *)path sourceArray:(NSMutableArray *)array {
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath && selectedpath.secondPath == path.secondPath) return YES;
    }
    return NO;
}

- (MMSelectedPath *)_removePath:(MMSelectedPath *)path sourceArray:(NSMutableArray *)array {
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath && selectedpath.isKindOfAlternative == NO) {
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

- (void)resetValue {
    for (int i = 0; i < self.selectedArray.count; i++) {
        MMSelectedPath *path = self.selectedArray[i];
        if (path.isKindOfAlternative == YES) {
            MMAlternativeItem *item = self.item.alternativeArray[path.firstPath];
            item.isSelected = NO;
        }else {
            MMItem *lastItem = self.item.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
            lastItem.isSelected = NO;
            MMItem *currentItem = self.item.childrenNodes[path.firstPath].childrenNodes[0];
            currentItem.isSelected = YES;
            path.secondPath = 0;
        }
    }
    [self.mainTableView reloadData];
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
    if (sender.tag == 0) {//重置
        [self resetValue];
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
     self.headView = [[MMHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.width,self.item.layout.headerViewHeight)];
     self.headView.delegate = self;
     self.headView.backgroundColor = [UIColor whiteColor];
    }
    self.headView.item = self.item;
    return self.headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.item.layout.cellLayoutTotalHeight[indexPath.row] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.item.layout.headerViewHeight;
}

#pragma mark - MMHeaderViewDelegate
- (void)headerView:(MMHeaderView *)headerView didSelectedAtIndex:(NSInteger)index currentState:(BOOL)isSelected {
   MMSelectedPath *selectedPath = [self _findAlternativeItemAtIndex:index sourceArray:self.selectedArray];
   selectedPath.isOn = isSelected;
   MMAlternativeItem *item = self.item.alternativeArray[index];
   item.isSelected = isSelected;
}

#pragma mark - MMCombineCellDelegate
- (void)combineCell:(MMCombineCell *)combineCell didSelectedAtIndex:(NSInteger)index{
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:combineCell];
    if ([self _iscontainsSelectedPath:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:index] sourceArray:self.selectedArray]) {//包含
        return;
    } else {
      MMSelectedPath *removeIndexPath = [self _removePath:[MMSelectedPath pathWithFirstPath:indexPath.row] sourceArray:self.selectedArray];
        self.item.childrenNodes[removeIndexPath.firstPath].childrenNodes[removeIndexPath.secondPath].isSelected = NO;
       [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:index]];
        self.item.childrenNodes[indexPath.row].childrenNodes[index].isSelected = YES;
    }
    [self.mainTableView reloadData];
}


@end
