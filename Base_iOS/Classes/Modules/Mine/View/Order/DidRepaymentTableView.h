//
//  DidRepaymentTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "OrderModel.h"

#import "DidLoanTableView.h"

typedef void(^OrderDetailBlock)(OrderDetailType type);

@interface DidRepaymentTableView : TLTableView

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, copy) OrderDetailBlock detailBlock;

@end
