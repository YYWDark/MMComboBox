//
//  MMSingleFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMSingleFitlerView.h"
#import "MMComboBoxHeader.h"
#import "MMNormalCell.h"
#import "MMSelectedPath.h"
#import "MMSingleItem.h"
@interface MMSingleFitlerView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL isSuccessfulToCallBack;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) MMSingleItem *item;
@end
@implementation MMSingleFitlerView
- (id)initWithItem:(MMItem *)item {
    self = [super init];
    if (self) {
        self.item = (MMSingleItem *)item;
        //当为MMPopupViewSingleSelection类型时，默认为YES。因为单选不存在修改了值而取消的情况
        self.isSuccessfulToCallBack = (self.item.selectedType == MMPopupViewSingleSelection)?YES:NO;
        //将默认选中的值
        for (int i = 0; i < self.item.childrenNodes.count; i++) {
            MMItem *subItem = item.childrenNodes[i];
            if (subItem.isSelected == YES){
                MMSelectedPath *path = [[MMSelectedPath alloc] init];
                path.firstPath = i;
                [self.selectedArray addObject:path];
            }
        }
        self.temporaryArray= [[NSArray alloc] initWithArray:self.selectedArray copyItems:YES] ;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - public method
- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion {
    UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    self.sourceFrame = frame;
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    CGFloat maxHeight = kScreenHeigth - DistanceBeteewnPopupViewAndBottom - top - PopupViewTabBarHeight;
    CGFloat resultHeight = MIN(maxHeight, self.item.childrenNodes.count * PopupViewRowHeight);
    self.frame = CGRectMake(0, top, kScreenWidth, 0);
     [rootView addSubview:self];
   
    self.mainTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.mainTableView.rowHeight = PopupViewRowHeight;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerClass:[MMNormalCell class] forCellReuseIdentifier:MainCellID];
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
    
    //出现的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame = CGRectMake(0, top, kScreenWidth, resultHeight);
        self.mainTableView.frame = self.bounds;
        self.shadowView.alpha = ShadowAlpha;
    } completion:^(BOOL finished) {
        completion();
        if (self.item.selectedType == MMPopupViewSingleSelection) return ;
        self.height += PopupViewTabBarHeight;
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = [UIColor colorWithHexString:@"FCFAFD"];
        self.bottomView.frame = CGRectMake(0, self.mainTableView.bottom, self.width, PopupViewTabBarHeight);
        [self addSubview:self.bottomView];
        
        NSArray *titleArray = @[@"取消",@"确定"];
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
    [self _resetValue];
    if ([self.delegate respondsToSelector:@selector(popupViewWillDismiss:)]) {
        [self.delegate popupViewWillDismiss:self];
    }
    if (self.item.selectedType == MMPopupViewMultilSeMultiSelection) {
        self.bottomView.hidden = YES;   
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

#pragma mark - Private Method
- (void)_resetValue{
    if (self.isSuccessfulToCallBack == YES) return;
        for (MMItem *item in self.item.childrenNodes) {
            item.isSelected = NO;
        }
    //恢复成以前的值
        for (MMSelectedPath *path in self.temporaryArray) {
            self.item.childrenNodes[path.firstPath].isSelected = YES;
        }

}

//该容器里面有没有包含这个path
- (BOOL)_iscontainsSelectedPath:(MMSelectedPath *)path sourceArray:(NSMutableArray *)array{
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath ) return YES;
    }
    return NO;
}


- (void)_removePath:(MMSelectedPath *)path sourceArray:(NSMutableArray *)array {
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath ) {
            [array removeObject:selectedpath];
            return;
        }
    }
}

- (void)_callBackDelegate {
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.selectedArray  atIndex:self.tag];
        [self.mainTableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }
}
#pragma mark - Action
- (void)respondsToButtonAction:(UIButton *)sender {
    if (sender.tag == 0) {//取消
      [self dismiss];
    } else if (sender.tag == 1) {//确定
    //点击确认的时候代表确定修改成现在选中的值
    self.isSuccessfulToCallBack = YES;
    [self _callBackDelegate];
    }
}

- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
  [self dismiss];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.item.childrenNodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellID forIndexPath:indexPath];
    MMItem *item = self.item.childrenNodes[indexPath.row];
    cell.item = item;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.item.selectedType == MMPopupViewMultilSeMultiSelection) { //多选
        
        if ([self _iscontainsSelectedPath:[MMSelectedPath pathWithFirstPath:indexPath.row] sourceArray:self.selectedArray]) {
            //如果已经有了这个路径 而且数组里面就一个数据
            if (self.selectedArray.count == 1) return;
            [self _removePath:[MMSelectedPath pathWithFirstPath:indexPath.row] sourceArray:self.selectedArray];
            self.item.childrenNodes[indexPath.row].isSelected = NO;
        }else {
            [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:indexPath.row]];
            self.item.childrenNodes[indexPath.row].isSelected = YES;
        }
      [self.mainTableView reloadData];
    }else if (self.item.selectedType == MMPopupViewSingleSelection) { //单选
        //因为要选中一个，如果点击的已经选中的直接返回，
        if ([self _iscontainsSelectedPath:[MMSelectedPath pathWithFirstPath:indexPath.row] sourceArray:self.selectedArray]) return;
           //移除之前的储存的路劲
            MMSelectedPath *lastSelectedPath = self.selectedArray[0] ;
            self.item.childrenNodes[lastSelectedPath.firstPath].isSelected = NO;
            [self.selectedArray removeLastObject];
           //添加当前的路劲
            self.item.childrenNodes[indexPath.row].isSelected = YES;
            [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:indexPath.row]];
            [self _callBackDelegate];
    }
}
@end
