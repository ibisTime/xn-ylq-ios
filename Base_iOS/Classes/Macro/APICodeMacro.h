//
//  APICodeMacro.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/6/8.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#ifndef APICodeMacro_h
#define APICodeMacro_h

//用户
//验证码
#define CAPTCHA_CODE            [ApiConfig config].captchaCode
//注册
#define USER_REG_CODE           [ApiConfig config].userRegCode
//邀请注册
#define USER_INVITE_REG_CODE    [ApiConfig config].userInviteRegCode
//登录
#define USER_LOGIN_CODE         [ApiConfig config].userLoginCode
//忘记密码
#define USER_FIND_PWD_CODE      [ApiConfig config].userFindPwdCode
//修改手机号
#define USER_CAHNGE_MOBILE      [ApiConfig config].userChangeMobile
//修改登录名
#define USER_CHANGE_LOGIN_NAME  [ApiConfig config].userChangeLoginName
//设置交易密码
#define USER_SET_TRADE_PWD      [ApiConfig config].userSetTradePwd
// 找回交易密码
#define USER_FIND_TRADE_PWD     [ApiConfig config].userFindTradePwd
// 修改头像
#define USER_CHANGE_USER_PHOTO  [ApiConfig config].userChangeUserPhoto
//根据ckey查询系统参数
#define USER_CKEY_CVALUE        [ApiConfig config].userCkeyCvalue
//七牛图片上传
#define IMG_UPLOAD_CODE         [ApiConfig config].imgUploadCode
//用户信息
#define USER_INFO       [ApiConfig config].userInfo


#endif /* APICodeMacro_h */
