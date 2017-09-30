//
//  AppDelegate.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"
#import "WXApi.h"
#import "TLWXManager.h"
#import "TLAlipayManager.h"

#import <ZMCreditSDK/ALCreditService.h>

#import "AppDelegate+Launch.h"
#import "AppDelegate+BaiduMap.h"

#import "NavigationController.h"
#import "TabbarViewController.h"
//#import "HomeVC.h"
#import "TLUserLoginVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - App Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //服务器环境
    [self configServiceAddress];
    
    //键盘
    [self configIQKeyboard];
    
    //配置芝麻信用
    [self configZMOP];
    
    //配置地图
    [self configMapKit];
    
    //配置魔蝎
//    [self configMoXie];
    
    //配置微信
    [self configWeChat];
    
    //配置根控制器
    [self configRootViewController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}


// iOS9 NS_AVAILABLE_IOS
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.host isEqualToString:@"certi.back"]) {
        
        //查询是否认证成功
        TLNetworking *http = [TLNetworking new];
        http.showView = [UIApplication sharedApplication].keyWindow;
        http.code = @"623046";
        http.parameters[@"bizNo"] = [TLUser user].tempBizNo;
        http.parameters[@"userId"] = [TLUser user].userId;
        
        [http postWithSuccess:^(id responseObject) {
            
            NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"isSuccess"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthResult" object:str];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        return YES;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [TLAlipayManager hadleCallBackWithUrl:url];
        return YES;
        
    } else {
        
        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
        
    }
    
    return YES;
}

// iOS9 NS_DEPRECATED_IOS
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"certi.back"]) {
        
        //查询是否认证成功
        TLNetworking *http = [TLNetworking new];
        http.showView = [UIApplication sharedApplication].keyWindow;
        http.code = @"623046";
        http.parameters[@"bizNo"] = [TLUser user].tempBizNo;
        
        [http postWithSuccess:^(id responseObject) {
            
            NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"isSuccess"]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RealNameAuthResult" object:str];
            
        } failure:^(NSError *error) {
            
            
        }];
        
        return YES;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        
        [TLAlipayManager hadleCallBackWithUrl:url];
        return YES;
        
    } else {
        
        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
    }
}

#pragma mark - Config
- (void)configServiceAddress {
    
    //配置环境
    [AppConfig config].runEnv = RunEnvDev;
    
}

- (void)configIQKeyboard {
    
    //
//    [IQKeyboardManager sharedManager].enable = YES;
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[ComposeVC class]];
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[SendCommentVC class]];
    
}

- (void)configWeChat {
    
    [[TLWXManager manager] registerApp];
}

- (void)configZMOP {
    
    [[ALCreditService sharedService] resgisterApp];
}

- (void)configRootViewController {
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self launchEventWithCompletionHandle:^(LaunchOption launchOption) {
        
        TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
        self.window.rootViewController = tabbarCtrl;
        
        //重新登录
        if([TLUser user].isLogin) {
            
            //初始化用户信息
            [[TLUser user] initUserData];

            [[TLUser user] reLogin];
            
        };
    
    }];
}

@end
