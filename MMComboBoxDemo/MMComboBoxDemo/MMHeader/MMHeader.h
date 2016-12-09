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




//MMPopupView
static const CGFloat PopupViewRowHeight = 44.0f;
static const CGFloat DistanceBeteewnPopupViewAndBottom = 40.0f;
static const CGFloat PopupViewtabBarHeight = 0.0f;

static  NSString *cellID = @"cellID";
static const NSTimeInterval AnimationDuration= .4;
//MMComBoBoxView


//MMDropDownBox
static const CGFloat DropDownBoxFontSize = 12.0f;
static const CGFloat DropDownBoxTitleHorizontalMargin = 10.0f;

#define kScreenHeigth [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#endif /* MMHeader_h */
