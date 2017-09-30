//
//  ApiConfig.h
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/9/21.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RunMode) {
    RunModeDis = 0,         //生产环境
    RunModeReview,          //审核环境
};

@interface ApiConfig : NSObject

@property (nonatomic, assign) RunMode runMode;

@property (nonatomic, copy) NSString *kind;

//API
//用户
@property (nonatomic, copy) NSString * userRegCode;         //注册
@property (nonatomic, copy) NSString * userInviteRegCode;   //邀请注册
@property (nonatomic, copy) NSString * userLoginCode;       //登录
@property (nonatomic, copy) NSString * userFindPwdCode;     //忘记密码
@property (nonatomic, copy) NSString * captchaCode;         //验证码
@property (nonatomic, copy) NSString * userChangeMobile;    //修改手机号
@property (nonatomic, copy) NSString * userChangeLoginName; //修改登录名
@property (nonatomic, copy) NSString * userSetTradePwd;     //设置交易密码
@property (nonatomic, copy) NSString * userFindTradePwd;    // 找回交易密码
@property (nonatomic, copy) NSString * userChangeUserPhoto; // 修改头像
@property (nonatomic, copy) NSString * userCkeyCvalue;      //根据ckey查询系统参数
@property (nonatomic, copy) NSString * imgUploadCode;       //七牛图片上传

@property (nonatomic, copy) NSString * userInfo;            //用户信息

+ (instancetype)config;

@end
