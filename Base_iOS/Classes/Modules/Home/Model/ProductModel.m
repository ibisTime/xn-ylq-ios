//
//  ProductModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductModel

- (NSString *)statusStr {

    //待还款
    NSString *repayStr = [_hkDays integerValue] == 0 ? @"今日还款": [NSString stringWithFormat:@"还有%ld天还款", [_hkDays integerValue]];
    //已逾期
    NSString *overdueStr = [NSString stringWithFormat:@"已逾期%ld天", [_hkDays integerValue]];
    
    NSDictionary *statusDic = @{
                                @"0": @"立即申请",
                                @"1": @"认证中",
                                @"2": @"系统审核中",
                                @"3": @"已驳回",
                                @"4": @"审核通过 签约",
                                @"5": @"款项正在路上",
                                @"6": repayStr,
                                @"7": overdueStr,
                                @"11": @"打款失败",
                                };
    
    return statusDic[self.userProductStatus];
}

@end
