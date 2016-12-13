//
//  MMHeader.h
//  MMPhotoView
//
//  Created by wyy on 16/11/10.
//  Copyright © 2016年 yyx. All rights reserved.
//

#ifndef MMHeader_h
#define MMHeader_h
#import "UIView+Extension.h"
#import "UIColor+Extension.h"
//
//static const CGFloat titleFontSize = 14.0f;
//static  CGFloat titleHorizontalMargin = 10.0f;       //左右的边距
//static  CGFloat distanceBetweenTitles= 10.0f;        //title之间的距离
//static  CGFloat titleScrollViewToTop = 0.0f;
//static  CGFloat collectionViewToBottom = 0.0f;
// CGFloat scale = [UIScreen mainScreen].scale;
#define scale [UIScreen mainScreen].scale
static  NSString *titleSelectedColor = @"4EBC72";
static const CGFloat  ButtonFontSize = 14.0f;
//MMPopupView

static const CGFloat PopupViewRowHeight = 44.0f;
static const CGFloat DistanceBeteewnPopupViewAndBottom = 40.0f;
static const CGFloat PopupViewTabBarHeight = 40.0f;
static const CGFloat LeftCellHorizontalMargin = 20.0f;
static const CGFloat LeftCellWidth = 100.0f;
//static const CGFloat
static  NSString *MainCellID = @"MainCellID";
static  NSString *SubCellID = @"SubCellID";
static const NSTimeInterval AnimationDuration= .4;
static const CGFloat ButtonHorizontalMargin = 10.0f;

/* fontSize*/
static const CGFloat MainTitleFontSize = 13.0f;
static const CGFloat SubTitleFontSize = 12.0f;
/* color */
static  NSString *SelectedBGColor = @"F2F2F2";
static  NSString *UnselectedBGColor = @"FFFFFF";
//MMComBoBoxView


//MMDropDownBox
static const CGFloat DropDownBoxFontSize = 12.0f;
static const CGFloat ArrowSide = 8.0f;
static const CGFloat ArrowToRight = 5.0f;
static const CGFloat DropDownBoxTitleHorizontalToArrow = 10.0f;
static const CGFloat DropDownBoxTitleHorizontalToLeft  = 10.0f;
#define kScreenHeigth [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#endif /* MMHeader_h */
