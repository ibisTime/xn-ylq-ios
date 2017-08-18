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

- (void)setAuthType:(AuthStatusType)authType {

    _authType = authType;
    
    switch (authType) {
            
        case AuthStatusTypeAuthentication:
        {
            _authStatusStr = @"前往提交";
            
            _authStatusImg = @"提交";
            
        }break;
            
        case AuthStatusTypeAuthenticated:
        {
            _authStatusStr = @"已认证";
            
            _authStatusImg = @"已认证";
            
        }break;
           
        case AuthStatusTypeCommit:
        {
            _authStatusStr = @"已提交";
            
            _authStatusImg = @"已认证";
            
        }break;
            
        case AuthStatusTypeExpired:
        {
            _authStatusStr = @"已过期";
            
            _authStatusImg = @"已过期";
            
        }break;
            
        default:
            break;
    }
}

@end
