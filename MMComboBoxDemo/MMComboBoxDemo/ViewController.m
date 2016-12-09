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
    rootItem1.selectedType = MMPopupViewSingleSelection;
    //第一层
    MMItem *A_1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"生日蛋糕"];
    MMItem *A_2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"甜点饮品"];
    MMItem *A_3 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"生日蛋糕"];
    MMItem *A_4 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"甜点饮品"];
    MMItem *A_5 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"生日蛋糕"];
    MMItem *A_6 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"甜点饮品"];
    MMItem *A_7 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"生日蛋糕"];
    MMItem *A_8 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"甜点饮品"];
    MMItem *A_9 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"生日蛋糕"];
    MMItem *A_10 = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:@"甜点饮品"];
    
    [rootItem1 addNode:A_1];
    [rootItem1 addNode:A_2];
    [rootItem1 addNode:A_3];
    [rootItem1 addNode:A_4];
    [rootItem1 addNode:A_5];
    [rootItem1 addNode:A_6];
    [rootItem1 addNode:A_7];
    [rootItem1 addNode:A_8];
    [rootItem1 addNode:A_9];
    [rootItem1 addNode:A_10];
    
    for (int i = 0; i < 4; i ++) {
        [self.mutableArray addObject:rootItem1];
    }
    
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
