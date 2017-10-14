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
            self.companyCode = @"CD-YLQ000014";
            self.systemCode = @"CD-YLQ000014";
            
            switch (_runEnv) {
                    
                case RunEnvRelease: {
                    
                    self.qiniuDomain = @"http://oucrrtx1y.bkt.clouddn.com";
                    self.addr = @"http://116.62.193.233:3701";
                    
                }break;
                    
                case RunEnvDev: {
                    
                    self.qiniuDomain = @"http://oucrrtx1y.bkt.clouddn.com";
                    self.addr = @"http://121.43.101.148:3701";
                    
                }break;
                    
                case RunEnvTest: {
                    
                    self.qiniuDomain = @"http://oucrrtx1y.bkt.clouddn.com";
                    self.addr = @"http://118.178.124.16:3701";
                    
                }break;
                    
            }
        }break;
            
        case RunModeReview:
        {
            self.companyCode = @"CD-JKEG000011";
            self.systemCode = @"CD-JKEG000011";
            
            switch (_runEnv) {
                    
                case RunEnvRelease: {
                    
                    self.qiniuDomain = @"http://or4e1nykg.bkt.clouddn.com";
                    self.addr = @"http://116.62.114.86:8901";
                    
                }break;
                    
                case RunEnvDev: {
                    
                    self.qiniuDomain = @"http://or4e1nykg.bkt.clouddn.com";
                    self.addr = @"http://121.43.101.148:3401";
                    
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
