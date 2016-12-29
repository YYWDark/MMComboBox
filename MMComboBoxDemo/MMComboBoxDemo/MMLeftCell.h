//
//  MMLeftCell.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/12.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMItem.h"

@interface MMLeftCell : UITableViewCell

//- (void)updateSelectedState:(BOOL)isSelected;
@property (nonatomic, strong) MMItem *item;
@end
