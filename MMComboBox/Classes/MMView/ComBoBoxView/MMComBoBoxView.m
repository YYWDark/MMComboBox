//
//  MMComBoBoxView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMComBoBoxView.h"
#import "MMDropDownBox.h"
#import "MMComboBoxHeader.h"
#import "MMBasePopupView.h"
#import "MMSelectedPath.h"
#import "MMCombinationItem.h"
@interface MMComBoBoxView () <MMDropDownBoxDelegate,MMPopupViewDelegate>
@property (nonatomic, strong) NSMutableArray <MMDropDownBox *>*dropDownBoxArray;
@property (nonatomic, strong) NSMutableArray <MMItem *>*itemArray;
@property (nonatomic, strong) NSMutableArray <MMBasePopupView *>*symbolArray;  /*当成一个队列来标记那个弹出视图**/
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, strong) MMBasePopupView *popupView;
@property (nonatomic, assign) BOOL isAnimation;                               /*防止多次快速点击**/
@end

@implementation MMComBoBoxView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dropDownBoxArray = [NSMutableArray array];
        self.itemArray = [NSMutableArray array];
        self.symbolArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}


- (void)reload {
    NSUInteger count = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsIncomBoBoxView:)]) {
      count = [self.dataSource numberOfColumnsIncomBoBoxView:self];
    }
    
    CGFloat width = self.width/count;
    if ([self.dataSource respondsToSelector:@selector(comBoBoxView:infomationForColumn:)]) {
        for (NSUInteger i = 0; i < count; i ++) {
            MMItem *item = [self.dataSource comBoBoxView:self infomationForColumn:i];
            if ([item isMemberOfClass:[MMCombinationItem class]]) {
                [(MMCombinationItem *)item addLayoutInformationWhenTypeFilters];
            }
            
            MMDropDownBox *dropBox = [[MMDropDownBox alloc] initWithFrame:CGRectMake(i*width, 0, width, self.height) titleName:item.title];
            dropBox.tag = i;
            dropBox.delegate = self;
            [self addSubview:dropBox];
            [self.dropDownBoxArray addObject:dropBox];
            [self.itemArray addObject:item];
        }
    }
    [self _addLine];
}

- (void)dimissPopView {
    if (self.popupView.superview) {
        [self.popupView dismissWithOutAnimation];
    }
}

#pragma mark - Private Method
- (void)_addLine {
    self.topLine = [CALayer layer];
    self.topLine.frame = CGRectMake(0, 0 , self.width, 1.0/scale);
    self.topLine.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3].CGColor;
    [self.layer addSublayer:self.topLine];
    
    self.bottomLine = [CALayer layer];
    self.bottomLine.frame = CGRectMake(0, self.height - 1.0/scale , self.width, 1.0/scale);
    self.bottomLine.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"].CGColor;
    [self.layer addSublayer:self.bottomLine];
}
#pragma mark - MMDropDownBoxDelegate
- (void)didTapDropDownBox:(MMDropDownBox *)dropDownBox atIndex:(NSUInteger)index {
    if (self.isAnimation == YES) return;
    for (int i = 0; i <self.dropDownBoxArray.count; i++) {
        MMDropDownBox *currentBox  = self.dropDownBoxArray[i];
        [currentBox updateTitleState:(i == index)];
    }
    //点击后先判断symbolArray有没有标示
    if (self.symbolArray.count) {
        //移除
        MMBasePopupView * lastView = self.symbolArray[0];
        [lastView dismiss];
        [self.symbolArray removeAllObjects];
        
    }else{
        self.isAnimation = YES;
        MMItem *item = self.itemArray[index];
        MMBasePopupView *popupView = [MMBasePopupView getSubPopupView:item];
        popupView.delegate = self;
        popupView.tag = index;
        self.popupView = popupView;
        [popupView popupViewFromSourceFrame:self.frame completion:^{
           self.isAnimation = NO;
        }];
        [self.symbolArray addObject:popupView];
    }
}

#pragma mark - MMPopupViewDelegate
- (void)popupView:(MMBasePopupView *)popupView didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index {
    MMItem *item = self.itemArray[index];
    //混合类型不做UI赋值操作 直接将item的路径回调回去就好了
    if (item.displayType == MMPopupViewDisplayTypeMultilayer || item.displayType == MMPopupViewDisplayTypeNormal) {
        //拼接选择项
        NSMutableString *title = [NSMutableString string];
        for (int i = 0; i <array.count; i++) {
            MMSelectedPath *path = array[i];
            [title appendString:i?[NSString stringWithFormat:@";%@",[item findTitleBySelectedPath:path]]:[item findTitleBySelectedPath:path]];
        }
        MMDropDownBox *box = self.dropDownBoxArray[index];
        //UI赋值操作
        [box updateTitleContent:title];
    };
  
    if ([self.delegate respondsToSelector:@selector(comBoBoxView:didSelectedItemsPackagingInArray:atIndex:)]) {
        [self.delegate comBoBoxView:self didSelectedItemsPackagingInArray:array atIndex:index];
    }
}

- (void)popupViewWillDismiss:(MMBasePopupView *)popupView {
   [self.symbolArray removeAllObjects];
   for (MMDropDownBox *currentBox in self.dropDownBoxArray) {
        [currentBox updateTitleState:NO];
    }
}
@end
