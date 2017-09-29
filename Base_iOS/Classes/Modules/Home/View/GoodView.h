//
//  GoodView.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/7.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

typedef NS_ENUM(NSInteger, LoanType) {

    LoanTypeFirstStep = 0,  //第一步
    LoanTypeSecondStep,     //第二步
    LoanTypeCancel,         //取消
};

typedef void(^LoanBlock)(LoanType loanType, ProductModel *good);

@interface GoodView : UIView

@property (nonatomic, copy) LoanBlock loanBlock;

@property (nonatomic, strong) ProductModel *goodModel;

@property (nonatomic, assign) BOOL isCancel;

@end
