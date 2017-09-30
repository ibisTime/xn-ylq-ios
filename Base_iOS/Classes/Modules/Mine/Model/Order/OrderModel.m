//
//  OrderModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/8/15.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (void)setStatus:(NSString *)status {

    _status = status;
    
    NSString *resc = @"";
    
    NSString *imageStr = @"";
    
    NSInteger index = [status integerValue];
    
    switch (index) {
        case 0:
        {
            resc = @"审核中";
            imageStr = @"待审核";
            
        }break;
            
        case 1:
        {
            resc = @"审核通过";
            imageStr = @"待放款";

        }break;
            
        case 2:
        {
            resc = @"审核不通过";
            imageStr = @"审核不通过";

        }break;
            
        case 3:
        {
            resc = @"已放款";
            imageStr = @"待还款";

        }break;
            
        case 4:
        {
            resc = @"已还款";
            imageStr = @"已还款";

        }break;
            
        case 5:
        {
            resc = @"已逾期";
            imageStr = @"已逾期";

        }break;
            
        case 7:
        {
            resc = @"打款失败";
            imageStr = @"打款失败";

        }break;
            
        default:
            break;
    }
    
    self.resc = resc;
    
    self.imageStr = imageStr;
}

@end

@implementation UserInfo

@end


