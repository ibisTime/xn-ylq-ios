//
//  AppConfig.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/5/11.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppConfig.h"

void TLLog(NSString *format, ...) {
    
    if ([AppConfig config].runEnv != RunEnvRelease) {
        
        va_list argptr;
        va_start(argptr, format);
        NSLogv(format, argptr);
        va_end(argptr);
    }
    
}

@implementation AppConfig

+ (instancetype)config {
    
    static dispatch_once_t onceToken;
    static AppConfig *config;
    dispatch_once(&onceToken, ^{
        
        config = [[AppConfig alloc] init];
        
    });
    
    return config;
}

- (void)setRunEnv:(RunEnv)runEnv {
    
    _runEnv = runEnv;
    
    switch ([ApiConfig config].runMode) {
        case RunModeDis:
        {
            
            self.companyCode = @"GS201901211113140363288";
            self.systemCode = @"GS2018112119133810071833";
            
            self.bottomInsetHeight = kDevice_Is_iPhoneX == YES ? 34: 0;
            
            switch (_runEnv) {
                    
                case RunEnvRelease: {
                    
                    self.qiniuDomain = @"http://oucrrtx1y.bkt.clouddn.com";
//                    self.addr = @"http://116.62.193.233:3701";
                    self.addr = @"http://47.110.55.234:3701";

                    
                }break;
                    
                case RunEnvDev: {
                    
                    self.qiniuDomain = @"http://oucrrtx1y.bkt.clouddn.com";
                    self.addr = @"http://120.26.6.213:7901";
                    
                }break;
                    
                case RunEnvTest: {
                    
                    self.qiniuDomain = @"http://oucrrtx1y.bkt.clouddn.com";
                    self.addr = @"http://47.99.163.139:3701";
                    
                }break;
                    
            }
        }break;
            
        case RunModeReview:
        {
            self.companyCode = @"GS2018112119133810071833";
            self.systemCode = @"CD-JKEG000011";
            
            self.bottomInsetHeight = kDevice_Is_iPhoneX == YES ? 34: 0;

            switch (_runEnv) {
                    
                case RunEnvRelease: {
                    
                    self.qiniuDomain = @"http://or4e1nykg.bkt.clouddn.com";
                    self.addr = @"http://116.62.114.86:8901";
                    
                }break;
                    
                case RunEnvDev: {
                    
                    self.qiniuDomain = @"http://or4e1nykg.bkt.clouddn.com";
//                    self.addr = @"http://121.43.101.148:3401";
                     self.addr = @"http://120.26.6.213:7901";

                    
                    
                }break;
                    
                case RunEnvTest: {
                    
                    self.qiniuDomain = @"http://or4e1nykg.bkt.clouddn.com";
                    self.addr = @"http://118.178.124.16:3401";
                    
                }break;
                    
            }
        }break;
            
        default:
            break;
    }
    
}

- (NSString *)pushKey {
    
    return @"";
    
}

- (NSString *)getUrl {

    return [self.addr stringByAppendingString:@"/forward-service/api"];
}

- (NSString *)aliMapKey {
    
    return @"";
}


- (NSString *)wxKey {
    
    return @"wx763220fe7a9672c0";
}

@end
