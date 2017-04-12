//
//  MMDropDownBox.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMDropDownBoxDelegate;
@interface MMDropDownBox : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelected;                 
@property (nonatomic, weak) id<MMDropDownBoxDelegate> delegate;
- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title;
- (void)updateTitleState:(BOOL)isSelected;
- (void)updateTitleContent:(NSString *)title;
@end

@protocol MMDropDownBoxDelegate <NSObject>
/*点击了dropDownBox**/
- (void)didTapDropDownBox:(MMDropDownBox *)dropDownBox atIndex:(NSUInteger)index;
@end
