![封面.jpg](http://upload-images.jianshu.io/upload_images/307963-baad2a29322a01bb.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##前言
数据大致是模范美团外卖数据。由于每个公司的业务场景不同所以这只是一个demo
##Demo效果：
![效果图.gif](http://upload-images.jianshu.io/upload_images/307963-588c68a0a4db185a.gif?imageMogr2/auto-orient/strip)
###工程结构图：
![结构图.png](http://upload-images.jianshu.io/upload_images/307963-97fa9a27aa16c8e2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
1.模拟组装数据，因为可能是多层的，所以我们这里通过组合模式来组装数据。在`MMBaseItem`里面我们定义了三个枚举：
```
//这个字段我们暂时留着以后扩展，覆盖可能要有些选项不能选择，显示灰色的情况
typedef NS_ENUM(NSUInteger, MMPopupViewMarkType) {  //选中的状态
    MMPopupViewDisplayTypeSelected = 0,      //可以选中
    MMPopupViewDisplayTypeUnselected = 1,    //不可以选中
};

typedef NS_ENUM(NSUInteger, MMPopupViewSelectedType) {     //是否支持单选或者多选
    MMPopupViewSingleSelection,                            //单选
    MMPopupViewMultilSeMultiSelection,                    //多选
};

typedef NS_ENUM(NSUInteger, MMPopupViewDisplayType) {  //分辨弹出来的view类型
    MMPopupViewDisplayTypeNormal = 0,                //一层
    MMPopupViewDisplayTypeMultilayer = 1,            //两层
    MMPopupViewDisplayTypeFilters = 2,               //混合
};
```
每个`MMItem`都持有一个`layout`对象提前计算好弹出视图的布局信息并储存。由于`MMPopupViewDisplayTypeNormal`和`MMPopupViewDisplayTypeMultilayer`两种类型布局比较单一简单，所以`layout`对象暂时只是在`MMPopupViewDisplayTypeFilters`时有用。

当然我这里是模拟数据。下面给出一种建立树模型的思路：

![屏幕快照 2016-12-22 下午11.14.13.png](http://upload-images.jianshu.io/upload_images/307963-7708a77530870004.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

1.1 首先我们把上图的根节点放到队列中

![1.1.png](http://upload-images.jianshu.io/upload_images/307963-ae6a2e9ef9e6df53.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

1.2 根据A持有子节点的指针把B，C放进队列，相当于把B,C添加到A的`childrenNodes`。然后把A给移出队列。

![1.2](http://upload-images.jianshu.io/upload_images/307963-5cfa962948165968.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

1.3 然后按照上面的逻辑一个一个的遍历每个节点。直到队列为空的时候代表一颗建立完毕。下面图未给全，只是部分状态的时刻图。

![1.3.png](http://upload-images.jianshu.io/upload_images/307963-4380f8b8e57539c9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![1.4.png](http://upload-images.jianshu.io/upload_images/307963-82c04ee55e654461.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![1.5.png](http://upload-images.jianshu.io/upload_images/307963-4f08f95a88d1887c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)




2.初始化视图：
```
 MMComBoBoxView *view = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    view.dataSource = self;
    view.delegate = self;
    [self.view addSubview:view];
    [view reload];
```
3.通过datasource协议将数据传给`MMComBoBoxView`,你可以联想UITableView数据驱动方式就可以了。
```
#pragma mark - MMComBoBoxViewDataSource
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView {
    return self.mutableArray.count;
}
- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column {
    return self.mutableArray[column];
}
```
4.我们会通过`MMComBoBoxViewDelegate`协议把选中的路径回调出来，这里我们选择回调存储路径的数组的本质是在于可能开发人员上传的不止是`title`，可能还有对应的`code`等一系列的字段。这样方便扩展。
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
```
文章地址：http://www.jianshu.com/p/f947ecbe8524
如果你觉得这篇文章对你有所帮助，欢迎like或star!谢谢！
