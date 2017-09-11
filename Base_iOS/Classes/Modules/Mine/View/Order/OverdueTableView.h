//
//  OverdueTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "OrderModel.h"

typedef void(^RenewalBlock)();

@interface OverdueTableView : TLTableView

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, copy) RenewalBlock renewalBlock;

@end
