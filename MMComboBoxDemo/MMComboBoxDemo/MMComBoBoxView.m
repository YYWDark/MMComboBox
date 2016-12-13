//
//  MMComBoBoxView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMComBoBoxView.h"
#import "MMDropDownBox.h"
#import "MMHeader.h"
#import "MMBasePopupView.h"

@interface MMComBoBoxView () <MMDropDownBoxDelegate,MMPopupViewDelegate>
//@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *dropDownBoxArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *symbolArray;  //当成一个队列来标记那个弹出视图
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, assign) NSInteger lastTapIndex;       //默认 -1
@end

@implementation MMComBoBoxView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lastTapIndex = -1;
        self.dropDownBoxArray = [NSMutableArray array];
        self.itemArray = [NSMutableArray array];
        self.symbolArray = [NSMutableArray arrayWithCapacity:1];
       
    }
    return self;
}
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

- (void)reload {
    NSUInteger count = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsIncomBoBoxView:)]) {
      count = [self.dataSource numberOfColumnsIncomBoBoxView:self];
    }
    
    CGFloat width = self.width/count;
    if ([self.dataSource respondsToSelector:@selector(comBoBoxView:infomationForColumn:)]) {
        for (NSUInteger i = 0; i < count; i ++) {
            MMItem *item = [self.dataSource comBoBoxView:self infomationForColumn:i];
            [item findTheTypeOfPopUpView];
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

#pragma mark - MMDropDownBoxDelegate
- (void)didTapDropDownBox:(MMDropDownBox *)dropDownBox atIndex:(NSUInteger)index{
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
        MMItem *item = self.itemArray[index];
        MMBasePopupView *popupView = [MMBasePopupView getSubPopupView:item];
        popupView.delegate = self;
        popupView.tag = index;
        [popupView popupViewFromSourceFrame:self.frame];
        [self.symbolArray addObject:popupView];
    }
}

#pragma mark - MMPopupViewDelegate
- (void)popupView:(MMBasePopupView *)popupView didSelectedItemsPackagingInDictionary:(NSDictionary*)dictionary atIndex:(NSUInteger)index{
    //拼接选择项
    MMItem *item = self.itemArray[index];
    NSArray *indexArray = dictionary[item.title];
    NSMutableString *title = [NSMutableString string];
    for (int i = 0; i <indexArray.count; i++) {
        NSNumber *number = indexArray[i]; 
        [title appendString:i?[NSString stringWithFormat:@";%@",[item.childrenNodes[[number integerValue]] title]]:[item.childrenNodes[[number integerValue]] title]];
    }

    MMDropDownBox *box = self.dropDownBoxArray[index];
    [box updateTitleContent:title];
}

- (void)popupViewWillDismiss:(MMBasePopupView *)popupView {
  [self.symbolArray removeAllObjects];
   for (MMDropDownBox *currentBox in self.dropDownBoxArray) {
        [currentBox updateTitleState:NO];
    }
}
@end
