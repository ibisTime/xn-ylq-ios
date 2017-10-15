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

    NSDictionary *statusDic = @{
                                @"0": @"立即申请",
                                @"1": @"认证中",
                                @"2": @"系统审核中",
                                @"3": @"已驳回",
                                @"4": @"审核通过 签约",
                                @"5": @"款项正在路上",
                                @"6": @"待还款",
                                @"7": @"已逾期",
                                @"11": @"打款失败",
                                };
    
    return statusDic[self.userProductStatus];
}

@end
