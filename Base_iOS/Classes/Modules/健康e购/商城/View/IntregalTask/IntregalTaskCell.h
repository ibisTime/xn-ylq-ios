//
//  IntregalTaskCell.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/28.
//  Copyright © 2017年 cuilukai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntregalTaskModel.h"

@interface IntregalTaskCell : UITableViewCell

@property (nonatomic, strong) UIButton *comfirmBtn;

@property (nonatomic, strong) IntregalTaskModel *task;

@end
