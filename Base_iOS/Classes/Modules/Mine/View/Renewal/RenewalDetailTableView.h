//
//  RenewalDetailTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "RenewalModel.h"

typedef void(^RenewalBlock)();

@interface RenewalDetailTableView : TLTableView

@property (nonatomic, strong) RenewalModel *renewal;

@property (nonatomic, copy) RenewalBlock renewalBlock;

@end
