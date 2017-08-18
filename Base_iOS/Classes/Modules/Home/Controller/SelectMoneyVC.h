//
//  SelectMoneyVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/7.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, SelectGoodType) {

    SelectGoodTypeAuth = 0,     //去认证
    SelectGoodTypeSign,         //签约
};

@interface SelectMoneyVC : BaseViewController

@property (nonatomic, assign) SelectGoodType selectType;

@property (nonatomic, copy) NSString *code;

@end

