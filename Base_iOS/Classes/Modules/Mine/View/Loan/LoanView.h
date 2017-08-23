//
//  LoanView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef void(^LoanBlock)();

@interface LoanView : UIView

@property (nonatomic, strong) OrderModel *orderModel;

@property (nonatomic, copy) LoanBlock loanBlock;

@end
