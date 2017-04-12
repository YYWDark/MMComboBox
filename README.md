![MMComboBox.png](http://upload-images.jianshu.io/upload_images/307963-3cde946e7e267d67.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## Features
- [x] 支持单层的单选和多选
- [x] 支持两层联动筛选
- [x] 支持三层联动筛选
- [x] 支持混合模式的单选和多选

## Requirements
- iOS 7.0 or later

## Rrchitecture
![结构图.png](http://upload-images.jianshu.io/upload_images/307963-97fa9a27aa16c8e2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##Example code 
1.初始化视图：

```
 MMComBoBoxView *view = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    view.dataSource = self;
    view.delegate = self;
    [self.view addSubview:view];
    [view reload];
```

2.通过datasource协议将数据传给`MMComBoBoxView`,你可以联想UITableView数据驱动方式就可以了。

```
#pragma mark - MMComBoBoxViewDataSource
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView {
    return self.mutableArray.count;
}

- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column {
    return self.mutableArray[column];
}
```

3.我们会通过`MMComBoBoxViewDelegate`协议把选中的路径回调出来，这里我们选择回调存储路径的数组的本质是在于可能开发人员上传的不止是`title`，可能还有对应的`code`等一系列的字段。这样方便扩展。

```
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
MMCombinationItem * combineItem = (MMCombinationItem *)rootItem;
[array enumerateObjectsUsingBlock:^(NSMutableArray*  _Nonnull subArray, NSUInteger idx, BOOL * _Nonnull stop) {
if (combineItem.isHasSwitch && idx == 0) {
for (MMSelectedPath *path in subArray) {
MMAlternativeItem *alternativeItem = combineItem.alternativeArray[path.firstPath];
NSLog(@"当title为: %@ 时，选中状态为: %d",alternativeItem.title,alternativeItem.isSelected);
}
return;
}

NSString *title;
NSMutableString *subtitles = [NSMutableString string];
for (MMSelectedPath *path in subArray) {
MMItem *firstItem = combineItem.childrenNodes[path.firstPath];
MMItem *secondItem = combineItem.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
title = firstItem.title;
[subtitles appendString:[NSString stringWithFormat:@"  %@",secondItem.title]];
}
NSLog(@"当title为%@时，所选字段为 %@",title,subtitles);
}];

break;}
default:
break;
}
}
```

##Example gif
![example.gif](http://upload-images.jianshu.io/upload_images/307963-58715a141c0ce600.gif?imageMogr2/auto-orient/strip)
