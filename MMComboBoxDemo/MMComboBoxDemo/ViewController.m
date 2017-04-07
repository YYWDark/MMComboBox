//
//  ViewController.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyri2ght © 2016年 wyy. All rights reserved.
//

#import "ViewController.h"
#import "MMComBoBoxView.h"
#import "MMItem.h"
#import "MMHeader.h"
#import "MMAlternativeItem.h"
#import "MMSelectedPath.h"
@interface ViewController () <MMComBoBoxViewDataSource, MMComBoBoxViewDelegate>
@property (nonatomic, strong) NSArray *mutableArray;
@property (nonatomic, strong) MMComBoBoxView *comBoBoxView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//===============================================Package Data===============================================
    /*
    //first root
    MMItem *rootItem1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"全部"];
    rootItem1.selectedType = MMPopupViewMultilSeMultiSelection;
    //first floor
    for (int i = 0; i < 20; i ++) {
        [rootItem1 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"蛋糕系列%d",i] subTileName:[NSString stringWithFormat:@"%ld",random()%10000]]];
    }
    
   //second root
   MMItem *rootItem2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"排序"];
   //first floor
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"智能排序"]]];
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"离我最近"]]];
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"好评优先"]]];
   [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"人气最高"]]];
   
    
    //third root
    MMItem *rootItem3 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"附近"];
    for (int i = 0; i < 1; i++){
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
*/
//===============================================Init===============================================
    
    self.comBoBoxView = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    self.comBoBoxView.dataSource = self;
    self.comBoBoxView.delegate = self;
    [self.view addSubview:self.comBoBoxView];
    [self.comBoBoxView reload];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.comBoBoxView.bottom, self.view.width, self.view.height - 64)];
    imageView.image = [UIImage imageNamed:@"1.jpg"];
    [self.view addSubview:imageView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.comBoBoxView dimissPopView];
}

#pragma mark - MMComBoBoxViewDataSource
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView {
    return self.mutableArray.count;
}
- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column {
    return self.mutableArray[column];
}

#pragma mark - MMComBoBoxViewDelegate
- (void)comBoBoxView:(MMComBoBoxView *)comBoBoxViewd didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index {
    MMItem *rootItem = self.mutableArray[index];
    switch (rootItem.displayType) {
        case MMPopupViewDisplayTypeNormal:
        case MMPopupViewDisplayTypeMultilayer:{
            //拼接选择项
            NSMutableString *title = [NSMutableString string];
           __block NSInteger firstPath;
            [array enumerateObjectsUsingBlock:^(MMSelectedPath * path, NSUInteger idx, BOOL * _Nonnull stop) {
                [title appendString:idx?[NSString stringWithFormat:@";%@",[rootItem findTitleBySelectedPath:path]]:[rootItem findTitleBySelectedPath:path]];
                if (idx == 0) {
                firstPath = path.firstPath;
              }
            }];
            NSLog(@"当title为%@时，所选字段为 %@",rootItem.title ,title);
            break;}
        case MMPopupViewDisplayTypeFilters:{
            [array enumerateObjectsUsingBlock:^(MMSelectedPath * path, NSUInteger idx, BOOL * _Nonnull stop) {
                //当displayType为MMPopupViewDisplayTypeFilters时有MMAlternativeItem类型和MMItem类型两种
                if (path.isKindOfAlternative == YES) { //MMAlternativeItem类型
                    MMAlternativeItem *alternativeItem = rootItem.alternativeArray[path.firstPath];
                    NSLog(@"当title为%@时，选中状态为 %d",alternativeItem.title,alternativeItem.isSelected);
                } else {
                    MMItem *firstItem = rootItem.childrenNodes[path.firstPath];
                    MMItem *SecondItem = rootItem.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
                    NSLog(@"当title为%@时，所选字段为 %@",firstItem.title,SecondItem.title);
                }
            }];
            break;}
        default:
            break;
    }
}


- (NSArray *)mutableArray {
    if (_mutableArray == nil) {
       NSMutableArray *mutableArray = [NSMutableArray array];
       //root 1
       MMItem *rootItem1 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:nil];
       rootItem1.selectedType = MMPopupViewMultilSeMultiSelection;
       NSMutableString *title = [NSMutableString string];
       for (int i = 0; i < 20; i ++) {
           MMItem *subItem = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:NO titleName:[NSString stringWithFormat:@"蛋糕系列%d",i] subtitleName:[NSString stringWithFormat:@"%ld",random()%10000] code:nil];
           [rootItem1 addNode:subItem];
           if (subItem.isSelected) {
               [title appendString:subItem.title];
           }
      }
      rootItem1.title = title;
        
      //root 2
      MMItem *rootItem2 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"排序"];
      [rootItem2  addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:YES titleName:@"排序" subtitleName:nil code:nil]];
      [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"智能排序"]]];
      [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"离我最近"]]];
      [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"好评优先"]]];
      [rootItem2 addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected titleName:[NSString stringWithFormat:@"人气最高"]]];
        
        
      //root 3
      MMItem *rootItem3 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"附近"];
      rootItem3.displayType = MMPopupViewDisplayTypeMultilayer;
      for (int i = 0; i < 30; i++){
          MMItem *item3_A = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:NO titleName:[NSString stringWithFormat:@"市区%d",i] subTileName:nil];
          item3_A.isSelected = (i == 0);
            [rootItem3 addNode:item3_A];
            for (int j = 0; j < random()%30; j ++) {
             MMItem *item3_B = [MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:NO titleName:[NSString stringWithFormat:@"市区%d县%d",i,j] subTileName:[NSString stringWithFormat:@"%ld",random()%10000]];
                item3_B.isSelected = (i == 0 && j == 0);
                [item3_A addNode:item3_B];
            }
      }
        
     //root 4
        MMItem *rootItem4 = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"筛选"];
        rootItem4.displayType = MMPopupViewDisplayTypeFilters;
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
            for (int i = 0; i <  [[itemDic.allValues lastObject] count]; i++) {
                NSString *title = [itemDic.allValues lastObject][i];
                 MMItem *item4_B = [MMItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:title];
                if (i == 0) {
                    item4_B.isSelected = YES;
                }
                [item4_A addNode:item4_B];
            }
        }
        
      [mutableArray addObject:rootItem1];
      [mutableArray addObject:rootItem2];
      [mutableArray addObject:rootItem3];
      [mutableArray addObject:rootItem4];
      _mutableArray  = [mutableArray copy];
    }
    return _mutableArray;
}
@end
