//
//  ApiConfig.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "ApiConfig.h"

@implementation ApiConfig

+ (instancetype)config {
    
    static dispatch_once_t onceToken;
    static ApiConfig *config;
    dispatch_once(&onceToken, ^{
        
        config = [[ApiConfig alloc] init];
        
    });
    
    return config;
}

- (void)setRunMode:(RunMode)runMode {
    
    _runMode = runMode;
    
    switch (_runMode) {
        case RunModeDis:
            {
                //用户
                self.kind = @"C";
                //注册
                self.userRegCode = @"805041";
                //邀请注册
                self.userInviteRegCode = @"623800";
                //登录
                self.userLoginCode = @"805050";
                //忘记密码
                self.userFindPwdCode = @"805063";
                //验证码
                self.captchaCode = @"630090";
                //修改手机号
                self.userChangeMobile = @"805061";
                //修改登录名
                self.userChangeLoginName = @"805150";
                //设置交易密码
                self.userSetTradePwd = @"805066";
                // 找回交易密码
                self.userFindTradePwd = @"805068";
                // 修改头像
                self.userChangeUserPhoto = @"805080";
                //根据ckey查询系统参数
                self.userCkeyCvalue = @"623917";
                //七牛图片上传
                self.imgUploadCode = @"630091";
                //用户信息
                self.userInfo = @"805121";
                
            }break;
            
        case RunModeReview:
        {
            
            //用户
            self.kind = @"f1";
            //注册
            self.userRegCode = @"805041";
            //邀请注册
            self.userInviteRegCode = @"805154";
            //登录
            self.userLoginCode = @"805043";
            //忘记密码
            self.userFindPwdCode = @"805048";
            //验证码
            self.captchaCode = @"805904";
            //修改手机号
            self.userChangeMobile = @"805047";
            //修改登录名
            self.userChangeLoginName = @"805150";
            //设置交易密码
            self.userSetTradePwd = @"805045";
            // 找回交易密码
            self.userFindTradePwd = @"805057";
            // 修改头像
            self.userChangeUserPhoto = @"805077";
            //根据ckey查询系统参数
            self.userCkeyCvalue = @"";
            //七牛图片上传
            self.imgUploadCode = @"630091";
            //用户信息
            self.userInfo = @"805056";
            
        }break;
            
        default:
            break;
    }
    
}
@end
