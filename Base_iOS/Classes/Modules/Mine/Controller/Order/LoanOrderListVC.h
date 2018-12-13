//
//  LoanOrderListVC.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger,LoanOrderStatus) {
    LoanOrderStatusAll  = 0,         //全部

    LoanOrderStatusWillAudit = 1,       //待审核
    LoanOrderStatusWillLoan = 2,    // 待放款
    LoanOrderStatusAuditFailure = 3,        //审核失败
    LoanOrderStatusDidLoan = 4,    // 待还款
    LoanOrderStatusDidRepayment = 5,    //已还款
    LoanOrderStatusDidOverdue = 6,      //已逾期款
    LoanOrderStatusDidNO = 7,    //无
    LoanOrderStatusMoneyFailure  = 8,         //打款失败

};

@interface LoanOrderListVC : BaseViewController

@property (nonatomic,assign) LoanOrderStatus status;

@property (nonatomic,copy) NSString *statusCode;

@end
