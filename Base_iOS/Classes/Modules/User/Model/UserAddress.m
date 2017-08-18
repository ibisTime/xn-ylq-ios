//
//  UserAddress.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/18.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "UserAddress.h"

@implementation UserAddress

- (NSString *)totalAddress {
    
    return [[[self.province add:self.city] add:self.district] add:self.detailAddress];
    
}

@end
