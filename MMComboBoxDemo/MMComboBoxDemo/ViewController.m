//
//  ViewController.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "ViewController.h"
#import "MMComBoBoxView.h"
#import "MMItem.h"
#import "MMHeader.h"
#import "MMAlternativeItem.h"

@interface ViewController () <MMComBoBoxViewDataSource, MMComBoBoxViewDelegate>
@property (nonatomic, strong) NSMutableArray *mutableArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//===============================================Package Data===============================================
    //first root
    MMItem *rootItem1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"全部"];
    rootItem1.selectedType = MMPopupViewMultilSeMultiSelection;
    //first floor
    for (int i = 0; i < 20; i ++) {
        
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"蛋糕系列%d",i] subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
    }
    
   //second root
   MMItem *rootItem2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"智能排序"];
   //first floor
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"智能排序"]]];
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"离我最近"]]];
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"好评优先"]]];
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"人气最高"]]];
   
    
    //third root
    MMItem *rootItem3 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"附近"];
    for (int i = 0; i < 30; i++){
        MMItem *item3_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"市区%d",i]];
        [rootItem3 addNode:item3_A];
        for (int j = 0; j < random()%30; j ++) {
            if (i == 0 &&j == 0) {
                 [item3_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"市区%d县%d",i,j]subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
            }else{
                [item3_A addNodeWithoutMark:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"市区%d县%d",i,j]subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
            }
        }
    }
    
    //fourth root
    MMItem *rootItem4 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"筛选"];
    MMAlternativeItem *alternativeItem1 = [MMAlternativeItem itemWithTitle:@"只看免预约" isSelected:NO];
    MMAlternativeItem *alternativeItem2 = [MMAlternativeItem itemWithTitle:@"节假日可用" isSelected:YES];
    [rootItem4.alternativeArray addObject:alternativeItem1];
    [rootItem4.alternativeArray addObject:alternativeItem2];
    
    NSArray *arr = @[@{@"用餐时段":@[@"不限",@"早餐",@"午餐",@"下午茶",@"晚餐",@"夜宵"]},
                     @{@"用餐人数":@[@"不限",@"单人餐",@"双人餐",@"3~4人餐",@"5~10人餐",@"10人以上",@"代金券",@"其他"]},
                     @{@"餐厅服务":@[@"不限",@"优惠买单",@"在线点餐",@"外卖送餐",@"预定",@"食客推荐",@"在线排队"]} ];
    
    for (NSDictionary *itemDic in arr) {
        MMItem *item4_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[itemDic.allKeys lastObject]];
        [rootItem4 addNode:item4_A];
        for (NSString *title in [itemDic.allValues lastObject]) {
            [item4_A addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:title]];
        }
    }
    
    self.mutableArray = [NSMutableArray array];
    [self.mutableArray addObject:rootItem1];
    [self.mutableArray addObject:rootItem2];
    [self.mutableArray addObject:rootItem3];
    [self.mutableArray addObject:rootItem4];

//===============================================Init===============================================
    
    MMComBoBoxView *view = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    view.dataSource = self;
    view.delegate = self;
    [self.view addSubview:view];
    [view reload];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - MMComBoBoxViewDataSource
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView{
    return self.mutableArray.count;
}
- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column{
    return self.mutableArray[column];
}

#pragma mark - MMComBoBoxViewDelegate
- (void)comBoBoxView:(MMComBoBoxView *)comBoBoxViewd didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index{
    
}
@end
