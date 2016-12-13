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
@interface ViewController () <MMComBoBoxViewDataSource>
@property (nonatomic, strong) NSMutableArray *mutableArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mutableArray = [NSMutableArray array];
    
    //根1
    MMItem *rootItem1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"全部"];
    rootItem1.selectedType = MMPopupViewMultilSeMultiSelection;
    //第一层
//    [rootItem1 addNode:rootItem1];
    for (int i = 0; i < 20; i ++) {
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"蛋糕系列%d",i] subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
    }
    
   //根2
   MMItem *rootItem2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"智能排序"];
   //第一层
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"智能排序"]]];
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"离我最近"]]];
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"好评优先"]]];
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"人气最高"]]];
   
    
    //根3
    MMItem *rootItem3 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"附近"];
    
    for (int i = 0; i < 30; i++){
        MMItem *item_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:[NSString stringWithFormat:@"市区%d",i]];
        [rootItem3 addNode:item_A];
        for (int j = 0; j < random()%30; j ++) {
                [item_A addNodeWithoutMark:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"市区%d县%d",i,j]subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
            
        
        }
    }
    
    [self.mutableArray addObject:rootItem1];
    [self.mutableArray addObject:rootItem2];
    [self.mutableArray addObject:rootItem3];
    MMComBoBoxView *view = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 40)];
    view.dataSource = self;
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

@end
