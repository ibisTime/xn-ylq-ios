//
//  DataModel.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/25.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@end

@implementation SectionModel

- (void)setType:(DataType)type {

    _type = type;
    
    NSInteger flag = [_flag integerValue];
    
    switch (type) {
        case DataTypeSFRZ:
        {
            _img = flag == 0 ? @"身份认证未认证": @"身份认证";
        }
            break;
         
        case DataTypeBaseInfo:
        {
            _img = flag == 0 ? @"个人信息未认证": @"个人信息认证";
        }
            break;
        
        case DataTypeZMF:
        {
            _img = flag == 0 ? @"芝麻分未认证": @"芝麻分认证";
        }
            break;
        
        case DataTypeYYSRZ:
        {
            _img = flag == 0 ? @"运营商认证未认证": @"运营商认证";
        }
            break;
            
        case DataTypeTXLRZ:
        {
            _img = flag == 0 ? @"通讯录未认证": @"通讯录认证";
        }
            break;
            
        case DataTypeWXRZ:
        {
            _img = flag == 0 ? @"微信未认证": @"微信认证";
        }
            break;
            
        default:
            break;
    }
}

- (void)setFlag:(NSString *)flag {

    _flag = flag;
    
    NSInteger type = [_flag integerValue];

    switch (type) {
            
        case 0:
        {
            _authStatusStr = @"前往提交";
            
            _authStatusImg = @"提交";
            
            _color = [UIColor colorWithHexString:@"#3cb3f7"];
            
        }break;
            
        case 1:
        {
            _authStatusStr = @"已认证";
            
            _authStatusImg = @"已认证";
            
            _color = [UIColor colorWithHexString:@"#0cb8ae"];
            
        }break;
            
        case 2:
        {
            _authStatusStr = @"已过期";
            
            _authStatusImg = @"已过期";
            
            _color = [UIColor colorWithHexString:@"#ffd400"];
            
        }break;
            
        case 3:
        {
            _authStatusStr = @"已提交";
            
            _authStatusImg = @"已认证";
            
            _color = [UIColor colorWithHexString:@"#0cb8ae"];
            
        }break;
            
        default:
            break;
    }
}

@end
