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
            _img = flag != 1 ? @"身份认证未认证": @"身份认证";
        }
            break;
         
        case DataTypeBaseInfo:
        {
            _img = flag != 1 ? @"个人信息未认证": @"个人信息认证";
        }
            break;
        
        case DataTypeZMF:
        {
            _img = flag != 1 ? @"芝麻分未认证": @"芝麻分认证";
        }
            break;
        
        case DataTypeYYSRZ:
        {
            _img = flag != 1 ? @"运营商认证未认证": @"运营商认证";
        }
            break;
            
        case DataTypeTXLRZ:
        {
            _img = flag != 1 ? @"通讯录未认证": @"通讯录认证";
        }
            break;
            
        case DataTypeWXRZ:
        {
            _img = flag != 1 ? @"微信未认证": @"微信认证";
        }
            break;
            
        case DataTypeRLSB:
        {
            _img = flag != 1 ? @"人脸识别_灰": @"人脸识别";
        }break;
            
        case DataTypeSCSFZ:
        {
            _img = flag != 1 ? @"身份证_灰": @"身份证上传";
        }break;
            
        default:
            break;
    }
}

- (void)setAuthStatusType:(NSString *)authStatusType {

    _authStatusType = authStatusType;
    
    AuthStatusType type = [authStatusType integerValue];
    
    switch (type) {
        
        case AuthStatusTypeCommit:
        {
            _authStatusStr = @"前往提交";
            
            _authStatusImg = @"提交";
            
            _color = [UIColor colorWithHexString:@"#3cb3f7"];
            
        }break;
        
        case AuthStatusTypeAuthenticated:
        {
            _authStatusStr = @"已认证";
            
            _authStatusImg = @"已认证";
            
            _color = [UIColor colorWithHexString:@"#0cb8ae"];
            
        }break;
        
        case AuthStatusTypeOverdue:
        {
            _authStatusStr = @"已过期";
            
            _authStatusImg = @"已过期";
            
            _color = [UIColor colorWithHexString:@"#ffd400"];
            
        }break;
        
        case AuthStatusTypeAuthenticating:
        {
            _authStatusStr = @"认证中";
            
            _authStatusImg = @"提交";
            
            _color = [UIColor colorWithHexString:@"#3cb3f7"];
            
        }break;
        
        case AuthStatusTypeCommited:
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
