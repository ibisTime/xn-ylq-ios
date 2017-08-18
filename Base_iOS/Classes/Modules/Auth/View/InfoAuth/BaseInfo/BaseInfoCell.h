//
//  BaseInfoCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/9.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseInfoModel.h"

@interface BaseInfoCell : UITableViewCell

@property (nonatomic, strong) BaseInfoModel *baseInfoModel;

@property (nonatomic, strong) UILabel *rightLabel;

@end
