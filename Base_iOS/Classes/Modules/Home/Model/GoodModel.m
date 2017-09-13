//
//  GoodModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "GoodModel.h"

@implementation GoodModel

- (NSString *)statusStr {

    NSDictionary *statusDic = @{
                                @"0": @"可申请",
                                @"1": @"认证中",
                                @"2": @"人工审核中",
                                @"3": @"已驳回",
                                @"4": @"已有额度",
                                @"5": @"等待放款中",
                                @"6": @"生效中",
                                @"7": @"已逾期",
                                @"11": @"打款失败",
                                };
    
    return statusDic[self.userProductStatus];
}

@end
