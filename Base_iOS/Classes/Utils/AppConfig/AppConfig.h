//
//  AppConfig.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/5/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, RunEnv) {
    RunEnvRelease = 0,
    RunEnvDev,
    RunEnvTest
};

typedef NS_ENUM(NSUInteger, ComPany) {
    ComPanyALL = 0, //业务全有
    ComPanyNoLoad, //没有借款业务
    ComPanyNoScore,//没有信用认证业务
    ComPanyOnlyMine//只有个人中心业务

};

FOUNDATION_EXPORT void TLLog(NSString *format, ...);

@interface AppConfig : NSObject

+ (instancetype)config;

@property (nonatomic,assign) RunEnv runEnv;

@property (nonatomic,assign) ComPany comPany;

@property (nonatomic, strong) NSString *systemCode;
@property (nonatomic, strong) NSString *companyCode;

//环信
@property (nonatomic, copy) NSString *chatKey;
//url请求地址
@property (nonatomic, strong) NSString *addr;
//@property (nonatomic,copy) NSString *aliPayKey;
@property (nonatomic, copy) NSString *qiniuDomain;
@property (nonatomic,strong) NSString *shareBaseUrl;
@property (nonatomic, assign) CGFloat bottomInsetHeight;


@property (nonatomic,copy, readonly) NSString *pushKey;
@property (nonatomic, copy, readonly) NSString *wxKey;
@property (nonatomic, copy, readonly) NSString *aliMapKey;
@property (nonatomic, copy, readonly) NSString *qiNiuKey;


- (NSString *)getUrl;

@end
