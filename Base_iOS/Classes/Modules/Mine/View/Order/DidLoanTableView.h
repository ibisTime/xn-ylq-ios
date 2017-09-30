//
//  DidLoanTableView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/16.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
#import "OrderModel.h"

typedef NS_ENUM(NSInteger, OrderDetailType) {
    
    OrderDetailTypeLoanContract = 0,    //借款合同
    OrderDetailTypeRenewal,             //续期列表
};

typedef void(^OrderDetailBlock)(OrderDetailType type);

@interface DidLoanTableView : TLTableView

@property (nonatomic, strong) OrderModel *order;

@property (nonatomic, copy) OrderDetailBlock detailBlock;

@end
