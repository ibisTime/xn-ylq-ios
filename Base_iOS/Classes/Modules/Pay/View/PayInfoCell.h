//
//  PayInfoCell.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/17.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayFuncModel.h"

@interface PayInfoCell : UITableViewCell

@property (nonatomic,strong) UILabel *infoLbl;

@property (nonatomic,strong) UIImageView *funcTypeImageV;

@property (nonatomic,strong) UIButton *selectedBtn;

@property (nonatomic,strong) PayFuncModel *pay;


@end
